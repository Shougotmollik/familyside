import 'package:familyside/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:familyside/core/theme/app_colors.dart';

class SpFormButtons extends StatelessWidget {
  const SpFormButtons({
    super.key,
    required this.onCancel,
    required this.onSubmit,
    this.submitLabel = 'Submit activity',
    this.isLoading = false,
  });

  final VoidCallback onCancel;
  final VoidCallback onSubmit;
  final String submitLabel;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Column(
      children: [
        // Cancel — ghost button
        GestureDetector(
          onTap: isLoading ? null : onCancel,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 15.h),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Text(
                loc.translate('cancel'),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primaryLight,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        // Submit — filled button
        GestureDetector(
          onTap: isLoading ? null : onSubmit,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 15.h),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      height: 20.h,
                      width: 20.h,
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      submitLabel,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
