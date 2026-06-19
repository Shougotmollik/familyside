// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GiftProvider)
final giftProviderProvider = GiftProviderProvider._();

final class GiftProviderProvider
    extends $AsyncNotifierProvider<GiftProvider, GiftApiResponse> {
  GiftProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'giftProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$giftProviderHash();

  @$internal
  @override
  GiftProvider create() => GiftProvider();
}

String _$giftProviderHash() => r'cb6a0f4ce88bfdc389233f0200369c7da0b44bda';

abstract class _$GiftProvider extends $AsyncNotifier<GiftApiResponse> {
  FutureOr<GiftApiResponse> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<GiftApiResponse>, GiftApiResponse>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<GiftApiResponse>, GiftApiResponse>,
              AsyncValue<GiftApiResponse>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
