import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/view/family/explorer/models/explorer_map_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExplorerMapPreviewCard extends StatelessWidget {
  const ExplorerMapPreviewCard({
    super.key,
    required this.item,
    this.onTap,
  });

  final ExplorerMapItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: const Color(0xFFF2F2F2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Image.asset(
                    item.imagePath,
                    width: 96.w,
                    height: 88.h,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 96.w,
                        height: 88.h,
                        color: Colors.grey.shade200,
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                          size: 24.sp,
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 6.h,
                  left: 6.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      item.category,
                      style: TextStyle(
                        color: AppColors.primaryLight,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E8E1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      item.tag,
                      style: TextStyle(
                        color: AppColors.secondaryLight,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14.sp,
                        color: AppColors.primaryLight,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          item.distance,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Text(
                        'Fee: \$${item.price}',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.grey,
                        ),
                      ),
                      if (item.ageRange.isNotEmpty) ...[
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            item.ageRange,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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
