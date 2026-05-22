import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:flutter_svg/svg.dart';

class ActivityCard extends StatelessWidget {
  final String imagePath;
  final String category;
  final String date;
  final String title;
  final String price;
  final String distance;
  final String ageRange;
  final String tag;
  final VoidCallback? onTap;

  const ActivityCard({
    super.key,
    required this.imagePath,
    required this.category,
    required this.date,
    required this.title,
    required this.price,
    required this.distance,
    required this.ageRange,
    required this.tag,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFF2F2F2), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.asset(
                    imagePath,
                    width: 140.w,
                    height: 120.h,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 120.w,
                        height: 100.h,
                        color: Colors.grey.shade200,
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                          size: 30.sp,
                        ),
                      );
                    },
                  ),
                ),
                // Category Badge
                Positioned(
                  top: 8.h,
                  left: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                // Date Badge
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icon/activity_icon.svg',
                        width: 12.w,
                        height: 12.h,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 12.w),
            // Right Info Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1D1B20),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "\$$price",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondaryLight,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  // Location and Distance Row
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: const Color(0xFF939094),
                        size: 14.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        distance,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF939094),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Icon(
                        Icons.sentiment_satisfied_alt_outlined,
                        color: const Color(0xFF939094),
                        size: 14.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        ageRange,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF939094),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  // Recommendation Tag
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E8E1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        color: const Color(0xFF6C7278),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
