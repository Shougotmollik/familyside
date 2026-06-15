// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sp_profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SpProfile)
final spProfileProvider = SpProfileProvider._();

final class SpProfileProvider
    extends $AsyncNotifierProvider<SpProfile, ProviderProfileData?> {
  SpProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'spProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$spProfileHash();

  @$internal
  @override
  SpProfile create() => SpProfile();
}

String _$spProfileHash() => r'9647c63d98e0a97ca7dcb30cf78a360fde267d5a';

abstract class _$SpProfile extends $AsyncNotifier<ProviderProfileData?> {
  FutureOr<ProviderProfileData?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<ProviderProfileData?>, ProviderProfileData?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<ProviderProfileData?>,
                ProviderProfileData?
              >,
              AsyncValue<ProviderProfileData?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
