// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FamilyProfile)
final familyProfileProvider = FamilyProfileProvider._();

final class FamilyProfileProvider
    extends $AsyncNotifierProvider<FamilyProfile, FamilyProfileData?> {
  FamilyProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'familyProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$familyProfileHash();

  @$internal
  @override
  FamilyProfile create() => FamilyProfile();
}

String _$familyProfileHash() => r'07457234a9f3cfe37147720c15870479e892078e';

abstract class _$FamilyProfile extends $AsyncNotifier<FamilyProfileData?> {
  FutureOr<FamilyProfileData?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<FamilyProfileData?>, FamilyProfileData?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<FamilyProfileData?>, FamilyProfileData?>,
              AsyncValue<FamilyProfileData?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
