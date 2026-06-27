// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sp_notification_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SpNotification)
final spNotificationProvider = SpNotificationProvider._();

final class SpNotificationProvider
    extends $AsyncNotifierProvider<SpNotification, NotificationResponse> {
  SpNotificationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'spNotificationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$spNotificationHash();

  @$internal
  @override
  SpNotification create() => SpNotification();
}

String _$spNotificationHash() => r'ecac47272e925510d652f2bafd51e8e44e92e635';

abstract class _$SpNotification extends $AsyncNotifier<NotificationResponse> {
  FutureOr<NotificationResponse> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<NotificationResponse>, NotificationResponse>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<NotificationResponse>,
                NotificationResponse
              >,
              AsyncValue<NotificationResponse>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
