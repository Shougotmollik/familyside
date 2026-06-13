import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class SpEventCard extends StatelessWidget {
  const SpEventCard({
    super.key,
    required this.imagePath,
    required this.category,
    required this.title,
    required this.price,
    required this.distance,
    required this.ageRange,
    required this.date,
    required this.tag,
    this.onTap,
  });

  final String imagePath;
  final String category;
  final String title;
  final String price;
  final String distance;
  final String ageRange;
  final String date;
  final String tag;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 14.h),
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: const Color(0xFFF2F2F2), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with category badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: CachedNetworkImage(
                    imageUrl: imagePath,
                    width: 120.w,
                    height: 110.h,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        width: 120.w,
                        height: 110.h,
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 120.w,
                      height: 110.h,
                      color: Colors.grey.shade200,
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.grey,
                        size: 28.sp,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 7.h,
                  left: 7.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 7.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: AppColors.primaryLight,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 12.w),
            // Info section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + price
                  Row(
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
                            color: AppColors.text,
                          ),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '\$$price',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondaryLight,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  // Distance + age
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: AppColors.grey,
                        size: 13.sp,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        distance,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.grey,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Icon(
                        Icons.sentiment_satisfied_alt_outlined,
                        color: AppColors.grey,
                        size: 13.sp,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          ageRange,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  // Date + tag
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.lightText,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDDEEE0),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            color: const Color(0xFF5A7A62),
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
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
