import 'package:familyside/core/localization/app_localizations.dart';
import 'package:familyside/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/core/router/router_path.dart';
import 'package:familyside/utils/form_validator.dart';
import 'package:familyside/view/widgets/auth_text_form_field.dart';
import 'package:familyside/view/widgets/custom_elevated_button.dart';
import 'package:familyside/view/widgets/social_login_button.dart';

class FamilySignupScreen extends ConsumerStatefulWidget {
  const FamilySignupScreen({super.key});

  @override
  ConsumerState<FamilySignupScreen> createState() => _FamilySignupScreenState();
}

class _FamilySignupScreenState extends ConsumerState<FamilySignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onSignUp() async {
    if (!FormValidator.validateAndProceed(_formKey, () {})) return;

    final result = await ref
        .read(authProvider.notifier)
        .signup(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          userType: 'family',
        );

    if (result != null && mounted) {
      context.push(
        RouterPath.familySignupOtpVerificationScreen,
        extra: result['email'],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 60.h),
                _buildLogoSection(theme),
                SizedBox(height: 32.h),
                Text(
                  loc.translate('signUp'),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 32.sp,
                    color: AppColors.text,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  loc.translate('createAccount'),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.lightText,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 48.h),
                Text(
                  loc.translate('name'),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                AuthTextFormField(
                  hintText: loc.translate('enterName'),
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: AppColors.lightText,
                    size: 22.sp,
                  ),
                  validator: FormValidator.validateName,
                ),
                SizedBox(height: 16.h),
                Text(
                  loc.translate('email'),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                AuthTextFormField(
                  hintText: loc.translate('enterEmail'),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: AppColors.lightText,
                    size: 22.sp,
                  ),
                  validator: FormValidator.validateEmail,
                ),
                SizedBox(height: 16.h),
                Text(
                  loc.translate('password'),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                AuthTextFormField(
                  hintText: loc.translate('enterPassword'),
                  controller: _passwordController,
                  isPassword: true,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.lightText,
                    size: 22.sp,
                  ),
                  validator: FormValidator.validatePassword,
                ),
                SizedBox(height: 16.h),
                Text(
                  loc.translate('confirmPassword'),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                AuthTextFormField(
                  hintText: loc.translate('confirmYourPassword'),
                  controller: _confirmPasswordController,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  prefixIcon: Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.lightText,
                    size: 22.sp,
                  ),
                  onFieldSubmitted: (_) => _onSignUp(),
                  validator: (value) => FormValidator.validateConfirmPassword(
                    value,
                    _passwordController.text,
                  ),
                ),
                SizedBox(height: 48.h),
                CustomElevatedButton(
                  onPressed: _onSignUp,
                  title: loc.translate('signUp'),
                  color: theme.colorScheme.primary,
                  textColor: theme.colorScheme.onPrimary,
                  isLoading: ref.watch(authProvider).isLoading,
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1.0,
                        color: AppColors.lightText.withValues(alpha: 0.3),
                        endIndent: 10.w,
                      ),
                    ),
                    Text(
                      loc.translate('orContinueWith'),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.text,
                        fontSize: 14.sp,
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1.0,
                        color: AppColors.lightText.withValues(alpha: 0.3),
                        indent: 10.w,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialLoginButton(
                      onPressed: () {},
                      iconPath: 'assets/logo/apple.svg',
                    ),
                    SizedBox(width: 24.w),
                    SocialLoginButton(
                      onPressed: () {},
                      iconPath: 'assets/logo/google.svg',
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      loc.translate('alreadyHaveAccount'),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.lightText,
                        fontSize: 14.sp,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.pop();
                      },
                      child: Text(
                        loc.translate('signIn'),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
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
    final loc = AppLocalizations.of(context);
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
          loc.translate('brandName'),
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
