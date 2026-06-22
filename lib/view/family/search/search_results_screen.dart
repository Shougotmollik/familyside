import 'package:familyside/core/router/router_path.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/provider/family/search_provider.dart';
import 'package:familyside/view/widgets/custom_app_bar.dart';
import 'package:familyside/view/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SearchResultsScreen extends ConsumerWidget {
  final String? mode;
  final int? categoryId;
  final String? title;

  const SearchResultsScreen({super.key, this.mode, this.categoryId, this.title});

  SearchResultsScreen.fromConfig(SearchResultsConfig config, {super.key})
      : mode = config.mode,
        categoryId = config.categoryId,
        title = config.title;

  String get _displayTitle {
    if (title != null) return title!;
    if (mode != null) {
      switch (mode) {
        case 'for_you':
          return 'For You';
        case 'near_you':
          return 'Near You';
        case 'gifts':
          return 'Gifts';
        case 'events':
          return 'Events';
      }
    }
    if (categoryId != null) return 'Category';
    return 'Search Results';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = ref.watch(
      searchResultsProvider(mode: mode, categoryId: categoryId),
    );

    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: CustomAppBar(title: _displayTitle),
            ),
            Expanded(
              child: resultsAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, _) => Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.cloud_off_outlined,
                          size: 48.sp,
                          color: AppColors.mutedIcon,
                        ),
                        SizedBox(height: 12.h),
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
                          onPressed: () => ref.invalidate(
                            searchResultsProvider(
                              mode: mode,
                              categoryId: categoryId,
                            ),
                          ),
                          icon: const Icon(Icons.refresh, size: 18),
                          label: const Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryLight,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                data: (items) {
                  if (items.isEmpty) {
                    return Center(
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
                            'No results found',
                            style: TextStyle(
                              color: AppColors.mutedIcon,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
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
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
