import 'dart:io';

import 'package:familyside/core/constants/api_constant.dart';
import 'package:familyside/model/child_info.dart';
import 'package:familyside/model/interest.dart';
import 'package:familyside/services/custom_http.dart';
import 'package:familyside/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'onboarding_controller.g.dart';

@riverpod
class Onboarding extends _$Onboarding {
  @override
  FutureOr<bool> build() async {
    return false;
  }

  void _safeState(AsyncValue<bool> newState) {
    try {
      state = newState;
    } catch (_) {}
  }

  //role
  Future<bool> setRole({required String role}) async {
    try {
      final response = await CustomHttp.patch(
        endpoint: ApiConstants.setRole,
        body: {'role': role},
        need_auth: true,
      );

      if (!response.ok) {
        _safeState(AsyncError(
          response.error ?? 'Invalid role',
          StackTrace.current,
        ));

        AppSnackbar.show(message: response.error?.toString() ?? 'Invalid role');
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

  // childInfo
  Future<bool> childInfo(ChildInfo data) async {
    _safeState(const AsyncLoading());

    try {
      final response = await CustomHttp.post(
        endpoint: ApiConstants.childInfo,
        need_auth: true,
        body: data.toJson(),
      );

      if (!response.ok) {
        final msg = response.error ?? 'Invalid child info';

        _safeState(AsyncError(msg, StackTrace.current));
        AppSnackbar.show(message: msg);
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

  // get interests
  FutureOr<List<Interest>> getInterests() async {
    try {
      final response = await CustomHttp.get(
        endpoint: ApiConstants.interests,
        need_auth: true,
      );
      if (!response.ok) {
        debugPrint(response.error?.toString());
        return [];
      }
      final data = response.data['data'];
      final interests = data
          .map<Interest>((e) => Interest.fromJson(e))
          .toList();
      return interests;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  // post interests
  Future<bool> postInterests({required List<int> interests}) async {
    _safeState(const AsyncLoading());
    try {
      final response = await CustomHttp.post(
        endpoint: ApiConstants.postInterests,
        need_auth: true,
        body: {"interest_ids": interests},
      );
      if (!response.ok) {
        _safeState(AsyncError(
          response.error ?? 'Invalid interests',
          StackTrace.current,
        ));
        AppSnackbar.show(
          message: response.error?.toString() ?? 'Invalid interests',
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

  // set location
  Future<bool> setLocation({
    required String locationName,
    required double lat,
    required double lng,
  }) async {
    _safeState(const AsyncLoading());
    try {
      final response = await CustomHttp.patch(
        endpoint: ApiConstants.location,
        need_auth: true,
        body: {"location_name": locationName, "lat": lat, "lng": lng},
      );
      if (!response.ok) {
        _safeState(AsyncError(
          response.error ?? 'Invalid location',
          StackTrace.current,
        ));
        AppSnackbar.show(
          message: response.error?.toString() ?? 'Invalid location',
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

  // profile image
  Future<bool> profileImage({required File image}) async {
    _safeState(const AsyncLoading());
    try {
      final response = await CustomHttp.multipart(
        endpoint: ApiConstants.profileImage,
        fieldName: 'file',
        filePath: image.path,
        need_auth: true,
      );

      if (!response.ok) {
        _safeState(AsyncError(
          response.error ?? 'Invalid profile image',
          StackTrace.current,
        ));
        AppSnackbar.show(
          message: response.error?.toString() ?? 'Invalid profile image',
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

  // social links
  Future<bool> socialLinks(List<SocialLink> links) async {
    _safeState(const AsyncLoading());

    try {
      final response = await CustomHttp.post(
        endpoint: ApiConstants.socialLinks,
        need_auth: true,
        body: {"links": links.map((e) => e.toJson()).toList()},
      );

      if (!response.ok) {
        final msg = response.error ?? 'Invalid social links';

        _safeState(AsyncError(msg, StackTrace.current));
        AppSnackbar.show(message: msg);
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
}

class SocialLink {
  final String platform;
  final String url;

  SocialLink({required this.platform, required this.url});

  Map<String, dynamic> toJson() {
    return {"platform": platform, "url": url};
  }
}
