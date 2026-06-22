// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SearchProvider)
final searchProviderProvider = SearchProviderProvider._();

final class SearchProviderProvider
    extends $AsyncNotifierProvider<SearchProvider, Map<String, dynamic>> {
  SearchProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchProviderHash();

  @$internal
  @override
  SearchProvider create() => SearchProvider();
}

String _$searchProviderHash() => r'5728ed4d923440488df3069a1c5a63fc863d15c1';

abstract class _$SearchProvider extends $AsyncNotifier<Map<String, dynamic>> {
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

@ProviderFor(searchResults)
final searchResultsProvider = SearchResultsFamily._();

final class SearchResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GiftApiItem>>,
          List<GiftApiItem>,
          FutureOr<List<GiftApiItem>>
        >
    with
        $FutureModifier<List<GiftApiItem>>,
        $FutureProvider<List<GiftApiItem>> {
  SearchResultsProvider._({
    required SearchResultsFamily super.from,
    required ({String? mode, int? categoryId, String? query}) super.argument,
  }) : super(
         retry: null,
         name: r'searchResultsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$searchResultsHash();

  @override
  String toString() {
    return r'searchResultsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<GiftApiItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<GiftApiItem>> create(Ref ref) {
    final argument =
        this.argument as ({String? mode, int? categoryId, String? query});
    return searchResults(
      ref,
      mode: argument.mode,
      categoryId: argument.categoryId,
      query: argument.query,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SearchResultsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$searchResultsHash() => r'67919bf075bdc88928cbc786f144cd793cfe7469';

final class SearchResultsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<GiftApiItem>>,
          ({String? mode, int? categoryId, String? query})
        > {
  SearchResultsFamily._()
    : super(
        retry: null,
        name: r'searchResultsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SearchResultsProvider call({String? mode, int? categoryId, String? query}) =>
      SearchResultsProvider._(
        argument: (mode: mode, categoryId: categoryId, query: query),
        from: this,
      );

  @override
  String toString() => r'searchResultsProvider';
}
