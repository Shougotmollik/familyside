import 'package:familyside/core/router/router_path.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/model/gift_api_item.dart';
import 'package:familyside/model/gift_item_model.dart';
import 'package:familyside/provider/family/explorer_provider.dart';
import 'package:familyside/view/family/explorer/widgets/activity_card.dart';
import 'package:familyside/view/family/explorer/widgets/explorer_header.dart';
import 'package:familyside/view/family/explorer/widgets/explorer_screen_skeleton.dart';
import 'package:familyside/view/family/explorer/widgets/explorer_tab_bar.dart';
import 'package:familyside/view/family/gift/widgets/gift_card.dart';
import 'package:familyside/view/family/gift/widgets/gift_flow.dart';
import 'package:familyside/view/family/gift/widgets/gift_list_model.dart';
import 'package:familyside/view/family/home/family_home_screen.dart';
import 'package:familyside/view/widgets/event_card.dart';
import 'package:familyside/model/filter_result_model.dart';
import 'package:familyside/view/widgets/home_filter_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ExplorerScreen extends ConsumerStatefulWidget {
  const ExplorerScreen({super.key});

  @override
  ConsumerState<ExplorerScreen> createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends ConsumerState<ExplorerScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  FilterResultModel? _currentFilters;
  final Set<int> _loadedTabs = {};
  final Set<int> _bookmarkedGiftIndices = {};
  final List<GiftListModel> _giftLists = [];

  static const List<String> _itemTypes = ['activity', 'event', 'gift'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: ExplorerTabBar.tabs.length,
      vsync: this,
    );
    _tabController.addListener(_onTabChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchForTab(0);
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      final tabIndex = _tabController.index;
      // Only fetch if this tab hasn't been loaded yet
      if (!_loadedTabs.contains(tabIndex)) {
        _fetchForTab(tabIndex);
      }
    }
  }

  void _fetchForTab(int tabIndex) {
    if (tabIndex < 0 || tabIndex >= _itemTypes.length) return;
    _loadedTabs.add(tabIndex);
    ref.read(explorerProviderProvider.notifier).fetchExplorerItems(
      itemType: _itemTypes[tabIndex],
      filters: _currentFilters,
    );
  }

  void _openMapScreen() {
    context.push(RouterPath.familyExplorerMapScreen);
  }

  Future<void> _openFilterBottomSheet() async {
    final result = await showModalBottomSheet<FilterResultModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          HomeFilterBottomSheet(initialFilters: _currentFilters),
    );

    if (result != null && mounted) {
      setState(() => _currentFilters = result);
      ref.read(explorerProviderProvider.notifier).fetchExplorerItems(
        itemType: _itemTypes[_tabController.index],
        filters: result,
      );
    }
  }

  void _clearFilters() {
    setState(() => _currentFilters = null);
    ref.read(explorerProviderProvider.notifier).fetchExplorerItems(
      itemType: _itemTypes[_tabController.index],
    );
  }

  void _removeFilter(String filterKey, String filterValue) {
    if (_currentFilters == null) return;

    final updated = FilterResultModel(
      location: filterKey == 'location' ? '' : _currentFilters!.location,
      categories: filterKey == 'categories'
          ? _currentFilters!.categories.where((c) => c != filterValue).toList()
          : _currentFilters!.categories,
      ages: filterKey == 'ages'
          ? _currentFilters!.ages.where((a) => a != filterValue).toList()
          : _currentFilters!.ages,
      price: filterKey == 'price' ? 'All' : _currentFilters!.price,
    );

    final hasAnyFilter = updated.location.isNotEmpty ||
        updated.categories.isNotEmpty ||
        updated.ages.isNotEmpty ||
        updated.price != 'All';

    setState(() => _currentFilters = hasAnyFilter ? updated : null);
    ref.read(explorerProviderProvider.notifier).fetchExplorerItems(
      itemType: _itemTypes[_tabController.index],
      filters: hasAnyFilter ? updated : null,
    );
  }

  Future<void> _openAddToGiftList(GiftItemModel item) async {
    final result = await GiftFlow.showAddToGiftList(
      context,
      item: item,
      giftLists: _giftLists,
      onListCreated: (list) => setState(() => _giftLists.add(list)),
    );
    if (result != null && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Added to ${result.list.name}')));
    }
  }

  RecommendedItemModel _apiItemToRecommended(GiftApiItem item) {
    final formattedDate = item.dateLabel ?? '';
    return RecommendedItemModel(
      imagePath: item.imageUrl ?? '',
      category: item.categoryName ?? '',
      date: formattedDate,
      title: item.name,
      price: item.price.toStringAsFixed(0),
      distance: item.distanceKm != null
          ? '${item.distanceKm!.toStringAsFixed(2)} km'
          : 'N/A',
      ageRange: item.ageRange ?? '',
      tag: item.isRecommended ? 'Recommended' : item.itemType,
    );
  }

  GiftItemModel _apiToGiftItemModel(GiftApiItem item) {
    return GiftItemModel(
      imagePath: item.imageUrl ?? '',
      title: item.name,
      price: item.price.toStringAsFixed(0),
      description: item.categoryName ?? '',
      location: item.location ?? 'N/A',
    );
  }

  bool get _hasAnyFilter {
    if (_currentFilters == null) return false;
    return _currentFilters!.location.isNotEmpty ||
        _currentFilters!.categories.isNotEmpty ||
        _currentFilters!.ages.isNotEmpty ||
        _currentFilters!.price != 'All';
  }

  int get _filterCount {
    if (_currentFilters == null) return 0;
    int count = 0;
    if (_currentFilters!.location.isNotEmpty) count++;
    if (_currentFilters!.categories.isNotEmpty) count += _currentFilters!.categories.length;
    if (_currentFilters!.ages.isNotEmpty) count += _currentFilters!.ages.length;
    if (_currentFilters!.price != 'All') count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final explorerState = ref.watch(explorerProviderProvider);

    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
              child: ExplorerHeader(
                viewMode: ExplorerViewMode.list,
                onViewModeChanged: (mode) {
                  if (mode == ExplorerViewMode.map) {
                    _openMapScreen();
                  }
                },
                onFilterTap: _openFilterBottomSheet,
                filterCount: _filterCount,
                hasFilters: _hasAnyFilter,
              ),
            ),
            if (_hasAnyFilter)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: _buildActiveFilterChips(),
              ),
            ExplorerTabBar(controller: _tabController),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  // Clear loaded state so data re-fetches on tab change too
                  _loadedTabs.clear();
                  _loadedTabs.add(_tabController.index);
                  await ref.read(explorerProviderProvider.notifier).fetchExplorerItems(
                    itemType: _itemTypes[_tabController.index],
                    filters: _currentFilters,
                  );
                },
                child: explorerState.when(
                  loading: () => const ExplorerScreenSkeleton(),
                  error: (err, _) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error: $err', textAlign: TextAlign.center),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: () => _fetchForTab(_tabController.index),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                  data: (items) {
                    if (items.isEmpty) {
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: 300.h,
                          child: Center(
                            child: Text(
                              'No ${ExplorerTabBar.tabs[_tabController.index].toLowerCase()} found',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    if (_tabController.index == 2) {
                      // Gifts tab
                      final giftModels = items.map(_apiToGiftItemModel).toList();
                      return _ExplorerGiftsTab(
                        items: giftModels,
                        bookmarkedIndices: _bookmarkedGiftIndices,
                        onBookmarkTap: (index) {
                          setState(() {
                            if (_bookmarkedGiftIndices.contains(index)) {
                              _bookmarkedGiftIndices.remove(index);
                            } else {
                              _bookmarkedGiftIndices.add(index);
                            }
                          });
                        },
                        onAddToGiftList: (item) => _openAddToGiftList(item),
                        onShareTap: (item) => GiftFlow.showShareGiftCard(context, item),
                      );
                    } else {
                      return _ExplorerListTab(
                        items: items.map(_apiItemToRecommended).toList(),
                        itemBuilder: (recommended) {
                          if (_tabController.index == 0) {
                            return ActivityCard(
                              imagePath: recommended.imagePath,
                              category: recommended.category,
                              date: recommended.date,
                              title: recommended.title,
                              price: recommended.price,
                              distance: recommended.distance,
                              ageRange: recommended.ageRange,
                              tag: recommended.tag,
                            );
                          } else {
                            return EventCard(
                              imagePath: recommended.imagePath,
                              category: recommended.category,
                              date: recommended.date,
                              title: recommended.title,
                              price: recommended.price,
                              distance: recommended.distance,
                              ageRange: recommended.ageRange,
                              tag: recommended.tag,
                            );
                          }
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFilterChips() {
    final chips = <Widget>[];

    if (_currentFilters!.location.isNotEmpty) {
      chips.add(_filterChip(
        label: _currentFilters!.location,
        filterKey: 'location',
        filterValue: _currentFilters!.location,
      ));
    }
    for (final cat in _currentFilters!.categories) {
      chips.add(_filterChip(
        label: cat,
        filterKey: 'categories',
        filterValue: cat,
      ));
    }
    for (final age in _currentFilters!.ages) {
      chips.add(_filterChip(
        label: age,
        filterKey: 'ages',
        filterValue: age,
      ));
    }
    if (_currentFilters!.price != 'All') {
      chips.add(_filterChip(
        label: _currentFilters!.price,
        filterKey: 'price',
        filterValue: _currentFilters!.price,
      ));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...chips,
          GestureDetector(
            onTap: _clearFilters,
            child: Container(
              margin: EdgeInsets.only(right: 8.w),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: AppColors.lightText),
              ),
              child: Text(
                'Clear all',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.lightText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip({
    required String label,
    required String filterKey,
    required String filterValue,
  }) {
    return Container(
      margin: EdgeInsets.only(right: 8.w, bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.primaryLight.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryLight,
            ),
          ),
          SizedBox(width: 4.w),
          GestureDetector(
            onTap: () => _removeFilter(filterKey, filterValue),
            child: Icon(
              Icons.close,
              size: 14.sp,
              color: AppColors.primaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExplorerListTab extends StatelessWidget {
  const _ExplorerListTab({required this.items, required this.itemBuilder});

  final List<RecommendedItemModel> items;
  final Widget Function(RecommendedItemModel item) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      itemCount: items.length,
      itemBuilder: (context, index) => itemBuilder(items[index]),
    );
  }
}

class _ExplorerGiftsTab extends StatelessWidget {
  const _ExplorerGiftsTab({
    required this.items,
    required this.bookmarkedIndices,
    required this.onBookmarkTap,
    required this.onAddToGiftList,
    required this.onShareTap,
  });

  final List<GiftItemModel> items;
  final Set<int> bookmarkedIndices;
  final ValueChanged<int> onBookmarkTap;
  final void Function(GiftItemModel item) onAddToGiftList;
  final void Function(GiftItemModel item) onShareTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GiftCard(
          imagePath: item.imagePath,
          title: item.title,
          price: item.price,
          description: item.description,
          location: item.location,
          isBookmarked: bookmarkedIndices.contains(index),
          onTap: () => context.push(
            RouterPath.familyGiftDetailsScreen,
            extra: item,
          ),
          onAddToGiftList: () => onAddToGiftList(item),
          onShareTap: () => onShareTap(item),
          onBookmarkTap: () => onBookmarkTap(index),
        );
      },
    );
  }
}
