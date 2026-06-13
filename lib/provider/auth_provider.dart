import 'package:familyside/core/constants/api_constant.dart';
import 'package:familyside/services/custom_http.dart';
import 'package:familyside/services/local_storage.dart';
import 'package:familyside/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  FutureOr<bool> build() async {
    final token = await LocalStorage.access_token.get();
    return token != null;
  }

  void _safeState(AsyncValue<bool> newState) {
    try {
      state = newState;
    } catch (_) {}
  }

  // login
  Future<void> login({required String email, required String password}) async {
    _safeState(const AsyncLoading());

    try {
      final response = await CustomHttp.post(
        endpoint: ApiConstants.login,
        body: {'email': email, 'password': password},
        need_auth: false,
      );

      if (!response.ok) {
        _safeState(
          AsyncError(response.error ?? 'Invalid login', StackTrace.current),
        );

        AppSnackbar.show(
          message: response.error?.toString() ?? 'Invalid login credentials',
        );
        return;
      }

      final data = response.data?['data'];

      if (data == null) {
        _safeState(AsyncError('Invalid server response', StackTrace.current));
        AppSnackbar.show(message: 'Invalid server response');
        return;
      }

      await Future.wait([
        LocalStorage.access_token.set(data['access_token']),
        LocalStorage.refresh_token.set(data['refresh_token']),
        LocalStorage.user_id.set(data['user_id']),
        LocalStorage.user_email.set(data['email']),
        LocalStorage.user_name.set(data['name']),
        LocalStorage.role.set(data['user_type']),
        LocalStorage.onboarding.set(data['onboarding_completed'] ?? false),
        LocalStorage.is_email_verified.set(data['is_email_verified'] ?? false),
      ]);

      _safeState(const AsyncData(true));
    } catch (e) {
      debugPrint(e.toString());

      _safeState(AsyncError(e, StackTrace.current));

      AppSnackbar.show(message: 'Something went wrong. Please try again.');
    }
  }

  // signup
  Future<Map<String, dynamic>?> signup({
    required String email,
    required String password,
    required String name,
    required String userType,
  }) async {
    _safeState(const AsyncLoading());
    try {
      final response = await CustomHttp.post(
        endpoint: ApiConstants.signup,
        body: {
          'name': name,
          'email': email,
          'password': password,
          'user_type': userType,
        },
        need_auth: false,
      );

      if (response.ok) {
        _safeState(const AsyncData(true));
        return {"email": email};
      } else {
        _safeState(
          AsyncError(response.error ?? 'Invalid signup', StackTrace.current),
        );
        AppSnackbar.show(message: response.error?.toString() ?? 'Invalid signup');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      _safeState(AsyncError(e, StackTrace.current));
      return null;
    }
  }

  // email verification
  Future<bool> verifyEmail({required String email, required String otp}) async {
    _safeState(const AsyncLoading());
    try {
      final response = await CustomHttp.post(
        endpoint: ApiConstants.verifyEmail,
        body: {"email": email, "otp": otp},
        need_auth: false,
      );

      if (!response.ok) {
        _safeState(
          AsyncError(
            response.error ?? 'Invalid verification',
            StackTrace.current,
          ),
        );

        AppSnackbar.show(
          message: response.error?.toString() ?? 'Invalid verification',
        );
        return false;
      }

      final data = response.data?['data'];
      if (data == null) {
        _safeState(AsyncError('Invalid server response', StackTrace.current));
        AppSnackbar.show(message: 'Invalid server response');
        return false;
      }

      await LocalStorage.access_token.set(data['access_token']);
      await LocalStorage.refresh_token.set(data['refresh_token']);
      await LocalStorage.user_id.set(data['user_id']);
      await LocalStorage.user_email.set(data['email']);
      await LocalStorage.user_name.set(data['name']);
      await LocalStorage.role.set(data['user_type']);
      await LocalStorage.onboarding.set(data['onboarding_completed'] ?? false);
      await LocalStorage.is_email_verified.set(
        data['is_email_verified'] ?? false,
      );

      _safeState(const AsyncData(true));
      return true;
    } catch (e) {
      debugPrint(e.toString());
      _safeState(AsyncError(e, StackTrace.current));
      AppSnackbar.show(message: 'Something went wrong. Please try again.');
      return false;
    }
  }

  // resend otp
  Future<bool> resendOTP({required String email}) async {
    try {
      final response = await CustomHttp.post(
        endpoint: ApiConstants.resendOtp,
        body: {"email": email},
        need_auth: false,
      );

      if (!response.ok) {
        AppSnackbar.show(
          message: response.error?.toString() ?? 'Failed to resend OTP',
        );
        return false;
      }

      AppSnackbar.show(message: 'OTP resent successfully');
      return true;
    } catch (e) {
      debugPrint(e.toString());
      AppSnackbar.show(message: 'Something went wrong. Please try again.');
      return false;
    }
  }

  // resent otp forgot password
  Future<bool> resendOtpForgotPassword({required String email}) async {
    try {
      final response = await CustomHttp.post(
        endpoint: ApiConstants.resendOtpForgotPassword,
        body: {"email": email},
        need_auth: false,
      );

      if (!response.ok) {
        AppSnackbar.show(
          message: response.error?.toString() ?? 'Failed to resend OTP',
        );
        return false;
      }

      AppSnackbar.show(message: 'OTP resent successfully');
      return true;
    } catch (e) {
      debugPrint(e.toString());
      AppSnackbar.show(message: 'Something went wrong. Please try again.');
      return false;
    }
  }

  // forgot password
  Future<bool> forgotPassword({required String email}) async {
    _safeState(const AsyncLoading());
    try {
      final response = await CustomHttp.post(
        endpoint: ApiConstants.forgotPassword,
        body: {"email": email},
        need_auth: false,
      );

      if (!response.ok) {
        _safeState(
          AsyncError(
            response.error ?? 'Invalid forgot password',
            StackTrace.current,
          ),
        );

        AppSnackbar.show(
          message: response.error?.toString() ?? 'Invalid forgot password',
        );
        return false;
      }

      _safeState(const AsyncData(true));
      return true;
    } catch (e) {
      debugPrint(e.toString());
      _safeState(AsyncError(e, StackTrace.current));
      AppSnackbar.show(message: 'Something went wrong. Please try again.');
      return false;
    }
  }

  // verify forgot otp
  Future<bool> verifyForgotPasswordOTP({
    required String email,
    required String otp,
  }) async {
    _safeState(const AsyncLoading());
    try {
      final response = await CustomHttp.post(
        endpoint: ApiConstants.forgotOtpVerification,
        body: {"email": email, "otp": otp},
        need_auth: false,
      );

      if (!response.ok) {
        _safeState(
          AsyncError(
            response.error ?? 'Invalid forgot OTP',
            StackTrace.current,
          ),
        );

        AppSnackbar.show(
          message: response.error?.toString() ?? 'Invalid forgot OTP',
        );
        return false;
      }

      _safeState(const AsyncData(true));
      return true;
    } catch (e) {
      debugPrint(e.toString());
      _safeState(AsyncError(e, StackTrace.current));
      AppSnackbar.show(message: 'Something went wrong. Please try again.');
      return false;
    }
  }

  // reset password
  Future<bool> resetPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await CustomHttp.post(
        endpoint: ApiConstants.resetPassword,
        body: {"email": email, "new_password": password},
        need_auth: false,
      );

      if (!response.ok) {
        AppSnackbar.show(
          message: response.error?.toString() ?? 'Invalid reset password',
        );
        return false;
      }

      return true;
    } catch (e) {
      debugPrint(e.toString());
      AppSnackbar.show(message: 'Something went wrong. Please try again.');
      return false;
    }
  }

  // refresh token
  Future<bool> refreshToken() async {
    _safeState(const AsyncLoading());
    try {
      final response = await CustomHttp.post(
        endpoint: ApiConstants.refreshToken,
        need_auth: false,
        body: {"refresh_token": await LocalStorage.refresh_token.get()},
      );

      if (!response.ok) {
        _safeState(
          AsyncError(
            response.error ?? 'Invalid refresh token',
            StackTrace.current,
          ),
        );

        debugPrint(response.error?.toString() ?? 'Invalid refresh token');
        return false;
      }

      final data = response.data?['data'];
      if (data == null) {
        _safeState(AsyncError('Invalid server response', StackTrace.current));
        debugPrint('Failed to refresh token: Invalid server response');
        return false;
      }

      await LocalStorage.access_token.set(data['access_token']);
      await LocalStorage.refresh_token.set(data['refresh_token']);

      _safeState(const AsyncData(true));
      return true;
    } catch (e) {
      debugPrint(e.toString());
      _safeState(AsyncError(e, StackTrace.current));
      debugPrint('Failed to refresh token: $e');
      return false;
    }
  }

  // logout
  Future<bool> logout() async {
    _safeState(const AsyncLoading());
    try {
      await LocalStorage.clear();
      _safeState(const AsyncData(false));
      return true;
    } catch (e) {
      debugPrint(e.toString());
      _safeState(const AsyncData(false));
      return false;
    }
  }
}
