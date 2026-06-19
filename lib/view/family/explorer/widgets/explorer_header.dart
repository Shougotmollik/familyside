import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/view/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExplorerHeader extends StatelessWidget {
  const ExplorerHeader({
    super.key,
    this.onListTap,
    this.onLocationTap,
    this.onFilterTap,
    this.locationActive = false,
    this.filterCount = 0,
    this.hasFilters = false,
  });

  final VoidCallback? onListTap;
  final VoidCallback? onLocationTap;
  final VoidCallback? onFilterTap;
  final bool locationActive;
  final int filterCount;
  final bool hasFilters;

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
        GestureDetector(
          onTap: onListTap,
          child: Container(
            height: 40.w,
            width: 40.w,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.format_list_bulleted,
              color: Colors.white,
              size: 22.sp,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        CustomIconButton(
          assetPath: 'assets/logo/location.svg',
          containerHeight: 40.w,
          containerWidth: 40.w,
          borderRadius: 8.r,
          backgroundColor:
              locationActive ? AppColors.primaryLight : AppColors.surface,
          iconColor: locationActive ? Colors.white : Colors.black,
          iconWidth: 20.w,
          iconHeight: 20.h,
          onTap: onLocationTap,
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
