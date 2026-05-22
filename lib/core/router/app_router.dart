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
import 'package:familyside/view/service_provider/auth/login/sp_login_screen.dart';
import 'package:familyside/view/service_provider/auth/signup/sp_signup_screen.dart';
import 'package:familyside/view/service_provider/auth/forgot/sp_forgot_password_screen.dart';
import 'package:familyside/view/service_provider/auth/forgot/sp_otp_verification_screen.dart';
import 'package:familyside/view/service_provider/auth/forgot/sp_reset_password_screen.dart';
import 'package:familyside/view/service_provider/auth/forgot/sp_password_reset_success.dart';
import 'package:familyside/view/service_provider/auth/signup/sp_signup_otp_verification_screen.dart';
import 'package:familyside/view/service_provider/auth/signup/sp_upload_image_screen.dart';
import 'package:familyside/view/service_provider/auth/signup/sp_profile_setup_screen.dart';
import 'package:familyside/view/service_provider/sp_main_nav_bar_screen.dart';
import 'package:familyside/view/family/gift/gift_all_screen.dart';
import 'package:familyside/view/family/gift/gift_list_detail_screen.dart';
import 'package:familyside/view/family/gift/my_gift_list_screen.dart';
import 'package:familyside/view/family/gift/widgets/my_gift_list_models.dart';
import 'package:familyside/view/family/explorer/explorer_map_screen.dart';
import 'package:familyside/view/family/explorer/models/explorer_map_screen_config.dart';
import 'package:familyside/view/family/home/recomandation_screen.dart';
import 'package:familyside/view/family/home/sub_category_list_screen.dart';
import 'package:familyside/view/family/home/sub_category_list_screen_config.dart';
import 'package:familyside/view/family/notification/notification_screen.dart';
import 'package:familyside/view/family/profile/family_change_password_screen.dart';
import 'package:familyside/view/family/profile/family_edit_profile_screen.dart';
import 'package:familyside/view/family/profile/contact_support_screen.dart';
import 'package:familyside/view/family/profile/suggestion_screen.dart';
import 'package:familyside/view/family/profile/update_child_information.dart';
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

      // Service Provider Auth Routes
      GoRoute(
        path: RouterPath.spLoginScreen,
        builder: (context, state) => const SpLoginScreen(),
      ),
      GoRoute(
        path: RouterPath.spSignUpScreen,
        builder: (context, state) => const SpSignupScreen(),
      ),
      GoRoute(
        path: RouterPath.spForgotPasswordScreen,
        builder: (context, state) => const SpForgotPasswordScreen(),
      ),
      GoRoute(
        path: RouterPath.spVerifyOtpScreen,
        builder: (context, state) => const SpOtpVerificationScreen(),
      ),
      GoRoute(
        path: RouterPath.spResetPasswordScreen,
        builder: (context, state) => const SpResetPasswordScreen(),
      ),
      GoRoute(
        path: RouterPath.spPasswordResetSuccess,
        builder: (context, state) => const SpPasswordResetSuccessScreen(),
      ),
      GoRoute(
        path: RouterPath.spSignupOtpVerificationScreen,
        builder: (context, state) => const SpSignupOtpVerificationScreen(),
      ),
      GoRoute(
        path: RouterPath.spUploadImageScreen,
        builder: (context, state) => const SpUploadImageScreen(),
      ),
      GoRoute(
        path: RouterPath.spProfileSetupScreen,
        builder: (context, state) => const SpProfileSetupScreen(),
      ),
      GoRoute(
        path: RouterPath.spMainNavBarScreen,
        builder: (context, state) => const SpMainNavBarScreen(),
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
      GoRoute(
        path: RouterPath.familyGiftAllScreen,
        builder: (context, state) => GiftAllScreen(
          config: state.extra as GiftAllScreenConfig,
        ),
      ),
      GoRoute(
        path: RouterPath.familyMyGiftListScreen,
        builder: (context, state) => MyGiftListScreen(
          config: state.extra as MyGiftListScreenConfig,
        ),
      ),
      GoRoute(
        path: RouterPath.familyGiftListDetailScreen,
        builder: (context, state) => GiftListDetailScreen(
          config: state.extra as GiftListDetailScreenConfig,
        ),
      ),
      GoRoute(
        path: RouterPath.familyChangePasswordScreen,
        builder: (context, state) => const FamilyChangePasswordScreen(),
      ),
      GoRoute(
        path: RouterPath.familyEditProfileScreen,
        builder: (context, state) => const FamilyEditProfileScreen(),
      ),
      GoRoute(
        path: RouterPath.familyUpdateChildInformationScreen,
        builder: (context, state) => const UpdateChildInformationScreen(),
      ),
      GoRoute(
        path: RouterPath.familyContactSupportScreen,
        builder: (context, state) => const ContactSupportScreen(),
      ),
      GoRoute(
        path: RouterPath.familySuggestionScreen,
        builder: (context, state) => const SuggestionScreen(),
      ),
      GoRoute(
        path: RouterPath.familyExplorerMapScreen,
        builder: (context, state) {
          final config = state.extra as ExplorerMapScreenConfig?;
          return ExplorerMapScreen(
            config: config ?? ExplorerMapScreenConfig.defaults(),
          );
        },
      ),
      GoRoute(
        path: RouterPath.familySubCategoryListScreen,
        builder: (context, state) => SubCategoryListScreen(
          config: state.extra as SubCategoryListScreenConfig,
        ),
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.error}'))),
  );
}
