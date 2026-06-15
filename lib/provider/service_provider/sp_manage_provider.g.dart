// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sp_manage_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SpManageProvider)
final spManageProviderProvider = SpManageProviderProvider._();

final class SpManageProviderProvider
    extends $AsyncNotifierProvider<SpManageProvider, AsyncValue<void>> {
  SpManageProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'spManageProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$spManageProviderHash();

  @$internal
  @override
  SpManageProvider create() => SpManageProvider();
}

String _$spManageProviderHash() => r'59e545e04046e404f28495b662eff8ebd3ca7e01';

abstract class _$SpManageProvider extends $AsyncNotifier<AsyncValue<void>> {
  FutureOr<AsyncValue<void>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<AsyncValue<void>>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AsyncValue<void>>, AsyncValue<void>>,
              AsyncValue<AsyncValue<void>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
