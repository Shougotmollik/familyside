// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HomeProvider)
final homeProviderProvider = HomeProviderProvider._();

final class HomeProviderProvider
    extends $AsyncNotifierProvider<HomeProvider, Map<String, dynamic>> {
  HomeProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeProviderHash();

  @$internal
  @override
  HomeProvider create() => HomeProvider();
}

String _$homeProviderHash() => r'62a2c61cb03217daf111dde6907d3c81f599d885';

abstract class _$HomeProvider extends $AsyncNotifier<Map<String, dynamic>> {
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
