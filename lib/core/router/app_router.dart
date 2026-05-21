import 'package:familyside/view/family/auth/forgot/family_forgot_password_screen.dart';
import 'package:familyside/view/family/auth/login/family_login_screen.dart';
import 'package:familyside/view/family/auth/forgot/family_otp_verfication_screen.dart';
import 'package:familyside/view/family/auth/forgot/family_password_reset_success.dart';
import 'package:familyside/view/family/auth/forgot/family_reset_password_screen.dart';
import 'package:familyside/view/family/auth/signup/child_infomation_screen.dart';
import 'package:familyside/view/family/auth/signup/interest_screen.dart';
import 'package:familyside/view/family/auth/signup/location_info_screen.dart';
import 'package:familyside/view/family/auth/signup/family_upload_image_screen.dart';
import 'package:familyside/view/family/auth/signup/family_signup_screen.dart';
import 'package:familyside/view/family/auth/signup/family_choose_role_screen.dart';
import 'package:familyside/view/family/auth/signup/family_signup_otp_verfication.dart';
import 'package:familyside/view/family/family_main_nav_bar_screen.dart';
import 'package:familyside/view/family/home/recomandation_screen.dart';
import 'package:familyside/view/family/notification/notification_screen.dart';
import 'package:familyside/view/onboarding/onboarding_screen.dart';
import 'package:familyside/view/onboarding/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'router_path.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouterPath.splashScreen,
    routes: [
      GoRoute(
        path: RouterPath.splashScreen,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouterPath.onBoardingScreen,
        builder: (context, state) => const OnBoardingScreen(),
      ),

      // Family Auth Routes
      GoRoute(
        path: RouterPath.familyLoginScreen,
        builder: (context, state) => const FamilyLoginScreen(),
      ),
      GoRoute(
        path: RouterPath.familySignUpScreen,
        builder: (context, state) => const FamilySignupScreen(),
      ),
      GoRoute(
        path: RouterPath.familyForgotPasswordScreen,
        builder: (context, state) => const FamilyForgotPasswordScreen(),
      ),
      GoRoute(
        path: RouterPath.familyVerifyOtpScreen,
        builder: (context, state) => const FamilyOtpVerificationScreen(),
      ),
      GoRoute(
        path: RouterPath.familyResetPasswordScreen,
        builder: (context, state) => const FamilyResetPasswordScreen(),
      ),
      GoRoute(
        path: RouterPath.familyPasswordResetSuccess,
        builder: (context, state) => const FamilyPasswordResetSuccessScreen(),
      ),
      GoRoute(
        path: RouterPath.familyChooseRoleScreen,
        builder: (context, state) => const FamilyChooseRoleScreen(),
      ),
      GoRoute(
        path: RouterPath.familySignupOtpVerificationScreen,
        builder: (context, state) => const FamilySignupOtpVerificationScreen(),
      ),
      GoRoute(
        path: RouterPath.familyChildInformationScreen,
        builder: (context, state) => const ChildInfomationScreen(),
      ),
      GoRoute(
        path: RouterPath.familyInterestScreen,
        builder: (context, state) => const InterestScreen(),
      ),
      GoRoute(
        path: RouterPath.familyLocationInfoScreen,
        builder: (context, state) => const LocationInfoScreen(),
      ),
      GoRoute(
        path: RouterPath.familyUploadImageScreen,
        builder: (context, state) => const FamilyUploadImageScreen(),
      ),
      GoRoute(
        path: RouterPath.familyMainNavBarScreen,
        builder: (context, state) => const FamilyMainNavBarScreen(),
      ),
      GoRoute(
        path: RouterPath.familyNotificationScreen,
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(
        path: RouterPath.familyRecommendationScreen,
        builder: (context, state) => RecommendationScreen(
          config: state.extra as ListScreenConfig,
        ),
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.error}'))),
  );
}
