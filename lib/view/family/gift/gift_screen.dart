import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:familyside/core/router/router_path.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/model/gift_api_item.dart';
import 'package:familyside/model/gift_item_model.dart';
import 'package:familyside/model/sp_home_header.dart';
import 'package:familyside/provider/family/gift_provider.dart';
import 'package:familyside/provider/family/home_provider.dart';
import 'package:familyside/utils/app_snackbar.dart';
import 'package:familyside/view/family/gift/gift_all_screen.dart';
import 'package:familyside/view/family/gift/widgets/my_gift_list_models.dart';
import 'package:familyside/view/family/gift/widgets/gift_card.dart';
import 'package:familyside/view/family/gift/widgets/gift_filter_bottom_sheet.dart';
import 'package:familyside/model/gift_filter_result_model.dart';
import 'package:familyside/view/family/gift/widgets/gift_flow.dart';
import 'package:familyside/view/family/gift/widgets/gift_screen_skeleton.dart';
import 'package:familyside/view/family/gift/widgets/gift_list_model.dart';
import 'package:familyside/view/widgets/custom_icon_button.dart';
import 'package:familyside/view/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class GiftScreen extends ConsumerStatefulWidget {
  const GiftScreen({super.key});

  @override
  ConsumerState<GiftScreen> createState() => _GiftScreenState();
}

class _GiftScreenState extends ConsumerState<GiftScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  GiftFilterResultModel? _currentFilters;
  Timer? _debounce;
  final Set<String> _bookmarkedGiftKeys = {};
  final List<SavedGiftItemModel> _savedGiftsWithoutList = [];
  List<GiftListModel> _giftLists = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeState = ref.read(homeProviderProvider);
      if (homeState.value?['header'] == null) {
        ref.read(homeProviderProvider.notifier).fetchHomeData();
      }
      ref.read(giftProviderProvider.notifier).fetchGifts(
        filters: _currentFilters,
        category: _selectedCategory,
      );
      _loadGiftLists();
    });
  }

  Future<void> _loadGiftLists() async {
    final response = await ref
        .read(giftProviderProvider.notifier)
        .fetchGiftLists();
    if (!mounted) return;
    setState(() {
      _giftLists = response.folders.map((f) => GiftListModel(
        id: f.id.toString(),
        name: f.name,
        occasion: f.occasion,
        imagePath: f.imageUrl,
      )).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _openCreateNewList() async {
    final list = await GiftFlow.showCreateNewList(context);
    if (list != null && mounted) {
      setState(() => _giftLists.add(list));
      AppSnackbar.show(
        message: 'Created list "${list.name}"',
        type: SnackType.success,
      );
    }
  }

  Future<void> _openCreateGiftBottomSheet([GiftApiItem? item]) async {
    final firstItem = _giftItems.firstOrNull;
    final giftItem = item ?? firstItem;
    if (giftItem == null) return;
    await GiftFlow.showCreateGiftCard(context, _toGiftItemModel(giftItem));
  }

  Future<void> _openAddToGiftList(GiftApiItem item) async {
    await _loadGiftLists();

    final result = await GiftFlow.showAddToGiftList(
      context,
      item: _toGiftItemModel(item),
      giftLists: _giftLists,
      onListCreated: (list) => setState(() => _giftLists.add(list)),
    );

    if (result == null || !mounted) return;

    final folderId = int.tryParse(result.list.id);
    if (folderId == null) {
      AppSnackbar.show(
        message: 'Could not add to this list. Please try again.',
        type: SnackType.error,
      );
      return;
    }

    final success = await ref
        .read(giftProviderProvider.notifier)
        .addItemToFolder(folderId: folderId, itemId: item.id);

    if (!mounted) return;

    if (success) {
      AppSnackbar.show(
        message: '"${item.name}" added to "${result.list.name}"',
        type: SnackType.success,
      );
    } else {
      AppSnackbar.show(
        message: 'Failed to add gift to list. Please try again.',
        type: SnackType.error,
      );
    }
  }

  void _openShareGiftCard(GiftApiItem item) {
    GiftFlow.showShareGiftCard(context, _toGiftItemModel(item));
  }

  void _openAllGiftsScreen() {
    final items = _giftItems.map(_toGiftItemModel).toList();
    context.push(
      RouterPath.familyGiftAllScreen,
      extra: GiftAllScreenConfig(title: 'All Gifts', items: items),
    );
  }

  String _giftKey(GiftApiItem item) => '${item.imageUrl ?? ''}|${item.name}|${item.id}';

  GiftItemModel _toGiftItemModel(GiftApiItem apiItem) {
    return GiftItemModel(
      id: apiItem.id,
      imagePath: apiItem.imageUrl ?? '',
      title: apiItem.name,
      price: apiItem.price.toStringAsFixed(0),
      description: apiItem.categoryName ?? '',
      location: apiItem.location ?? 'N/A',
    );
  }

  SavedGiftItemModel _toSavedGift(GiftApiItem item) {
    return SavedGiftItemModel(
      imagePath: item.imageUrl ?? '',
      title: item.name,
      category: item.categoryName ?? 'Activities',
      price: item.price.toStringAsFixed(0),
    );
  }

  void _toggleBookmark(GiftApiItem item) {
    final key = _giftKey(item);
    final wasBookmarked = _bookmarkedGiftKeys.contains(key);

    setState(() {
      if (wasBookmarked) {
        _bookmarkedGiftKeys.remove(key);
        _savedGiftsWithoutList.removeWhere(
          (saved) => '${saved.imagePath}|${saved.title}' == key,
        );
      } else {
        _bookmarkedGiftKeys.add(key);
        _savedGiftsWithoutList.add(_toSavedGift(item));
      }
    });

    if (!mounted) return;
    AppSnackbar.show(
      message: wasBookmarked ? 'Removed from saved gifts' : 'Saved to My list',
      type: SnackType.info,
    );
  }

  void _openMyGiftListScreen() {
    context.push(RouterPath.familyMyGiftListScreen);
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(giftProviderProvider.notifier).fetchGifts(
        query: query,
        filters: _currentFilters,
        category: _selectedCategory,
      );
    });
  }

  Future<void> _openFilterBottomSheet() async {
    final result = await showModalBottomSheet<GiftFilterResultModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          GiftFilterBottomSheet(initialFilters: _currentFilters),
    );

    if (result != null) {
      setState(() => _currentFilters = result);
      ref.read(giftProviderProvider.notifier).fetchGifts(
        query: _searchController.text,
        filters: result,
        category: _selectedCategory,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final giftState = ref.watch(giftProviderProvider);

    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(giftProviderProvider.notifier).fetchGifts(
            query: _searchController.text,
            filters: _currentFilters,
            category: _selectedCategory,
          ),
          child: giftState.when(
            loading: () => const GiftScreenSkeleton(),
            error: (err, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: $err', textAlign: TextAlign.center),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () => ref.read(giftProviderProvider.notifier).fetchGifts(
                      query: _searchController.text,
                      filters: _currentFilters,
                      category: _selectedCategory,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            data: (giftData) {
              final items = giftData.items;
              final categories = giftData.categories;

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileHeader(header: _getHeader()),
                      SizedBox(height: 24.h),
                      _buildSearchSection(),
                      if (_currentFilters != null && _currentFilters!.hasAnyFilter) ...[
                        SizedBox(height: 12.h),
                        _buildActiveFilterChips(),
                      ],
                      SizedBox(height: 24.h),
                      _buildCategoriesSection(categories),
                      SizedBox(height: 24.h),
                      _buildSearchResultSection(items),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  SpHomeHeader? _getHeader() {
    final homeState = ref.watch(homeProviderProvider);
    return homeState.value?['header'] as SpHomeHeader?;
  }

  Widget _buildProfileHeader({required SpHomeHeader? header}) {
    return Row(
      children: [
        ClipOval(
          child: header?.profileImageUrl != null
              ? CachedNetworkImage(
                  imageUrl: header!.profileImageUrl!,
                  height: 52.w,
                  width: 52.w,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 52.w,
                    width: 52.w,
                    color: Colors.grey.shade300,
                    child: Icon(Icons.person, color: Colors.grey, size: 24.sp),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 52.w,
                    width: 52.w,
                    color: Colors.grey.shade300,
                    child: Icon(Icons.person, color: Colors.grey, size: 24.sp),
                  ),
                )
              : Image.asset(
                  'assets/image/demo_image.jpg',
                  height: 52.w,
                  width: 52.w,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 52.w,
                      width: 52.w,
                      color: Colors.grey.shade300,
                      child: Icon(Icons.person, color: Colors.grey, size: 24.sp),
                    );
                  },
                ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome back ${header?.name.split(' ').first ?? 'User'}",
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Text(
                    header?.location ?? 'Location not set',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.lightText,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  SvgPicture.asset(
                    'assets/logo/edit.svg',
                    height: 14.w,
                    width: 14.w,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primaryLight,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        _buildHeaderActions(),
      ],
    );
  }

  Widget _buildHeaderActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _openMyGiftListScreen,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.secondaryLight,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              'My list',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        GestureDetector(
          onTap: _openCreateNewList,
          child: Container(
            height: 36.w,
            width: 36.w,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.add, color: Colors.white, size: 22.sp),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchSection() {
    final hasFilters = _currentFilters?.hasAnyFilter ?? false;
    final filterCount = [
      _currentFilters?.recipient,
      _currentFilters?.forWhom,
      _currentFilters?.childAge,
      _currentFilters?.price,
    ].where((f) => f != null).length;

    return Row(
      children: [
        Expanded(
          child: SearchBarWidget(
            controller: _searchController,
            hintText: 'Search Planner...',
            onChanged: _onSearchChanged,
          ),
        ),
        SizedBox(width: 12.w),
        Stack(
          clipBehavior: Clip.none,
          children: [
            CustomIconButton(
              assetPath: 'assets/logo/filter.svg',
              containerHeight: 48.h,
              containerWidth: 48.w,
              borderRadius: 8.r,
              iconWidth: 24.w,
              iconHeight: 24.h,
              onTap: _openFilterBottomSheet,
            ),
            if (hasFilters)
              Positioned(
                top: -4.h,
                right: -4.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$filterCount',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildActiveFilterChips() {
    final filters = <String>[
      if (_currentFilters?.recipient != null) _currentFilters!.recipient!,
      if (_currentFilters?.forWhom != null) _currentFilters!.forWhom!,
      if (_currentFilters?.childAge != null) _currentFilters!.childAge!,
      if (_currentFilters?.price != null) _currentFilters!.price!,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...filters.map((filter) => Container(
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
                  filter,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryLight,
                  ),
                ),
                SizedBox(width: 4.w),
                GestureDetector(
                  onTap: () => _removeFilter(filter),
                  child: Icon(
                    Icons.close,
                    size: 14.sp,
                    color: AppColors.primaryLight,
                  ),
                ),
              ],
            ),
          )),
          GestureDetector(
            onTap: _clearFilters,
            child: Container(
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

  void _clearFilters() {
    setState(() => _currentFilters = null);
    ref.read(giftProviderProvider.notifier).fetchGifts(
      query: _searchController.text,
      category: _selectedCategory,
    );
  }

  void _removeFilter(String filterValue) {
    if (_currentFilters == null) return;

    final updated = GiftFilterResultModel(
      recipient: _currentFilters!.recipient == filterValue ? null : _currentFilters!.recipient,
      forWhom: _currentFilters!.forWhom == filterValue ? null : _currentFilters!.forWhom,
      childAge: _currentFilters!.childAge == filterValue ? null : _currentFilters!.childAge,
      price: _currentFilters!.price == filterValue ? null : _currentFilters!.price,
    );

    setState(() => _currentFilters = updated.hasAnyFilter ? updated : null);
    ref.read(giftProviderProvider.notifier).fetchGifts(
      query: _searchController.text,
      filters: updated.hasAnyFilter ? updated : null,
      category: _selectedCategory,
    );
  }

  List<GiftApiItem> get _giftItems {
    final giftState = ref.read(giftProviderProvider);
    return giftState.value?.items ?? [];
  }

  Widget _buildCategoriesSection(List<GiftApiCategory> apiCategories) {
    final displayCategories = ['All', ...apiCategories.map((c) => c.name)];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
        SizedBox(height: 12.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: displayCategories.map((category) {
              final isSelected = _selectedCategory == category;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedCategory = category);
                  ref.read(giftProviderProvider.notifier).fetchGifts(
                    query: _searchController.text,
                    filters: _currentFilters,
                    category: category,
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(right: 10.w),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryLight
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryLight
                          : const Color(0xFFE5E5E5),
                    ),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.primaryLight,
                      fontSize: 14.sp,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResultSection(List<GiftApiItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Search Result',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            if (items.isNotEmpty)
              GestureDetector(
                onTap: _openAllGiftsScreen,
                child: Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryLight,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 12.h),
        if (items.isEmpty)
          Container(
            padding: EdgeInsets.symmetric(vertical: 40.h),
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              _selectedCategory == 'All'
                  ? 'No gifts found'
                  : 'No gifts in "$_selectedCategory"',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.lightText,
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        else
          ...List.generate(items.length, (index) {
            final item = items[index];
            return GiftCard(
              imagePath: item.imageUrl ?? '',
              title: item.name,
              price: item.price.toStringAsFixed(0),
              description: item.categoryName ?? '',
              location: item.location ?? 'N/A',
              isBookmarked: _bookmarkedGiftKeys.contains(_giftKey(item)),
              onTap: () => context.push(
                RouterPath.familyGiftDetailsScreen,
                extra: item.id,
              ),
              onAddToGiftList: () => _openAddToGiftList(item),
              onShareTap: () => _openShareGiftCard(item),
              onBookmarkTap: () => _toggleBookmark(item),
            );
          }),
      ],
    );
  }
}
