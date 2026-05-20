import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:familyside/core/theme/app_colors.dart';

class TypeToggleWidget extends StatelessWidget {
  const TypeToggleWidget({
    super.key,
    required this.isExpecting,
    required this.onChanged,
  });

  final bool isExpecting;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(true),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              decoration: BoxDecoration(
                color: isExpecting ? AppColors.primaryLight : Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isExpecting ? AppColors.primaryLight : AppColors.lightText.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.child_care_outlined, // Fallback icon
                    color: isExpecting ? Colors.white : AppColors.text,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Expecting',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isExpecting ? Colors.white : AppColors.text,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(false),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              decoration: BoxDecoration(
                color: !isExpecting ? AppColors.primaryLight : Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: !isExpecting ? AppColors.primaryLight : AppColors.lightText.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline, // Fallback icon
                    color: !isExpecting ? Colors.white : AppColors.text,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Kids',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: !isExpecting ? Colors.white : AppColors.text,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
