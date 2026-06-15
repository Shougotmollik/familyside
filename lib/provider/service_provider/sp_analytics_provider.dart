import 'package:familyside/core/constants/api_constant.dart';
import 'package:familyside/model/analytics.dart';
import 'package:familyside/services/custom_http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sp_analytics_provider.g.dart';

@riverpod
class SpAnalytics extends _$SpAnalytics {
  @override
  FutureOr<List<Analytics>> build() {
    return [];
  }

  Future<void> fetchAnalyticsData({
    required String year,
    required String category,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final response = await CustomHttp.get(
        endpoint: ApiConstants.analytics,
        queries: {'year': year, 'category': category},
      );
      if (response.ok) {
        final responseData = response.data;
        final analytics = Analytics.fromJson(responseData['data'] as Map<String, dynamic>);
        return [analytics];
      } else {
        return [];
      }
    });
  }
}
