import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:familyside/core/theme/app_colors.dart';

class SpFormLabel extends StatelessWidget {
  const SpFormLabel(this.text, {super.key, this.isRequired = false});

  final String text;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: RichText(
        text: TextSpan(
          text: text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.w400,
          ),
          children: isRequired
              ? [
                  TextSpan(
                    text: '*',
                    style: TextStyle(
                      color: AppColors.primaryLight,
                      fontSize: 14.sp,
                    ),
                  ),
                ]
              : [],
        ),
      ),
    );
  }
}
