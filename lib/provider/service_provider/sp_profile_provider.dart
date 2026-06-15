import 'dart:io';

import 'package:familyside/core/constants/api_constant.dart';
import 'package:familyside/model/provider_profile_data.dart';
import 'package:familyside/services/custom_http.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sp_profile_provider.g.dart';

@riverpod
class SpProfile extends _$SpProfile {
  @override
  FutureOr<ProviderProfileData?> build() async {
    return await _getProfileData();
  }

  Future<ProviderProfileData?> _getProfileData() async {
    try {
      final response = await CustomHttp.get(
        endpoint: ApiConstants.providerProfile,
      );
      if (response.ok && response.data != null) {
        return ProviderProfileData.fromJson(
          response.data['data'] as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching profile data: $e');
      return null;
    }
  }

  // update profile
  Future<bool> updateProfile({
    File? image,
    String? name,
    String? location,
  }) async {
    state = const AsyncLoading();
    try {
      final response = await CustomHttp.multipart(
        endpoint: ApiConstants.providerProfileUpdate,
        fieldName: 'profile_image',
        filePath: image?.path,
        fields: {'name': name!, 'location': location!},
        method: 'PUT',
      );
      if (response.ok) {
        state = AsyncData(await _getProfileData());
        return true;
      }
      state = AsyncError(
        response.error ?? 'Something went wrong',
        StackTrace.current,
      );
      return false;
    } catch (e, st) {
      debugPrint('Error updating profile: $e');
      state = AsyncError(e, st);
      return false;
    }
  }

  // change password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = const AsyncLoading();
    try {
      final response = await CustomHttp.post(
        endpoint: ApiConstants.changePassword,
        body: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
      );
      if (response.ok) {
        state = AsyncData(await _getProfileData());
        return true;
      } else {
        state = AsyncError(
          response.error ?? 'Something went wrong',
          StackTrace.current,
        );
        return false;
      }
    } catch (e, st) {
      debugPrint('Error changing password: $e');
      state = AsyncError(e, st);
      return false;
    }
  }
}
