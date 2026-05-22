import 'package:familyside/view/widgets/custom_icon_button.dart';
import 'package:familyside/view/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchToolbar extends StatelessWidget {
  const SearchToolbar({
    super.key,
    required this.controller,
    this.hintText = 'Search activity & events....',
    this.onFilterTap,
    this.onLocationTap,
  });

  final TextEditingController controller;
  final String hintText;
  final VoidCallback? onFilterTap;
  final VoidCallback? onLocationTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SearchBarWidget(
            controller: controller,
            hintText: hintText,
          ),
        ),
        SizedBox(width: 12.w),
        CustomIconButton(
          assetPath: 'assets/logo/filter.svg',
          containerHeight: 48.h,
          containerWidth: 48.w,
          borderRadius: 8.r,
          iconWidth: 24.w,
          iconHeight: 24.h,
          onTap: onFilterTap,
        ),
        SizedBox(width: 12.w),
        CustomIconButton(
          assetPath: 'assets/logo/location.svg',
          containerHeight: 48.h,
          containerWidth: 48.w,
          borderRadius: 8.r,
          iconWidth: 24.w,
          iconHeight: 24.h,
          onTap: onLocationTap,
        ),
      ],
    );
  }
}
