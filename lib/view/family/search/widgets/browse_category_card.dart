import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/model/search_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BrowseCategoryCard extends StatelessWidget {
  const BrowseCategoryCard({
    super.key,
    required this.item,
    this.onTap,
  });

  final BrowseCategoryItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: item.backgroundColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Container(
              height: 40.w,
              width: 40.w,
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: item.imageUrl.endsWith('.svg')
                    ? SvgPicture.network(
                        item.imageUrl,
                        width: 22.sp,
                        height: 22.sp,
                        fit: BoxFit.contain,
                      )
                    : Image.network(
                        item.imageUrl,
                        width: 22.sp,
                        height: 22.sp,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.category_outlined,
                          color: item.iconColor,
                          size: 22.sp,
                        ),
                      ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                item.title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
