import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key, required this.title, this.trailing});
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12.w,
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
          child: Icon(Icons.arrow_back_ios_new, size: 24.sp),
        ),
        Expanded(
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        ?trailing
      ],
    );
  }
}
