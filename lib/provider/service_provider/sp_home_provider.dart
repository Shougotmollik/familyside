import 'package:familyside/core/constants/api_constant.dart';
import 'package:familyside/model/provider_feed.dart';
import 'package:familyside/model/sp_home_header.dart';
import 'package:familyside/services/custom_http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sp_home_provider.g.dart';

@riverpod
class SpHomeProvider extends _$SpHomeProvider {
  @override
  FutureOr<Map<String, dynamic>> build() {
    return {
      'feed': ProviderFeed(upcomingEvents: [], topServices: []),
      'header': null,
    };
  }

  // fetch sp home feed
  Future<void> fetchSpHomeFeed() async {
    try {
      final currentData =
          state.value ??
          {
            'feed': ProviderFeed(upcomingEvents: [], topServices: []),
            'header': null,
          };
      state = const AsyncLoading();

      final feedResponse = await CustomHttp.get(
        endpoint: ApiConstants.providerHome,
      );
      final headerResponse = await CustomHttp.get(
        endpoint: ApiConstants.providerHeader,
      );

      if (feedResponse.ok && headerResponse.ok) {
        state = AsyncData({
          'feed': ProviderFeed.fromJson(feedResponse.data['data']),
          'header': SpHomeHeader.fromJson(headerResponse.data['data']),
        });
      } else {
        state = AsyncError(
          feedResponse.error ?? 'Something went wrong',
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}
