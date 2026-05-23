import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_svg/svg.dart';

class SpPhotoUploadBox extends StatelessWidget {
  const SpPhotoUploadBox({super.key, this.onTap, this.previewFile});

  final VoidCallback? onTap;
  final File? previewFile;

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
          clipBehavior: Clip.antiAlias,
          child: previewFile != null
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(
                      previewFile!,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.4),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8.h,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                              size: 14.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Tap to change',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontSize: 11.sp,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/icon/image_uploader.svg"),
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
