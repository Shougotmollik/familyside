import 'dart:convert';
import 'dart:io';

import 'package:familyside/core/constants/api_constant.dart';
import 'package:familyside/model/provider_feed_item.dart';
import 'package:familyside/model/sp_item_details.dart';
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

  // fetch single item details for editing
  Future<Map<String, dynamic>?> getItemDetails({required int id}) async {
    try {
      final response = await CustomHttp.get(
        endpoint: ApiConstants.getProviderMangeItems(id: id),
      );
      if (response.ok) {
        return response.data['data'] as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('Error fetching item details: $e');
    }
    return null;
  }

  // fetch item details for the detail view screen
  Future<SpItemDetails?> fetchItemDetails({required int itemId}) async {
    try {
      final response = await CustomHttp.get(
        endpoint: ApiConstants.itemDetails(itemId: itemId),
      );
      if (response.ok) {
        final data = response.data['data'] as Map<String, dynamic>?;
        if (data != null) {
          return SpItemDetails.fromJson(data);
        }
      }
    } catch (e) {
      debugPrint('Error fetching item details view: $e');
    }
    return null;
  }

  // update activity
  Future<bool> updateActivity({
    required int id,
    required String name,
    required String location,
    required int categoryId,
    required String price,
    required String websiteLink,
    required String whatsappNumber,
    required String emailAddress,
    required String instagramLink,
    required String openingDays,
    required String openingHours,
    required String description,
    required List<String> subCategories,
    required List<String> tags,
    File? image,
  }) async {
    try {
      final fields = {
        'name': name,
        'location': location,
        'category_id': categoryId.toString(),
        'price': price,
        'website': websiteLink,
        'whatsapp': whatsappNumber,
        'email': emailAddress,
        'instagram': instagramLink,
        'opening_days': openingDays,
        'opening_hours': openingHours,
        'description': description,
        'sub_category_ids': jsonEncode(subCategories),
        'tags': jsonEncode(tags),
      };

      final response = image != null
          ? await CustomHttp.multipart(
              endpoint: ApiConstants.updateActivity(id: id),
              fields: fields,
              filePath: image.path,
              fieldName: 'photo',
              method: 'PUT',
            )
          : await CustomHttp.post(
              endpoint: ApiConstants.updateActivity(id: id),
              body: fields,
            );

      if (response.ok) return true;
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  // update event
  Future<bool> updateEvent({
    required int id,
    required String name,
    required String date,
    required String location,
    required int categoryId,
    required int price,
    required String time,
    File? image,
    required List<String> tags,
    required String description,
  }) async {
    try {
      final fields = {
        'name': name,
        'date': date,
        'location': location,
        'category_id': categoryId.toString(),
        'price': price.toString(),
        'time': time,
        'tags': jsonEncode(tags),
        'description': description,
      };

      final response = image != null
          ? await CustomHttp.multipart(
              endpoint: ApiConstants.updateEvent(id: id),
              fields: fields,
              filePath: image.path,
              fieldName: 'photo',
              method: 'PUT',
            )
          : await CustomHttp.post(
              endpoint: ApiConstants.updateEvent(id: id),
              body: fields,
            );

      if (response.ok) return true;
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  // update gift
  Future<bool> updateGift({
    required int id,
    required String giftName,
    required int categoryId,
    required List<String> tags,
    required int price,
    required String description,
    File? image,
  }) async {
    try {
      final fields = {
        'name': giftName,
        'category_id': categoryId.toString(),
        'tags': jsonEncode(tags),
        'price': price.toString(),
        'description': description,
      };

      final response = image != null
          ? await CustomHttp.multipart(
              endpoint: ApiConstants.updateGift(id: id),
              fields: fields,
              filePath: image.path,
              fieldName: 'photo',
              method: 'PUT',
            )
          : await CustomHttp.post(
              endpoint: ApiConstants.updateGift(id: id),
              body: fields,
            );

      if (response.ok) return true;
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
