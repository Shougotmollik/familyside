import 'dart:async';
import 'package:familyside/core/router/router_path.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/model/gift_api_item.dart';
import 'package:familyside/provider/family/search_provider.dart';
import 'package:familyside/model/search_data.dart';
import 'package:familyside/view/family/search/widgets/browse_category_section.dart';
import 'package:familyside/view/family/search/widgets/quick_access_row.dart';
import 'package:familyside/view/family/search/widgets/search_promo_banner.dart';
import 'package:familyside/view/family/search/widgets/search_toolbar.dart';
import 'package:familyside/view/widgets/event_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  String _searchQuery = '';

  String _modeForLabel(String label) {
    switch (label) {
      case 'For you':
        return 'for_you';
      case 'Near you':
        return 'near_you';
      case 'Gifts':
        return 'gifts';
      case 'Events':
        return 'events';
      default:
        return '';
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchProviderProvider.notifier).fetchSearchData();
    });
    _searchController.addListener(_onSearchControllerChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchControllerChanged);
    _searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onSearchControllerChanged() {
    if (_searchController.text.isEmpty && _searchQuery.isNotEmpty) {
      setState(() => _searchQuery = '');
    }
  }

  void _openMapScreen() {
    context.push(
      RouterPath.familySearchResultsScreen,
      extra: const SearchResultsConfig(mode: 'near_you'),
    );
  }

  void _onQuickAccessTap(QuickAccessItem item) {
    final mode = _modeForLabel(item.label);
    context.push(
      RouterPath.familySearchResultsScreen,
      extra: SearchResultsConfig(mode: mode),
    );
  }

  void _onCategoryTap(BrowseCategoryItem item) {
    context.push(
      RouterPath.familySearchResultsScreen,
      extra: SearchResultsConfig(categoryId: item.id, title: item.title),
    );
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      _searchDebounce?.cancel();
      setState(() => _searchQuery = '');
      return;
    }
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _searchQuery = query);
      }
    });
  }

  Future<void> _onRefresh() async {
    await ref.read(searchProviderProvider.notifier).fetchSearchData();
    if (_searchQuery.isNotEmpty) {
      ref.invalidate(searchResultsProvider(query: _searchQuery));
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProviderProvider);
    final searchResultsAsync = _searchQuery.isNotEmpty
        ? ref.watch(searchResultsProvider(query: _searchQuery))
        : null;

    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SearchToolbar(
                  controller: _searchController,
                  hintText: SearchData.searchHint,
                  onLocationTap: _openMapScreen,
                  onSearchChanged: _onSearchChanged,
                ),
                SizedBox(height: 20.h),
                if (_searchQuery.isNotEmpty)
                  _buildSearchResults(searchResultsAsync)
                else ...[
                  QuickAccessRow(
                    items: SearchData.quickAccessItems,
                    onItemTap: _onQuickAccessTap,
                  ),
                  SizedBox(height: 16.h),
                  searchState.when(
                    data: (data) {
                      final greeting =
                          data['personalized_greeting'] as String? ?? '';
                      if (greeting.isEmpty) return const SizedBox.shrink();
                      return SearchPromoBanner(message: greeting);
                    },
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                  SizedBox(height: 24.h),
                  searchState.when(
                    data: (data) {
                      final categories =
                          data['categories'] as List<BrowseCategoryItem>? ??
                              [];
                      if (categories.isEmpty) return const SizedBox.shrink();
                      return BrowseCategorySection(
                        categories: categories,
                        onCategoryTap: _onCategoryTap,
                      );
                    },
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    error: (error, _) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 32.h),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.cloud_off_outlined,
                              size: 48.sp,
                              color: AppColors.mutedIcon,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              error.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.mutedIcon,
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            ElevatedButton.icon(
                              onPressed: () =>
                                  ref.read(searchProviderProvider.notifier)
                                      .fetchSearchData(),
                              icon: const Icon(Icons.refresh, size: 18),
                              label: const Text('Retry'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryLight,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults(AsyncValue<List<GiftApiItem>>? asyncValue) {
    if (asyncValue == null) return const SizedBox.shrink();

    return asyncValue.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (error, _) => Padding(
        padding: EdgeInsets.symmetric(vertical: 32.h),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cloud_off_outlined,
                size: 48.sp,
                color: AppColors.mutedIcon,
              ),
              SizedBox(height: 8.h),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.mutedIcon,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
      ),
      data: (items) {
        if (items.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 40.h),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 48.sp,
                    color: AppColors.mutedIcon,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'No results found for "$_searchQuery"',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.mutedIcon,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Text(
                '${items.length} result(s) found',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.lightText,
                ),
              ),
            ),
            ...items.map((item) {
              final date = item.dateLabel != null &&
                      item.dateLabel!.contains(',')
                  ? item.dateLabel!.split(',').first.trim()
                  : (item.dateLabel ?? '');
              return EventCard(
                imagePath: item.imageUrl ?? '',
                category: item.categoryName ?? '',
                date: date,
                title: item.name,
                price: item.price.toStringAsFixed(0),
                distance: item.distanceKm != null
                    ? '${item.distanceKm!.toStringAsFixed(2)} km'
                    : 'N/A',
                ageRange: item.ageRange ?? 'All ages',
                tag: item.itemType,
                onTap: () {
                  final route = item.itemType == 'event'
                      ? RouterPath.familyEventDetailsScreen
                      : RouterPath.familyActivityDetailsScreen;
                  context.push(route, extra: item.id);
                },
              );
            }),
          ],
        );
      },
    );
  }
}
