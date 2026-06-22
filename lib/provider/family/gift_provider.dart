import 'dart:io' as io;

import 'package:familyside/core/constants/api_constant.dart';
import 'package:familyside/model/gift_api_item.dart';
import 'package:familyside/model/gift_list_response.dart';
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
        if (filters.recipient != null) {
          queries['recipient'] = filters.recipient!;
        }
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

  Future<Map<String, dynamic>?> createGiftList({
    required String name,
    required String occasion,
    io.File? photoFile,
  }) async {
    try {
      final response = await CustomHttp.multipart(
        endpoint: ApiConstants.createGiftList,
        fieldName: 'photo',
        filePath: photoFile?.path,
        fields: {'name': name, 'occasion': occasion},
        method: 'POST',
        need_auth: true,
      );

      if (response.ok && response.data != null) {
        final data = response.data is Map
            ? response.data as Map<String, dynamic>
            : null;
        final result = data?['data'] as Map<String, dynamic>? ?? data;
        return result;
      }
      return null;
    } catch (e) {
      // ignore: avoid_print
      print('Failed to create gift list: $e');
      return null;
    }
  }

  Future<FolderDetailResponse> fetchGiftListItems(int folderId) async {
    try {
      final response = await CustomHttp.get(
        endpoint: ApiConstants.giftListFolderDetails(id: folderId),
      );

      if (response.ok && response.data != null) {
        return FolderDetailResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      }
      return FolderDetailResponse(name: '');
    } catch (e) {
      // ignore: avoid_print
      print('Failed to fetch folder items: $e');
      return FolderDetailResponse(name: '');
    }
  }

  Future<bool> deleteGiftListItem({
    required int folderId,
    required int itemId,
  }) async {
    try {
      final response = await CustomHttp.delete(
        endpoint: ApiConstants.giftListItemDelete(
          folderId: folderId,
          itemId: itemId,
        ),
      );
      return response.ok;
    } catch (e) {
      // ignore: avoid_print
      print('Failed to delete gift list item: $e');
      return false;
    }
  }

  Future<bool> addItemToFolder({
    required int folderId,
    required int itemId,
  }) async {
    try {
      final response = await CustomHttp.post(
        endpoint: ApiConstants.giftListAddItem,
        body: {
          'item_id': itemId,
          'gift_list_id': folderId,
        },
      );
      return response.ok;
    } catch (e) {
      // ignore: avoid_print
      print('Failed to add item to folder: $e');
      return false;
    }
  }

  Future<List<GiftApiItem>> fetchAvailableItems(int folderId) async {
    try {
      final response = await CustomHttp.get(
        endpoint: ApiConstants.giftListAvailableItems(folderId: folderId),
      );

      if (response.ok && response.data != null) {
        final body = response.data is Map
            ? response.data as Map<String, dynamic>
            : null;
        final rawData = body?['data'];
        final List<dynamic> itemsList;
        if (rawData is List) {
          itemsList = rawData;
        } else if (rawData is Map) {
          itemsList = (rawData['items'] as List<dynamic>?) ?? [];
        } else {
          itemsList = (body?['items'] as List<dynamic>?) ?? [];
        }
        return itemsList
            .map((e) => GiftApiItem.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      // ignore: avoid_print
      print('Failed to fetch available items: $e');
      return [];
    }
  }

  Future<GiftListsResponse> fetchGiftLists() async {
    try {
      final response = await CustomHttp.get(
        endpoint: ApiConstants.giftPlannerFolders,
      );

      if (response.ok && response.data != null) {
        return GiftListsResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      }
      return const GiftListsResponse();
    } catch (e) {
      // ignore: avoid_print
      print('Failed to fetch gift lists: $e');
      return const GiftListsResponse();
    }
  }
}
