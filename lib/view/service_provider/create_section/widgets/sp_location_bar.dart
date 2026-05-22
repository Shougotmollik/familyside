import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/env.dart';
import 'package:familyside/view/widgets/google_map.dart';

class SpLocationBar extends StatelessWidget {
  const SpLocationBar({
    super.key,
    required this.controller,
    this.onLocationSelected,
  });

  final TextEditingController controller;
  final void Function(GoogleMapLocation location)? onLocationSelected;

  void _openMap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GoogleMapScreen(
          apiKey: EnvHandler.googleMapApiKey,
          onLocationSelect: (location) {
            controller.text = location.name;
            onLocationSelected?.call(location);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
                color: AppColors.text,
              ),
              decoration: InputDecoration(
                hintText: 'Enter your location',
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.lightText,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.lightText,
                  size: 20.sp,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14.h),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _openMap(context),
            child: Container(
              margin: EdgeInsets.all(6.w),
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(Icons.location_on, color: Colors.white, size: 20.sp),
            ),
          ),
        ],
      ),
    );
  }
}
