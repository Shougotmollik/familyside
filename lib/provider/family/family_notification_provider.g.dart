// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_notification_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FamilyNotification)
final familyNotificationProvider = FamilyNotificationProvider._();

final class FamilyNotificationProvider
    extends $AsyncNotifierProvider<FamilyNotification, NotificationResponse> {
  FamilyNotificationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'familyNotificationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$familyNotificationHash();

  @$internal
  @override
  FamilyNotification create() => FamilyNotification();
}

String _$familyNotificationHash() =>
    r'b8644fb85a26b201348bd522574cb4cdc8f0e63b';

abstract class _$FamilyNotification
    extends $AsyncNotifier<NotificationResponse> {
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
