import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/view/widgets/custom_app_bar.dart';
import 'package:familyside/view/widgets/item_card.dart';
import 'package:familyside/view/family/home/family_home_screen.dart';

class ListScreenConfig {
  final String title;
  final List<RecommendedItemModel> items;

  const ListScreenConfig({required this.title, required this.items});
}

class RecommendationScreen extends StatelessWidget {
  final ListScreenConfig config;

  const RecommendationScreen({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: CustomAppBar(title: config.title),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                itemCount: config.items.length,
                itemBuilder: (context, index) {
                  final item = config.items[index];
                  return EventCard(
                    imagePath: item.imagePath,
                    category: item.category,
                    date: item.date,
                    title: item.title,
                    price: item.price,
                    distance: item.distance,
                    ageRange: item.ageRange,
                    tag: item.tag,
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
