import 'package:familyside/provider/service_provider/sp_home_provider.dart';
import 'package:familyside/model/provider_feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/model/provider_feed_item.dart';
import 'package:familyside/view/service_provider/home/widgets/sp_event_card.dart';

class SpSeeAllScreen extends ConsumerWidget {
  final String title;
  final List<ProviderFeedItem> items;

  const SpSeeAllScreen({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(spHomeProviderProvider);
    
    // Get the latest items from provider if available, otherwise fallback to initial items
    final currentItems = state.maybeWhen(
      data: (data) {
        final feed = data['feed'] as ProviderFeed;
        if (title == 'Upcoming events') return feed.upcomingEvents;
        if (title == 'Top service') return feed.topServices;
        return items;
      },
      orElse: () => items,
    );

    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
        backgroundColor: AppColors.surfaceLight,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.text),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(spHomeProviderProvider.notifier).fetchSpHomeFeed(),
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          itemCount: currentItems.length,
          itemBuilder: (context, index) {
            final e = currentItems[index];
            return SpEventCard(
              imagePath: e.imageUrl ?? '',
              category: e.categoryLabel,
              title: e.name,
              price: e.price.toStringAsFixed(0),
              distance: '${e.distanceKm} km',
              ageRange: e.ageRange,
              date: e.dateLabel,
              tag: e.itemType,
            );
          },
        ),
      ),
    );
  }
}
