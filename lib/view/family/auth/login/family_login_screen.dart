import 'package:familyside/view/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/core/router/router_path.dart';
import 'package:familyside/utils/form_validator.dart';
import 'package:familyside/view/widgets/auth_text_form_field.dart';
import 'package:familyside/view/widgets/social_login_button.dart';

class FamilyLoginScreen extends StatefulWidget {
  const FamilyLoginScreen({super.key});

  @override
  State<FamilyLoginScreen> createState() => _FamilyLoginScreenState();
}

class _FamilyLoginScreenState extends State<FamilyLoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignIn() {
    if (FormValidator.validateAndProceed(_formKey, () {})) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                  "Sign In",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 32.sp,
                    color: AppColors.text,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Sign in to your account",
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
                  textInputAction: TextInputAction.next,
                  validator: FormValidator.validateEmail,
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: AppColors.lightText,
                    size: 22.sp,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  "Password",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                AuthTextFormField(
                  hintText: "Enter your password",
                  controller: _passwordController,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  prefixIcon: Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.lightText,
                    size: 22.sp,
                  ),
                  onFieldSubmitted: (_) => _onSignIn(),
                  validator: FormValidator.validatePassword,
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 24.w,
                          width: 24.w,
                          child: Checkbox(
                            value: _rememberMe,
                            activeColor: const Color(0xFF3B82F6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            side: BorderSide(
                              color: AppColors.lightText.withOpacity(0.5),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 8.w),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _rememberMe = !_rememberMe;
                            });
                          },
                          child: Text(
                            "Remember me",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.text,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        context.push(RouterPath.familyForgotPasswordScreen);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        "Forgot Password?",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 60.h),
                CustomElevatedButton(
                  onPressed: _onSignIn,
                  title: "Sign In",
                  color: theme.colorScheme.primary,
                  textColor: theme.colorScheme.onPrimary,
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
                      "Or, continue with",
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
                      "Don't have an account? ",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.lightText,
                        fontSize: 14.sp,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.push(RouterPath.familySignUpScreen);
                      },
                      child: Text(
                        "Sign Up",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
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
