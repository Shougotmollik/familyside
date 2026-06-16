class ApiConstants {
  static const apiVersion = "/v1";

  static const String login = "$apiVersion/auth/login";
  static const String signup = "$apiVersion/auth/signup";
  static const String verifyEmail = "$apiVersion/auth/verify-signup";
  static const String forgotPassword = "$apiVersion/auth/forgot-password";
  static const String forgotOtpVerification = "$apiVersion/auth/verify-otp";
  static const String resetPassword = "$apiVersion/auth/reset-password";
  static const String changePassword = "$apiVersion/auth/change-password";
  static const String resendOtp = "$apiVersion/auth/resend-otp";
  static const String resendOtpForgotPassword =
      "$apiVersion/auth/resend-password-reset-otp";
  static const String refreshToken = "$apiVersion/auth/refresh";

  // onboarding
  static const String setRole = "$apiVersion/onboarding/role";
  static const String childInfo = "$apiVersion/onboarding/children";
  static const String interests = "$apiVersion/onboarding/interests/list";
  static const String postInterests = "$apiVersion/onboarding/interests";
  static const String location = "$apiVersion/onboarding/location";
  static const String profileImage = "$apiVersion/onboarding/profile-image";
  static const String socialLinks =
      "$apiVersion/onboarding/business/social-links";

  // service provider
  static const String providerHome = "$apiVersion/provider/home/feed";
  static const String providerHeader = "$apiVersion/provider/home/header";
  static const String providerManage = "$apiVersion/provider/manage/items";
  static String getProviderMangeItems({required int id}) =>
      "$apiVersion/provider/manage/items/$id";
  static const String getCatergoties = "$apiVersion/provider/categories/active";
  static String subCategories({required int categoryId}) =>
      "$apiVersion/provider/categories/$categoryId/sub-categories";

  static const String createActivity = "$apiVersion/provider/create/activity";
  static const String createEvent = "$apiVersion/provider/create/event";
  static const String createGift = "$apiVersion/provider/create/gift";

  static String updateActivity({required int id}) =>
      "$apiVersion/provider/manage/items/$id";
  static String updateEvent({required int id}) =>
      "$apiVersion/provider/manage/items/$id";
  static String updateGift({required int id}) =>
      "$apiVersion/provider/manage/items/$id";

  static const String analytics = "$apiVersion/provider/analytics";

  static const String providerProfile =
      "$apiVersion/provider/profile/dashboard";
  static const String providerProfileUpdate =
      "$apiVersion/provider/profile/update";

  // family
  static const String familyHeader = "$apiVersion/family/home/header";
  static const String familyHome = "$apiVersion/family/home/feed";
  static String familySubCategories({required int categoryId}) =>
      "$apiVersion/family/categories/$categoryId/sub-categories";
}
