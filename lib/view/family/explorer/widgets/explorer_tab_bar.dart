import 'package:familyside/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExplorerTabBar extends StatelessWidget {
  const ExplorerTabBar({
    super.key,
    required this.controller,
    this.onTap,
  });

  final TabController controller;
  final ValueChanged<int>? onTap;

  static const List<String> tabs = ['Activity', 'Events', 'Gifts'];

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      onTap: onTap,
      isScrollable: false,
      tabAlignment: TabAlignment.fill,
      dividerColor: Colors.transparent,
      indicatorColor: AppColors.primaryLight,
      indicatorWeight: 2.h,
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: AppColors.primaryLight,
      unselectedLabelColor: AppColors.grey,
      labelStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
      ),
      tabs: tabs.map((label) => Tab(text: label)).toList(),
    );
  }
}
