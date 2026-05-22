import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:dotted_border/dotted_border.dart';

class SpPhotoUploadBox extends StatelessWidget {
  const SpPhotoUploadBox({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          dashPattern: const [6, 4],
          strokeWidth: 1.2,
          radius: Radius.circular(10.r),
          color: AppColors.lightText.withValues(alpha: 0.4),
          padding: EdgeInsets.zero,
        ),
        child: Container(
          width: double.infinity,
          height: 130.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_outlined,
                size: 36.sp,
                color: AppColors.lightText,
              ),
              SizedBox(height: 8.h),
              Text(
                'Click to upload photos',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.text,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'PNG, JPG, up to 10MB',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.lightText,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
