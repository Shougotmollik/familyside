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

String _$homeProviderHash() => r'16d7b7762cb1b653a7940d28599d2a4e77fc3b4b';

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

@ProviderFor(SavedItemsProvider)
final savedItemsProviderProvider = SavedItemsProviderProvider._();

final class SavedItemsProviderProvider
    extends
        $AsyncNotifierProvider<
          SavedItemsProvider,
          Map<String, List<GiftApiItem>>
        > {
  SavedItemsProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'savedItemsProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$savedItemsProviderHash();

  @$internal
  @override
  SavedItemsProvider create() => SavedItemsProvider();
}

String _$savedItemsProviderHash() =>
    r'1ea6e2d186c4e6e7702b67461697a6145ad488ff';

abstract class _$SavedItemsProvider
    extends $AsyncNotifier<Map<String, List<GiftApiItem>>> {
  FutureOr<Map<String, List<GiftApiItem>>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<Map<String, List<GiftApiItem>>>,
              Map<String, List<GiftApiItem>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Map<String, List<GiftApiItem>>>,
                Map<String, List<GiftApiItem>>
              >,
              AsyncValue<Map<String, List<GiftApiItem>>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
