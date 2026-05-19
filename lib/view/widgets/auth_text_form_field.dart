import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:familyside/core/theme/app_colors.dart';

class AuthTextFormField extends StatefulWidget {
  const AuthTextFormField({
    super.key,
    required this.hintText,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.isPassword = false,
    this.prefixIcon,
    this.prefixIconPath,
    this.onFieldSubmitted,
  });

  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool isPassword;
  final Widget? prefixIcon;
  final String? prefixIconPath;
  final void Function(String)? onFieldSubmitted;

  @override
  State<AuthTextFormField> createState() => _AuthTextFormFieldState();
}

class _AuthTextFormFieldState extends State<AuthTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        obscureText: _obscureText,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        autocorrect: !widget.isPassword,
        enableSuggestions: !widget.isPassword,
        onFieldSubmitted: widget.onFieldSubmitted,
        style: textTheme.bodyMedium?.copyWith(
          fontSize: 14.sp,
          color: AppColors.text,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: textTheme.bodyMedium?.copyWith(
            fontSize: 14.sp,
            color: AppColors.lightText,
          ),

          filled: true,
          fillColor: AppColors.surface,

          contentPadding: EdgeInsets.symmetric(
            vertical: 14.h,
            horizontal: 12.w,
          ),

          // Prefix Icon (supports both SvgPicture path and standard Widget Icon)
          prefixIcon: widget.prefixIcon ?? (widget.prefixIconPath != null
              ? Padding(
                  padding: EdgeInsets.all(12.w),
                  child: SvgPicture.asset(
                    widget.prefixIconPath!,
                    colorFilter: const ColorFilter.mode(
                      AppColors.lightText,
                      BlendMode.srcIn,
                    ),
                  ),
                )
              : null),

          // Password Toggle
          suffixIcon: widget.isPassword
              ? IconButton(
                  splashRadius: 20,
                  icon: Icon(
                    _obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.lightText,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,

          // Borders
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: AppColors.lightText.withOpacity(0.3), width: 1.w),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: AppColors.lightText.withOpacity(0.3), width: 1.w),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: AppColors.text.withOpacity(0.7), width: 1.2.w),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: AppColors.error, width: 1.2.w),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: AppColors.error, width: 1.2.w),
          ),

          // Error text outside border
          errorStyle: TextStyle(fontSize: 11.sp, color: AppColors.error),
        ),
      ),
    );
  }
}
