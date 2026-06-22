import 'package:familyside/model/gift_api_item.dart';

class GiftListFolder {
  final int id;
  final String name;
  final String occasion;
  final int itemsCount;
  final String? imageUrl;
  final String lastUpdatedLabel;

  const GiftListFolder({
    required this.id,
    required this.name,
    required this.occasion,
    required this.itemsCount,
    this.imageUrl,
    required this.lastUpdatedLabel,
  });

  factory GiftListFolder.fromJson(Map<String, dynamic> json) {
    return GiftListFolder(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      occasion: json['occasion'] as String? ?? 'General',
      itemsCount: json['items_count'] as int? ?? 0,
      imageUrl: json['image_url'] as String?,
      lastUpdatedLabel: json['last_updated_label'] as String? ?? '',
    );
  }
}

class GiftListsResponse {
  final List<GiftListFolder> folders;
  final int foldersCount;
  final int looseItemsCount;
  final List<dynamic> looseItems;

  const GiftListsResponse({
    this.folders = const [],
    this.foldersCount = 0,
    this.looseItemsCount = 0,
    this.looseItems = const [],
  });

  factory GiftListsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final List<dynamic> foldersList = data['folders'] as List<dynamic>? ?? [];
    return GiftListsResponse(
      folders: foldersList
          .map((e) => GiftListFolder.fromJson(e as Map<String, dynamic>))
          .toList(),
      foldersCount: data['folders_count'] as int? ?? 0,
      looseItemsCount: data['loose_items_count'] as int? ?? 0,
      looseItems: data['loose_items'] as List<dynamic>? ?? [],
    );
  }
}

class FolderDetailResponse {
  final String name;
  final List<GiftApiItem> items;

  const FolderDetailResponse({this.name = '', this.items = const []});

  factory FolderDetailResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final List<dynamic> itemsList = data['items'] as List<dynamic>? ?? [];
    return FolderDetailResponse(
      name: data['name'] as String? ?? '',
      items: itemsList
          .map((e) => GiftApiItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
