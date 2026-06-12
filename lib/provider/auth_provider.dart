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

  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading();

    try {
      final response = await CustomHttp.post(
        endpoint: ApiConstants.login,
        body: {'email': email, 'password': password},
        need_auth: false,
      );

      if (!response.ok) {
        state = AsyncError(
          response.error ?? 'Invalid login',
          StackTrace.current,
        );

        AppSnackbar.show(
          message: response.error?.toString() ?? 'Invalid login credentials',
        );
        return;
      }

      final data = response.data?['data'];

      if (data == null) {
        state = AsyncError('Invalid server response', StackTrace.current);
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
      ]);

      state = const AsyncData(true);
    } catch (e) {
      debugPrint(e.toString());

      state = AsyncError(e, StackTrace.current);

      AppSnackbar.show(message: 'Something went wrong. Please try again.');
    }
  }
}
