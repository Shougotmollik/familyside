// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sp_analytics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SpAnalytics)
final spAnalyticsProvider = SpAnalyticsProvider._();

final class SpAnalyticsProvider
    extends $AsyncNotifierProvider<SpAnalytics, List<Analytics>> {
  SpAnalyticsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'spAnalyticsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$spAnalyticsHash();

  @$internal
  @override
  SpAnalytics create() => SpAnalytics();
}

String _$spAnalyticsHash() => r'bf28dc159bc0e3e8ba06741e3444642cba9969ea';

abstract class _$SpAnalytics extends $AsyncNotifier<List<Analytics>> {
  FutureOr<List<Analytics>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Analytics>>, List<Analytics>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Analytics>>, List<Analytics>>,
              AsyncValue<List<Analytics>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
