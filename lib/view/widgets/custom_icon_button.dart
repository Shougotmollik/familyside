import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.assetPath,
    this.containerHeight,
    this.containerWidth,
    this.iconHeight,
    this.iconWidth,
    this.backgroundColor,
    this.iconColor,
    this.borderRadius,
    this.fit,
    this.onTap,
    this.padding,
  });

  final String assetPath;

  // Container Size
  final double? containerHeight;
  final double? containerWidth;

  // Icon Size
  final double? iconHeight;
  final double? iconWidth;

  // Style
  final Color? backgroundColor;
  final Color? iconColor;
  final double? borderRadius;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;

  // Action
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: containerHeight ?? 40.w,
        width: containerWidth ?? 40.w,
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor ?? const Color(0xffF2F2F2),
          borderRadius: BorderRadius.circular(borderRadius ?? 50.r),
        ),
        child: Center(
          child: SvgPicture.asset(
            assetPath,
            height: iconHeight ?? 20.w,
            width: iconWidth ?? 20.w,
            fit: fit ?? BoxFit.contain,
            colorFilter: ColorFilter.mode(
              iconColor ?? Colors.black,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
