// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sp_create_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SpCreateNotifier)
final spCreateProvider = SpCreateNotifierProvider._();

final class SpCreateNotifierProvider
    extends $AsyncNotifierProvider<SpCreateNotifier, void> {
  SpCreateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'spCreateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$spCreateNotifierHash();

  @$internal
  @override
  SpCreateNotifier create() => SpCreateNotifier();
}

String _$spCreateNotifierHash() => r'f2a1912b80812487c96b392b1e83d09a9fa5d06d';

abstract class _$SpCreateNotifier extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
