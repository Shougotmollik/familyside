import 'package:familyside/core/constants/api_constant.dart';
import 'package:familyside/model/notification.dart';
import 'package:familyside/services/custom_http.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'family_notification_provider.g.dart';

@riverpod
class FamilyNotification extends _$FamilyNotification {
  @override
  FutureOr<NotificationResponse> build() {
    return NotificationResponse();
  }

  Future<void> fetchNotifications() async {
    try {
      state = const AsyncLoading();

      final response = await CustomHttp.get(
        endpoint: ApiConstants.familyNotification,
      );

      if (response.ok && response.data != null) {
        state = AsyncData(
          NotificationResponse.fromJson(response.data as Map<String, dynamic>),
        );
      } else {
        state = AsyncError(
          response.error ?? 'Failed to load notifications',
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<bool> markAllAsRead() async {
    try {
      final response = await CustomHttp.patch(
        endpoint: ApiConstants.familyNotificationMarkAllRead,
        need_auth: true,
      );

      if (response.ok) {
        await fetchNotifications();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Failed to mark all as read: $e');
      return false;
    }
  }
}
