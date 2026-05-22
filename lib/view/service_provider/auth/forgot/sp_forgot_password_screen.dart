import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/core/router/router_path.dart';
import 'package:familyside/utils/form_validator.dart';
import 'package:familyside/view/widgets/auth_text_form_field.dart';
import 'package:familyside/view/widgets/custom_elevated_button.dart';

class SpForgotPasswordScreen extends StatefulWidget {
  const SpForgotPasswordScreen({super.key});

  @override
  State<SpForgotPasswordScreen> createState() =>
      _SpForgotPasswordScreenState();
}

class _SpForgotPasswordScreenState extends State<SpForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSend() {
    FormValidator.validateAndProceed(_formKey, () {
      context.push(RouterPath.spVerifyOtpScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40.h),
                _buildLogoSection(theme),
                SizedBox(height: 32.h),
                Text(
                  "Forgot Password",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 32.sp,
                    color: AppColors.text,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Enter your email to reset your password",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.lightText,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 48.h),
                Text(
                  "Email",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                AuthTextFormField(
                  hintText: "Enter your email",
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: AppColors.lightText,
                    size: 22.sp,
                  ),
                  onFieldSubmitted: (_) => _onSend(),
                  validator: FormValidator.validateEmail,
                ),
                SizedBox(height: 48.h),
                CustomElevatedButton(
                  onPressed: _onSend,
                  title: "Send OTP",
                  color: theme.colorScheme.primary,
                  textColor: theme.colorScheme.onPrimary,
                ),
                SizedBox(height: 24.h),
              ],
            ),
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
