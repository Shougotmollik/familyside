// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'explorer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ExplorerProvider)
final explorerProviderProvider = ExplorerProviderProvider._();

final class ExplorerProviderProvider
    extends $AsyncNotifierProvider<ExplorerProvider, List<GiftApiItem>> {
  ExplorerProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'explorerProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$explorerProviderHash();

  @$internal
  @override
  ExplorerProvider create() => ExplorerProvider();
}

String _$explorerProviderHash() => r'32d05d55bf92812f2ea180069c700e41e9b296c7';

abstract class _$ExplorerProvider extends $AsyncNotifier<List<GiftApiItem>> {
  FutureOr<List<GiftApiItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<GiftApiItem>>, List<GiftApiItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<GiftApiItem>>, List<GiftApiItem>>,
              AsyncValue<List<GiftApiItem>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
