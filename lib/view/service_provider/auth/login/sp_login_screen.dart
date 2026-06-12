import 'package:familyside/provider/auth_provider.dart';
import 'package:familyside/view/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/core/router/router_path.dart';
import 'package:familyside/utils/form_validator.dart';
import 'package:familyside/view/widgets/auth_text_form_field.dart';
import 'package:familyside/view/widgets/social_login_button.dart';

class SpLoginScreen extends ConsumerWidget {
  SpLoginScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rememberMe = ValueNotifier<bool>(false);

  Future<void> _onSignIn(WidgetRef ref, BuildContext context) async {
    if (!FormValidator.validateAndProceed(_formKey, () {})) return;

    await ref
        .read(authProvider.notifier)
        .login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    ref.listen(authProvider, (prev, next) {
      next.whenOrNull(
        data: (authenticated) {
          if (authenticated && prev?.value != true) {
            context.pushReplacement(RouterPath.spMainNavBarScreen);
          }
        },
      );
    });

    final authState = ref.watch(authProvider);

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
                  onFieldSubmitted: (_) => _onSignIn(ref, context),
                  // validator: FormValidator.validatePassword,
                ),
                SizedBox(height: 8.h),
                ValueListenableBuilder<bool>(
                  valueListenable: _rememberMe,
                  builder: (context, rememberMe, _) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 24.w,
                              width: 24.w,
                              child: Checkbox(
                                value: rememberMe,
                                activeColor: AppColors.primaryLight,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                side: BorderSide(
                                  color: AppColors.lightText.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                                onChanged: (value) =>
                                    _rememberMe.value = value ?? false,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            GestureDetector(
                              onTap: () => _rememberMe.value = !rememberMe,
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
                            context.push(RouterPath.spForgotPasswordScreen);
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
                    );
                  },
                ),
                SizedBox(height: 60.h),
                CustomElevatedButton(
                  onPressed: () => _onSignIn(ref, context),
                  title: "Sign In",
                  color: theme.colorScheme.primary,
                  textColor: theme.colorScheme.onPrimary,
                  isLoading: authState.isLoading,
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
                      onPressed: () {
                        context.push(RouterPath.spMainNavBarScreen);
                      },
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
                        context.push(RouterPath.spSignUpScreen);
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
