import 'package:familyside/core/constants/api_constant.dart';
import 'package:familyside/model/family_home_feed.dart';
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
  Future<void> fetchHomeData() async {
    try {
      state = const AsyncLoading();

      final headerResponse = await CustomHttp.get(
        endpoint: ApiConstants.familyHeader,
      );

      final feedResponse = await CustomHttp.get(
        endpoint: ApiConstants.familyHome,
      );

      if (headerResponse.ok && feedResponse.ok) {
        state = AsyncData({
          'header': SpHomeHeader.fromJson(headerResponse.data['data']),
          'feed': FamilyHomeFeed.fromJson(feedResponse.data['data']),
          'subCategories': <FamilySubCategory>[],
        });
      } else {
        state = AsyncError(
          headerResponse.error ?? feedResponse.error ?? 'Something went wrong',
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
