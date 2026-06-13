// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sp_home_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SpHomeProvider)
final spHomeProviderProvider = SpHomeProviderProvider._();

final class SpHomeProviderProvider
    extends $AsyncNotifierProvider<SpHomeProvider, Map<String, dynamic>> {
  SpHomeProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'spHomeProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$spHomeProviderHash();

  @$internal
  @override
  SpHomeProvider create() => SpHomeProvider();
}

String _$spHomeProviderHash() => r'8d1955aab7f00320234c0065b02918f2e46cd201';

abstract class _$SpHomeProvider extends $AsyncNotifier<Map<String, dynamic>> {
  FutureOr<Map<String, dynamic>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<Map<String, dynamic>>, Map<String, dynamic>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Map<String, dynamic>>,
                Map<String, dynamic>
              >,
              AsyncValue<Map<String, dynamic>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
