import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileSvgIcon extends StatelessWidget {
  final String iconPath;
  final double? width;
  final double? height;
  final Color? color;

  const ProfileSvgIcon({
    super.key,
    required this.iconPath,
    this.width,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final w = width ?? 24.w;
    final h = height ?? 24.h;

    if (iconPath.isEmpty) {
      return SizedBox(width: w, height: h);
    }

    return SvgPicture.asset(
      iconPath,
      width: w,
      height: h,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}
