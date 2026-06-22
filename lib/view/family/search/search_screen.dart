import 'package:familyside/core/router/router_path.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/provider/family/search_provider.dart';
import 'package:familyside/model/search_data.dart';
import 'package:familyside/view/family/search/widgets/browse_category_section.dart';
import 'package:familyside/view/family/search/widgets/quick_access_row.dart';
import 'package:familyside/view/family/search/widgets/search_promo_banner.dart';
import 'package:familyside/view/family/search/widgets/search_toolbar.dart';
import 'package:familyside/model/filter_result_model.dart';
import 'package:familyside/view/widgets/home_filter_bottom_sheet.dart';
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
  FilterResultModel? _currentFilters;

  // Mode mapping from quick access label to API query param
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
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProviderProvider);

    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SearchToolbar(
                controller: _searchController,
                hintText: SearchData.searchHint,
                onFilterTap: _openFilterBottomSheet,
                onLocationTap: _openMapScreen,
              ),
              SizedBox(height: 20.h),
              QuickAccessRow(
                items: SearchData.quickAccessItems,
                onItemTap: _onQuickAccessTap,
              ),
              SizedBox(height: 16.h),
              // Personalized greeting from API
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
              // Browse Categories from API
              searchState.when(
                data: (data) {
                  final categories =
                      data['categories'] as List<BrowseCategoryItem>? ?? [];
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
          ),
        ),
      ),
    );
  }
}
