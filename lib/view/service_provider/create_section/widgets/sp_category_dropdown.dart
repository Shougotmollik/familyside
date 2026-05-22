import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:familyside/core/theme/app_colors.dart';

class SpCategoryDropdown extends StatelessWidget {
  const SpCategoryDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.items = const [
      'Sports',
      'Arts & Crafts',
      'Music',
      'Education',
      'Outdoor',
      'Health & Wellness',
      'Technology',
      'Food & Cooking',
    ],
  });

  final String? value;
  final ValueChanged<String?> onChanged;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.lightText,
        size: 20.sp,
      ),
      style: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(fontSize: 14.sp, color: AppColors.text),
      decoration: InputDecoration(
        hintText: 'Select category',
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 14.sp,
          color: AppColors.lightText,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: AppColors.lightText.withValues(alpha: 0.3),
            width: 1.w,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: AppColors.lightText.withValues(alpha: 0.3),
            width: 1.w,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: AppColors.text.withValues(alpha: 0.7),
            width: 1.2.w,
          ),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
    );
  }
}
