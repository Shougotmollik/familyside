import 'package:familyside/core/constants/api_constant.dart';
import 'package:familyside/model/gift_api_item.dart';
import 'package:familyside/services/custom_http.dart';
import 'package:familyside/model/gift_filter_result_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gift_provider.g.dart';

@riverpod
class GiftProvider extends _$GiftProvider {
  @override
  FutureOr<GiftApiResponse> build() {
    return const GiftApiResponse();
  }

  Future<void> fetchGifts({
    String query = '',
    GiftFilterResultModel? filters,
    String? category,
  }) async {
    try {
      state = const AsyncLoading();

      final Map<String, dynamic> queries = {};
      if (query.isNotEmpty) queries['query'] = query;
      if (category != null && category != 'All') queries['category'] = category;
      if (filters != null) {
        if (filters.recipient != null) queries['recipient'] = filters.recipient!;
        if (filters.forWhom != null) queries['for_whom'] = filters.forWhom!;
        if (filters.childAge != null) queries['child_age'] = filters.childAge!;
        if (filters.price != null) queries['price_range'] = filters.price!;
      }

      final response = await CustomHttp.get(
        endpoint: ApiConstants.giftList,
        queries: queries.isNotEmpty ? queries : null,
      );

      if (response.ok) {
        state = AsyncData(GiftApiResponse.fromJson(response.data));
      } else {
        state = AsyncError(
          response.error ?? 'Failed to load gifts',
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}
