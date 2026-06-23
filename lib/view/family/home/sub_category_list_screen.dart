import 'dart:async';
import 'package:familyside/core/router/router_path.dart';
import 'package:familyside/model/gift_api_item.dart';
import 'package:familyside/provider/family/home_provider.dart';
import 'package:familyside/view/family/explorer/models/explorer_data.dart';
import 'package:familyside/view/family/explorer/models/explorer_map_item.dart';
import 'package:familyside/view/family/explorer/models/explorer_map_screen_config.dart';
import 'package:familyside/view/family/home/family_home_screen.dart';
import 'package:familyside/view/family/home/sub_category_list_screen_config.dart';
import 'package:familyside/view/widgets/custom_icon_button.dart';
import 'package:familyside/view/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/view/widgets/custom_app_bar.dart';
import 'package:familyside/view/widgets/event_card.dart';
import 'package:familyside/view/widgets/category_filter_bottom_sheet.dart';
import 'package:go_router/go_router.dart';

class SubCategoryListScreen extends ConsumerStatefulWidget {
  final SubCategoryListScreenConfig config;

  const SubCategoryListScreen({super.key, required this.config});

  @override
  ConsumerState<SubCategoryListScreen> createState() =>
      _SubCategoryListScreenState();
}

class _SubCategoryListScreenState extends ConsumerState<SubCategoryListScreen> {
  final TextEditingController searchController = TextEditingController();
  CategoryFilterResultModel? _currentFilters;
  Timer? _searchDebounce;

  // Original unfiltered data
  List<RecommendedItemModel> _items = [];
  List<GiftApiItem> _apiItems = [];

  // UI state
  bool _isLoading = false;
  bool _hasError = false;
  String? _emptyMessage;

  // Search & filter state
  String _searchQuery = '';
  List<RecommendedItemModel> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    if (widget.config.subCategoryName != null) {
      _fetchItems();
    } else {
      _items = widget.config.items;
      _applyLocalFilters();
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  Future<void> _fetchItems() async {
    final name = widget.config.subCategoryName;
    if (name == null) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
      _emptyMessage = null;
    });

    final apiItems = await ref
        .read(homeProviderProvider.notifier)
        .fetchSubCategoryRecommendations(name);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      if (apiItems == null) {
        _hasError = true;
        _emptyMessage = 'Failed to load items. Please try again.';
      } else if (apiItems.isEmpty) {
        _emptyMessage = 'No items found in "${widget.config.title}"';
      } else {
        _apiItems = apiItems;
        _items = apiItems.map(_apiItemToRecommended).toList();
        _applyLocalFilters();
      }
    });
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

  // ─── Local Search & Filter Logic ───────────────────────────────────

  void _onSearchChanged(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() {
        _searchQuery = query.toLowerCase().trim();
        _applyLocalFilters();
      });
    });
  }

  void _applyLocalFilters() {
    _filteredItems = _items.where((item) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final matchesSearch = item.title.toLowerCase().contains(_searchQuery) ||
            item.category.toLowerCase().contains(_searchQuery) ||
            item.tag.toLowerCase().contains(_searchQuery) ||
            item.ageRange.toLowerCase().contains(_searchQuery);
        if (!matchesSearch) return false;
      }

      // Age range filter
      if (_currentFilters != null && _currentFilters!.ages.isNotEmpty) {
        if (item.ageRange.isEmpty || item.ageRange == 'N/A') return false;
        final matchesAge = _currentFilters!.ages.any((filterAge) =>
            _normalizeAgeRange(item.ageRange) == _normalizeAgeRange(filterAge));
        if (!matchesAge) return false;
      }

      // Distance filter
      if (_currentFilters != null &&
          _currentFilters!.distance.isNotEmpty &&
          _currentFilters!.distance != '1 km') {
        final itemDistKm = _parseDistance(item.distance);
        final filterDistKm = _parseDistanceBound(_currentFilters!.distance);
        if (itemDistKm == null || itemDistKm > filterDistKm) return false;
      }

      return true;
    }).toList();
  }

  /// Normalizes age range strings to a comparable key
  String _normalizeAgeRange(String range) {
    if (range == 'Age: 0-20 years' || range == '0-3 years') return '0-3';
    if (range == '3-8 years') return '3-8';
    if (range == '8-13 years') return '8-13';
    if (range == '15+ years' || range == '15+') return '15+';
    return range;
  }

  /// Parses a display distance like "0.05 km" → 0.05
  double? _parseDistance(String distance) {
    if (distance == 'N/A' || distance.isEmpty) return null;
    final parts = distance.split(' ');
    return double.tryParse(parts.first);
  }

  /// Parses a filter distance bound like "6-10km" → 10, "10+km" → 999
  double _parseDistanceBound(String filter) {
    if (filter == '1 km') return 1;
    if (filter == '2-5km') return 5;
    if (filter == '6-10km') return 10;
    if (filter == '10+km') return 999;
    return double.infinity;
  }

  void _clearFilters() {
    setState(() {
      _currentFilters = null;
      _applyLocalFilters();
    });
  }

  void _clearSearch() {
    searchController.clear();
    setState(() {
      _searchQuery = '';
      _applyLocalFilters();
    });
  }

  bool get _hasActiveFilters {
    if (_currentFilters == null) return false;
    return (_currentFilters!.distance.isNotEmpty &&
            _currentFilters!.distance != '1 km') ||
        _currentFilters!.ages.isNotEmpty;
  }

  // ─── Filter Bottom Sheet ───────────────────────────────────────────

  void _openFilterBottomSheet() async {
    final result = await showModalBottomSheet<CategoryFilterResultModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          CategoryFilterBottomSheet(initialFilters: _currentFilters),
    );

    if (result != null && mounted) {
      setState(() {
        _currentFilters = result;
        _applyLocalFilters();
      });
    }
  }

  void _openMapScreen() {
    context.push(
      RouterPath.familyExplorerMapScreen,
      extra: ExplorerMapScreenConfig(
        items:
            ExplorerData.toMapItems(_filteredItems, type: ExplorerItemType.activity),
        initialCategory: 'All',
      ),
    );
  }

  // ─── Build ─────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              CustomAppBar(title: widget.config.title),
              SizedBox(height: 24.h),
              _buildSearchSection(),
              if (_hasActiveFilters) ...[
                SizedBox(height: 12.h),
                _buildActiveFilterChips(),
              ],
              if (_items.isNotEmpty && (_searchQuery.isNotEmpty || _hasActiveFilters))
                Padding(
                  padding: EdgeInsets.only(top: 12.h),
                  child: _buildResultCount(),
                ),
              SizedBox(height: 16.h),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCount() {
    return Row(
      children: [
        Text(
          'Showing ${_filteredItems.length} of ${_items.length} results',
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.lightText,
          ),
        ),
        const Spacer(),
        if (_searchQuery.isNotEmpty)
          GestureDetector(
            onTap: _clearSearch,
            child: Text(
              'Clear search',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryLight,
              ),
            ),
          ),
      ],
    );
  }

  // ─── Body ──────────────────────────────────────────────────────────

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError) {
      return RefreshIndicator(
        onRefresh: _fetchItems,
        child: ListView(
          children: [
            SizedBox(height: 120.h),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48.sp, color: AppColors.grey),
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.w),
                    child: Text(
                      _emptyMessage ?? 'Something went wrong',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14.sp, color: AppColors.grey),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton.icon(
                    onPressed: _fetchItems,
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // No data from API
    if (_items.isEmpty) {
      return RefreshIndicator(
        onRefresh: _fetchItems,
        child: ListView(
          children: [
            SizedBox(height: 160.h),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 48.sp,
                    color: AppColors.grey,
                  ),
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.w),
                    child: Text(
                      _emptyMessage ?? 'No items found',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Items loaded but all filtered out
    if (_filteredItems.isEmpty) {
      return RefreshIndicator(
        onRefresh: _fetchItems,
        child: ListView(
          children: [
            SizedBox(height: 120.h),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 48.sp,
                    color: AppColors.grey,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No results match your search',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  if (_searchQuery.isNotEmpty)
                    TextButton(
                      onPressed: _clearSearch,
                      child: const Text('Clear search'),
                    ),
                  if (_hasActiveFilters)
                    TextButton(
                      onPressed: _clearFilters,
                      child: const Text('Clear filters'),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Items with results
    return RefreshIndicator(
      onRefresh: _fetchItems,
      child: ListView.builder(
        itemCount: _filteredItems.length,
        itemBuilder: (context, index) {
          final item = _filteredItems[index];
          // Find the original index in _items to map back to _apiItems
          final originalIndex = _items.indexOf(item);
          return EventCard(
            imagePath: item.imagePath,
            category: item.category,
            date: item.date,
            title: item.title,
            price: item.price,
            distance: item.distance,
            ageRange: item.ageRange,
            tag: item.tag,
            onTap: originalIndex >= 0 && originalIndex < _apiItems.length
                ? _navigateToDetail(originalIndex)
                : null,
          );
        },
      ),
    );
  }

  VoidCallback _navigateToDetail(int apiIndex) {
    return () {
      if (apiIndex < 0 || apiIndex >= _apiItems.length) return;
      final apiItem = _apiItems[apiIndex];
      final tag = apiItem.itemType.toLowerCase();
      if (tag == 'event') {
        context.push(RouterPath.familyEventDetailsScreen, extra: apiItem.id);
      } else if (tag == 'gift') {
        context.push(RouterPath.familyGiftDetailsScreen, extra: apiItem.id);
      } else {
        context.push(RouterPath.familyActivityDetailsScreen, extra: apiItem.id);
      }
    };
  }

  // ─── Filter Chips ──────────────────────────────────────────────────

  Widget _buildActiveFilterChips() {
    final chips = <Widget>[];

    if (_currentFilters!.distance.isNotEmpty && _currentFilters!.distance != '1 km') {
      chips.add(_buildChip(
        label: 'Distance: ${_currentFilters!.distance}',
        onRemove: () {
          setState(() {
            _currentFilters = CategoryFilterResultModel(
              distance: '',
              review: _currentFilters!.review,
              ages: _currentFilters!.ages,
            );
            _applyLocalFilters();
          });
        },
      ));
    }

    for (final age in _currentFilters!.ages) {
      chips.add(_buildChip(
        label: 'Age: $age',
        onRemove: () {
          setState(() {
            final updated = List<String>.from(_currentFilters!.ages)
              ..remove(age);
            _currentFilters = CategoryFilterResultModel(
              distance: _currentFilters!.distance,
              review: _currentFilters!.review,
              ages: updated,
            );
            _applyLocalFilters();
          });
        },
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

  Widget _buildChip({required String label, required VoidCallback onRemove}) {
    return Container(
      margin: EdgeInsets.only(right: 8.w),
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
            onTap: onRemove,
            child: Icon(Icons.close, size: 14.sp, color: AppColors.primaryLight),
          ),
        ],
      ),
    );
  }

  // ─── Search Section ────────────────────────────────────────────────

  Widget _buildSearchSection() {
    return Row(
      children: [
        Expanded(
          child: SearchBarWidget(
            controller: searchController,
            hintText: 'Search...',
            onChanged: _onSearchChanged,
          ),
        ),
        SizedBox(width: 12.w),
        CustomIconButton(
          assetPath: 'assets/logo/filter.svg',
          containerHeight: 48.h,
          containerWidth: 48.w,
          borderRadius: 8.r,
          iconWidth: 24.w,
          iconHeight: 24.h,
          onTap: _openFilterBottomSheet,
        ),
        SizedBox(width: 12.w),
        CustomIconButton(
          assetPath: 'assets/logo/location.svg',
          containerHeight: 48.h,
          containerWidth: 48.w,
          borderRadius: 8.r,
          iconWidth: 24.w,
          iconHeight: 24.h,
          onTap: _openMapScreen,
        ),
      ],
    );
  }
}
