import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/view/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ExplorerViewMode { list, map }

class ExplorerHeader extends StatelessWidget {
  const ExplorerHeader({
    super.key,
    this.onViewModeChanged,
    this.onFilterTap,
    this.viewMode = ExplorerViewMode.list,
    this.filterCount = 0,
    this.hasFilters = false,
  });

  final ValueChanged<ExplorerViewMode>? onViewModeChanged;
  final VoidCallback? onFilterTap;
  final ExplorerViewMode viewMode;
  final int filterCount;
  final bool hasFilters;

  bool get _isListView => viewMode == ExplorerViewMode.list;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Explore',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
        ),
        // View mode toggle: List | Map
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              // List button
              GestureDetector(
                onTap: _isListView
                    ? null
                    : () => onViewModeChanged?.call(ExplorerViewMode.list),
                child: Container(
                  height: 40.w,
                  width: 40.w,
                  decoration: BoxDecoration(
                    color: _isListView
                        ? AppColors.primaryLight
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.format_list_bulleted,
                    color: _isListView ? Colors.white : AppColors.lightText,
                    size: 22.sp,
                  ),
                ),
              ),
              // Map button
              GestureDetector(
                onTap: _isListView
                    ? () => onViewModeChanged?.call(ExplorerViewMode.map)
                    : null,
                child: Container(
                  height: 40.w,
                  width: 40.w,
                  decoration: BoxDecoration(
                    color: !_isListView
                        ? AppColors.primaryLight
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.location_on_outlined,
                    color: !_isListView ? Colors.white : AppColors.lightText,
                    size: 22.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 8.w),
        Stack(
          clipBehavior: Clip.none,
          children: [
            CustomIconButton(
              assetPath: 'assets/logo/filter.svg',
              containerHeight: 40.w,
              containerWidth: 40.w,
              borderRadius: 8.r,
              backgroundColor: hasFilters ? AppColors.primaryLight : AppColors.surface,
              iconColor: hasFilters ? Colors.white : Colors.black,
              iconWidth: 20.w,
              iconHeight: 20.h,
              onTap: onFilterTap,
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
}
