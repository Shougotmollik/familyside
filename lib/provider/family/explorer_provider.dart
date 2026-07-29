import 'package:familyside/core/constants/api_constant.dart';
import 'package:familyside/model/activity_details.dart';
import 'package:familyside/model/gift_api_item.dart';
import 'package:familyside/services/custom_http.dart';
import 'package:familyside/model/filter_result_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'explorer_provider.g.dart';

@riverpod
class ExplorerProvider extends _$ExplorerProvider {
  @override
  FutureOr<List<GiftApiItem>> build() {
    return [];
  }

  Future<void> fetchExplorerItems({
    String? itemType,
    String query = '',
    FilterResultModel? filters,
  }) async {
    try {
      state = const AsyncLoading();

      final Map<String, dynamic> queries = {};
      if (query.isNotEmpty) queries['query'] = query;
      if (itemType != null && itemType.isNotEmpty) {
        queries['item_type'] = itemType;
      }
      if (filters != null) {
        if (filters.location.isNotEmpty) {
          queries['location'] = filters.location;
        }
        if (filters.categories.isNotEmpty) {
          queries['category'] = filters.categories.join(',');
        }
        if (filters.ages.isNotEmpty) {
          queries['age_range'] = filters.ages.join(',');
        }
        if (filters.price != 'All') {
          queries['price'] = filters.price.toLowerCase();
        }
      }

      final response = await CustomHttp.get(
        endpoint: ApiConstants.explorer,
        queries: queries.isNotEmpty ? queries : null,
      );

      if (response.ok) {
        final items = GiftApiResponse.fromJson(response.data).items;
        state = AsyncData(items);
      } else {
        state = AsyncError(
          response.error ?? 'Failed to load items',
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}

@riverpod
class ExplorerMapProvider extends _$ExplorerMapProvider {
  @override
  FutureOr<MapExplorerResponse> build() {
    return const MapExplorerResponse();
  }

  Future<void> fetchMapData({FilterResultModel? filters}) async {
    try {
      state = const AsyncLoading();

      final Map<String, dynamic> queries = {};
      if (filters != null) {
        if (filters.location.isNotEmpty) {
          queries['location'] = filters.location;
        }
        if (filters.categories.isNotEmpty) {
          queries['category'] = filters.categories.join(',');
        }
        if (filters.ages.isNotEmpty) {
          queries['age_range'] = filters.ages.join(',');
        }
        if (filters.price != 'All') {
          queries['price'] = filters.price.toLowerCase();
        }
      }

      final response = await CustomHttp.get(
        endpoint: ApiConstants.mapExplorer,
        queries: queries.isNotEmpty ? queries : null,
      );

      if (response.ok) {
        state = AsyncData(MapExplorerResponse.fromJson(response.data));
      } else {
        state = AsyncError(
          response.error ?? 'Failed to load map data',
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}

@riverpod
class ActivityDetailsProvider extends _$ActivityDetailsProvider {
  @override
  FutureOr<ActivityDetails> build() {
    return const ActivityDetails();
  }

  Future<void> fetchDetails(int itemId) async {
    try {
      state = const AsyncLoading();

      final response = await CustomHttp.get(
        endpoint: ApiConstants.activityDetails(id: itemId),
      );

      if (response.ok) {
        state = AsyncData(ActivityDetails.fromJson(response.data));
      } else {
        state = AsyncError(
          response.error ?? 'Failed to load details',
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<CustomHttpResult> submitReview({
    required int itemId,
    String? categoryName,
    required String recommendationLevel,
    required String comment,
    String? tags,
    String? photoPath,
  }) async {
    final fields = <String, String>{
      'recommendation_level': recommendationLevel,
      'comment': comment,
    };
    if (categoryName != null && categoryName.isNotEmpty) {
      fields['category_name'] = categoryName;
    }
    if (tags != null && tags.isNotEmpty) {
      fields['tags'] = tags;
    }

    return CustomHttp.multipart(
      endpoint: ApiConstants.familyReviewsLeave(itemId: itemId),
      fieldName: 'photo',
      filePath: photoPath,
      fields: fields,
      method: 'POST',
    );
  }
}

