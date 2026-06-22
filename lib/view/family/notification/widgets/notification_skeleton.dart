import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class NotificationSkeleton extends StatelessWidget {
  const NotificationSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitleSkeleton(),
            SizedBox(height: 12.h),
            ...List.generate(2, (_) => _buildNotificationCardSkeleton()),
            _buildSectionTitleSkeleton(),
            SizedBox(height: 12.h),
            ...List.generate(2, (_) => _buildNotificationCardSkeleton()),
            _buildSectionTitleSkeleton(),
            SizedBox(height: 12.h),
            ...List.generate(2, (_) => _buildNotificationCardSkeleton()),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitleSkeleton() {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, bottom: 4.h),
      child: Container(
        width: 120.w,
        height: 20.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.r),
        ),
      ),
    );
  }

  Widget _buildNotificationCardSkeleton() {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48.w,
            width: 48.w,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        height: 16.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      width: 60.w,
                      height: 14.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Container(
                  width: double.infinity,
                  height: 14.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
