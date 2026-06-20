import 'dart:io';

import 'package:familyside/core/constants/api_constant.dart';
import 'package:familyside/model/family_child_info.dart';
import 'package:familyside/model/family_profile_data.dart';
import 'package:familyside/model/family_review.dart';
import 'package:familyside/model/suggestion_item.dart';
import 'package:familyside/services/custom_http.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'family_profile_provider.g.dart';

@riverpod
class FamilyProfile extends _$FamilyProfile {
  @override
  FutureOr<FamilyProfileData?> build() async {
    return await _getProfileData();
  }

  Future<FamilyProfileData?> _getProfileData() async {
    try {
      final response = await CustomHttp.get(
        endpoint: ApiConstants.familyProfile,
      );
      if (response.ok && response.data != null) {
        return FamilyProfileData.fromJson(
          response.data['data'] as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching family profile data: $e');
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
        endpoint: ApiConstants.familyProfileUpdate,
        fieldName: 'photo',
        filePath: image?.path,
        fields: {'full_name': name!, 'location_name': location!},
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

  Future<bool> contactSupport({
    required String email,
    required String location,
    required String problemDetails,
  }) async {
    state = const AsyncLoading();
    try {
      final response = await CustomHttp.post(
        endpoint: ApiConstants.contactSupport,
        body: {
          'email': email,
          'location': location,
          'problem_details': problemDetails,
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
      debugPrint('Error contacting support: $e');
      state = AsyncError(e, st);
      return false;
    }
  }

  // get child info
  Future<FamilyChildInfoData?> getChildInfo() async {
    try {
      final response = await CustomHttp.get(
        endpoint: ApiConstants.familyChildInfo,
      );
      if (response.ok && response.data != null) {
        return FamilyChildInfoData.fromJson(
          response.data['data'] as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching child info: $e');
      return null;
    }
  }

  // update child info
  Future<bool> updateChildInfo({
    required String locationName,
    required bool isExpecting,
    String? expectedDueDate,
    required List<Map<String, dynamic>> children,
  }) async {
    try {
      final response = await CustomHttp.put(
        endpoint: ApiConstants.familyChildInfo,
        add_api_prefix: true,
        body: {
          'location_name': locationName,
          'is_expecting': isExpecting,
          if (expectedDueDate != null) 'expected_due_date': expectedDueDate,
          'children': children,
        },
      );
      if (response.ok) {
        state = AsyncData(await _getProfileData());
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error updating child info: $e');
      return false;
    }
  }

  // get reviews
  Future<List<FamilyReview>> getReviews() async {
    try {
      final response = await CustomHttp.get(
        endpoint: ApiConstants.familyReviews,
      );
      if (response.ok && response.data != null) {
        final items = (response.data['data'] as List<dynamic>?) ?? [];
        return items
            .map((e) => FamilyReview.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching reviews: $e');
      return [];
    }
  }

  // get suggestions
  Future<List<SuggestionItem>> getSuggestions() async {
    try {
      final response = await CustomHttp.get(endpoint: ApiConstants.suggestions);
      if (response.ok && response.data != null) {
        final items = (response.data['data']['items'] as List<dynamic>?) ?? [];
        return items
            .map((e) => SuggestionItem.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching suggestions: $e');
      return [];
    }
  }
}
