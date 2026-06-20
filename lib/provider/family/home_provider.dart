import 'package:familyside/core/constants/api_constant.dart';
import 'package:familyside/model/family_home_feed.dart';
import 'package:familyside/model/filter_result_model.dart';
import 'package:familyside/model/gift_api_item.dart';
import 'package:familyside/model/sp_home_header.dart';
import 'package:familyside/services/custom_http.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_provider.g.dart';

@riverpod
class HomeProvider extends _$HomeProvider {
  @override
  FutureOr<Map<String, dynamic>> build() {
    return {
      'header': null,
      'feed': null,
      'subCategories': <FamilySubCategory>[],
    };
  }

  // fetch home header and feed
  Future<void> fetchHomeData({String query = '', FilterResultModel? filters}) async {
    try {
      final currentData = state.value;
      state = const AsyncLoading();

      // Only fetch header if we don't have it yet
      SpHomeHeader? header = currentData?['header'];
      if (header == null) {
        final headerResponse = await CustomHttp.get(
          endpoint: ApiConstants.familyHeader,
        );
        if (headerResponse.ok) {
          header = SpHomeHeader.fromJson(headerResponse.data['data']);
        }
      }

      final Map<String, dynamic> queries = {};
      if (query.isNotEmpty) queries['search'] = query;
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

      final feedResponse = await CustomHttp.get(
        endpoint: ApiConstants.familyHome,
        queries: queries.isNotEmpty ? queries : null,
      );

      if (feedResponse.ok) {
        state = AsyncData({
          'header': header,
          'feed': FamilyHomeFeed.fromJson(feedResponse.data['data']),
          'subCategories': <FamilySubCategory>[],
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

  // fetch sub-categories
  Future<void> fetchSubCategories(int categoryId) async {
    try {
      final currentData = state.value;
      if (currentData == null) return;

      final response = await CustomHttp.get(
        endpoint: ApiConstants.familySubCategories(categoryId: categoryId),
      );

      if (response.ok) {
        final List<dynamic> data = response.data['data'];
        final subCategories = data
            .map((e) => FamilySubCategory.fromJson(e))
            .toList();

        state = AsyncData({...currentData, 'subCategories': subCategories});
      }
    } catch (e) {
      debugPrint('Error fetching sub-categories: $e');
    }
  }
}

@riverpod
class SavedItemsProvider extends _$SavedItemsProvider {
  @override
  FutureOr<Map<String, List<GiftApiItem>>> build() {
    return {
      'activity': <GiftApiItem>[],
      'event': <GiftApiItem>[],
      'gift': <GiftApiItem>[],
    };
  }

  Future<void> fetchSavedItems({required String itemType}) async {
    try {
      state = const AsyncLoading();

      final response = await CustomHttp.get(
        endpoint: ApiConstants.familySavedItems,
        queries: {'item_type': itemType},
      );

      if (response.ok) {
        final items = GiftApiResponse.fromJson(response.data).items;
        final currentData = Map<String, List<GiftApiItem>>.from(state.value ?? {});
        currentData[itemType] = items;
        state = AsyncData(currentData);
      } else {
        state = AsyncError(
          response.error ?? 'Failed to load saved items',
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}
