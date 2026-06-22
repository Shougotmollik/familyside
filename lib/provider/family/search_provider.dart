import 'package:familyside/core/constants/api_constant.dart';
import 'package:familyside/model/gift_api_item.dart';
import 'package:familyside/model/search_data.dart';
import 'package:familyside/services/custom_http.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_provider.g.dart';

@riverpod
class SearchProvider extends _$SearchProvider {
  @override
  FutureOr<Map<String, dynamic>> build() {
    return {
      'personalized_greeting': '',
      'categories': <BrowseCategoryItem>[],
    };
  }

  Future<void> fetchSearchData() async {
    try {
      state = const AsyncLoading();

      final response = await CustomHttp.get(
        endpoint: ApiConstants.familySearch,
      );

      if (response.ok && response.data != null) {
        final data = response.data['data'] as Map<String, dynamic>;
        final greeting =
            data['personalized_greeting'] as String? ?? '';

        final List<dynamic> categoriesJson =
            data['categories'] as List<dynamic>? ?? [];
        final categories = categoriesJson.map((json) {
          final category = json as Map<String, dynamic>;
          final name = category['name'] as String? ?? '';
          final imageUrl = category['image_url'] as String? ?? '';
          final colorCode = category['color_code'] as String? ?? '#F5F5F5';

          final catId = category['id'] as int? ?? 0;
          return BrowseCategoryItem(
            id: catId,
            title: name,
            imageUrl: imageUrl,
            backgroundColor: Color(
              int.parse(colorCode.replaceFirst('#', '0xFF')),
            ),
            iconColor: BrowseCategoryItem.iconColorForCategory(name),
          );
        }).toList();

        state = AsyncData({
          'personalized_greeting': greeting,
          'categories': categories,
        });
      } else {
        state = AsyncError(
          response.error ?? 'Failed to load search data',
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}

@riverpod
Future<List<GiftApiItem>> searchResults(Ref ref,
    {String? mode, int? categoryId, String? query}) async {
  final Map<String, dynamic> queries = {};
  if (mode != null) queries['mode'] = mode;
  if (categoryId != null) queries['category_id'] = categoryId.toString();
  if (query != null && query.isNotEmpty) queries['query'] = query;

  final response = await CustomHttp.get(
    endpoint: ApiConstants.familySearchRecomendation,
    queries: queries.isNotEmpty ? queries : null,
  );

  if (response.ok && response.data != null) {
    return GiftApiResponse.fromJson(
            response.data as Map<String, dynamic>)
        .items;
  }
  throw Exception(response.error ?? 'Failed to load results');
}

class SearchResultsConfig {
  final String? mode;
  final int? categoryId;
  final String? title;

  const SearchResultsConfig({this.mode, this.categoryId, this.title});

  String get displayTitle {
    if (title != null) return title!;
    if (mode != null) {
      switch (mode) {
        case 'for_you':
          return 'For You';
        case 'near_you':
          return 'Near You';
        case 'gifts':
          return 'Gifts';
        case 'events':
          return 'Events';
        default:
          return 'Search Results';
      }
    }
    if (categoryId != null) {
      return 'Category';
    }
    return 'Search Results';
  }
}
