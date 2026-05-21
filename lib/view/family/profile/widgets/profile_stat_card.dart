import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/view/family/profile/widgets/profile_svg_icon.dart';

class ProfileStatCard extends StatelessWidget {
  final String iconPath;
  final String label;
  final String value;
  final Color? iconColor;
  final Color? valueColor;

  const ProfileStatCard({
    super.key,
    required this.iconPath,
    required this.label,
    required this.value,
    this.iconColor,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 94.w,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ProfileSvgIcon(
            iconPath: iconPath,
            color: iconColor,
          ),
          SizedBox(height: 12.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.text,
                  height: 2.h
                ),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: valueColor ?? AppColors.primaryLight,
                ),
          ),
        ],
      ),
    );
  }
}
