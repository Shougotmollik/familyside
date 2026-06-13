import 'dart:convert';
import 'dart:io';

import 'package:familyside/core/constants/api_constant.dart';
import 'package:familyside/model/interest.dart';
import 'package:familyside/services/custom_http.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sp_create_provider.g.dart';

@riverpod
class SpCreateNotifier extends _$SpCreateNotifier {
  @override
  FutureOr<void> build() async {
    return;
  }

  //get categories
  Future<List<Interest>> getCategories() async {
    try {
      final response = await CustomHttp.get(
        endpoint: ApiConstants.getCatergoties,
      );
      if (response.ok) {
        final data = response.data['data'] as List;
        return data.map((e) => Interest.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  //get sub-categories
  Future<List<Interest>> getSubCategories({required String categoryId}) async {
    try {
      final response = await CustomHttp.get(
        endpoint: ApiConstants.subCategories(categoryId: int.parse(categoryId)),
      );
      if (response.ok) {
        final data = response.data['data'] as List;
        return data.map((e) => Interest.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  //create activity
  Future<bool> createActivity({
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
      state = const AsyncLoading();

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
              endpoint: ApiConstants.createActivity,
              fields: fields,
              filePath: image.path,
              fieldName: 'photo',
            )
          : await CustomHttp.post(endpoint: ApiConstants.createActivity, body: fields);

      if (response.ok) {
        if (ref.mounted) state = const AsyncValue<void>.data(null);
        return true;
      }
      if (ref.mounted) state = AsyncValue<void>.error(response.error ?? 'Failed', StackTrace.current);
      return false;
    } catch (e, st) {
      debugPrint(e.toString());
      if (ref.mounted) state = AsyncValue.error(e, st);
      return false;
    }
  }
}
