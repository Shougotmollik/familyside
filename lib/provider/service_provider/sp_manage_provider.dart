import 'package:familyside/core/constants/api_constant.dart';
import 'package:familyside/model/provider_feed_item.dart';
import 'package:familyside/services/custom_http.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'sp_manage_provider.g.dart';

@riverpod
class SpManageProvider extends _$SpManageProvider {
  @override
  FutureOr<AsyncValue<void>> build() async {
    return const AsyncValue.data(null);
  }

  // fetch provider manage items
  Future<List<ProviderFeedItem>> getManageItems({required String type}) async {
    try {
      final response = await CustomHttp.get(
        endpoint: ApiConstants.providerManage,
        queries: {'item_type': type},
      );
      if (response.ok) {
        final items = response.data['data']['items'] as List;
        return items.map((e) => ProviderFeedItem.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching manage items: $e');
    }
    return [];
  }
}
