import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/core/router/router_path.dart';
import 'package:familyside/view/widgets/custom_elevated_button.dart';

class FamilySignupOtpVerificationScreen extends StatefulWidget {
  const FamilySignupOtpVerificationScreen({super.key});

  @override
  State<FamilySignupOtpVerificationScreen> createState() =>
      _FamilySignupOtpVerificationScreenState();
}

class _FamilySignupOtpVerificationScreenState
    extends State<FamilySignupOtpVerificationScreen> {
  final _pinController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onVerify() {
    context.push(RouterPath.familyChooseRoleScreen);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 56.h,
      textStyle: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightText.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12.r),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.primary, width: 1.5),
        borderRadius: BorderRadius.circular(12.r),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(12.r),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.text,
            size: 20.sp,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40.h),
              _buildLogoSection(theme),
              SizedBox(height: 32.h),
              Text(
                "OTP Verification",
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 32.sp,
                  color: AppColors.text,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "Enter the 6-digit code sent to your email",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.lightText,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 48.h),
              Pinput(
                controller: _pinController,
                focusNode: _focusNode,
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                errorPinTheme: errorPinTheme,
                autofocus: true,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onCompleted: (value) {
                  _onVerify();
                },
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive the code? ",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.lightText,
                      fontSize: 14.sp,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      "Resend",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 48.h),
              CustomElevatedButton(
                onPressed: _onVerify,
                title: "Verify",
                color: theme.colorScheme.primary,
                textColor: theme.colorScheme.onPrimary,
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/logo/app_logo.svg',
          height: 28.h,
          colorFilter: ColorFilter.mode(
            theme.colorScheme.primary,
            BlendMode.srcIn,
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          'Familyside',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontFamily: 'Quando',
            fontSize: 22.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.text,
          ),
        ),
      ],
    );
  }
}
