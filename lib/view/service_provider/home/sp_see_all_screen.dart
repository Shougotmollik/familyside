import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/model/provider_feed_item.dart';
import 'package:familyside/view/service_provider/home/widgets/sp_event_card.dart';

class SpSeeAllScreen extends StatelessWidget {
  final String title;
  final List<ProviderFeedItem> items;

  const SpSeeAllScreen({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
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
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final e = items[index];
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
    );
  }
}
