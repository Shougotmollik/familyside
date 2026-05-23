import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:familyside/core/theme/app_colors.dart';

class SpManageCard extends StatelessWidget {
  const SpManageCard({
    super.key,
    required this.imagePath,
    required this.category,
    required this.title,
    required this.price,
    required this.distance,
    required this.ageRange,
    this.description,
    this.location,
    this.isGift = false,
    this.onEdit,
    this.onDelete,
  });

  final String imagePath;
  final String category;
  final String title;
  final String price;
  final String distance;
  final String ageRange;
  final String? description;
  final String? location;
  final bool isGift;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Image with badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Image.asset(
                  imagePath,
                  width: 120.w,
                  height: isGift ? 120.h : 110.h,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 120.w,
                    height: isGift ? 120.h : 110.h,
                    color: Colors.grey.shade200,
                    child: Icon(
                      Icons.image_outlined,
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
                    horizontal: isGift ? 6.w : 7.w,
                    vertical: 3.h,
                  ),
                  decoration: BoxDecoration(
                    color: isGift ? AppColors.primaryLight : Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: isGift
                      ? Icon(Icons.bookmark, color: Colors.white, size: 14.sp)
                      : Text(
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
          // Info + actions
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
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      '\$$price',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondaryLight,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                // Description (gift) or distance+age (activity/event)
                if (isGift && description != null) ...[
                  Text(
                    description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.lightText,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: AppColors.grey,
                        size: 12.sp,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          location ?? '',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: AppColors.grey,
                        size: 12.sp,
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
                        size: 12.sp,
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
                ],
                SizedBox(height: 10.h),
                // Edit + Delete row
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: onEdit,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, color: Colors.white, size: 14.sp),
                              SizedBox(width: 4.w),
                              Text(
                                'Edit',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: onDelete,
                      child: Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: SvgPicture.asset(
                          'assets/icon/delete.svg',
                          width: 18.w,
                          height: 18.w,
                          colorFilter: const ColorFilter.mode(
                            AppColors.primaryLight,
                            BlendMode.srcIn,
                          ),
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
    );
  }
}
