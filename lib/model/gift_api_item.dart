import 'package:familyside/core/config/credential.dart';

class GiftApiItem {
  final int id;
  final String itemType;
  final String name;
  final String? imageUrl;
  final String? categoryName;
  final double price;
  final double? lat;
  final double? lng;
  final String? location;
  final double? distanceKm;
  final String? ageRange;
  final String? dateLabel;
  final bool isRecommended;
  final bool isSaved;

  const GiftApiItem({
    required this.id,
    required this.itemType,
    required this.name,
    this.imageUrl,
    this.categoryName,
    required this.price,
    this.lat,
    this.lng,
    this.location,
    this.distanceKm,
    this.ageRange,
    this.dateLabel,
    this.isRecommended = false,
    this.isSaved = false,
  });

  factory GiftApiItem.fromJson(Map<String, dynamic> json) {
    return GiftApiItem(
      id: json['id'] as int,
      itemType: json['item_type'] as String? ?? 'gift',
      name: json['name'] as String? ?? '',
      imageUrl: AppCredentials.fixurl(json['image_url'] as String?),
      categoryName: json['category_name'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      location: json['location'] as String?,
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
      ageRange: json['age_range'] as String?,
      dateLabel: json['date_label'] as String?,
      isRecommended: json['is_recommended'] as bool? ?? false,
      isSaved: json['is_saved'] as bool? ?? false,
    );
  }
}

class GiftApiCategory {
  final int id;
  final String name;

  const GiftApiCategory({required this.id, required this.name});

  factory GiftApiCategory.fromJson(Map<String, dynamic> json) {
    return GiftApiCategory(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
    );
  }
}

class MapExplorerPin {
  final int id;
  final String itemType;
  final double lat;
  final double lng;
  final String categoryIcon;

  const MapExplorerPin({
    required this.id,
    required this.itemType,
    required this.lat,
    required this.lng,
    required this.categoryIcon,
  });

  factory MapExplorerPin.fromJson(Map<String, dynamic> json) {
    return MapExplorerPin(
      id: json['id'] as int,
      itemType: json['item_type'] as String? ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
      categoryIcon: json['category_icon'] as String? ?? '',
    );
  }
}

class MapExplorerResponse {
  final List<GiftApiItem> items;
  final List<GiftApiCategory> categories;
  final List<MapExplorerPin> pins;

  const MapExplorerResponse({
    this.items = const [],
    this.categories = const [],
    this.pins = const [],
  });

  factory MapExplorerResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final itemsList =
        (data['items'] as List<dynamic>?)
            ?.map((e) => GiftApiItem.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    final categoriesList =
        (data['categories'] as List<dynamic>?)
            ?.map((e) => GiftApiCategory.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    final pinsList =
        (data['pins'] as List<dynamic>?)
            ?.map((e) => MapExplorerPin.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    return MapExplorerResponse(
      items: itemsList,
      categories: categoriesList,
      pins: pinsList,
    );
  }
}

class GiftApiResponse {
  final List<GiftApiItem> items;
  final List<GiftApiCategory> categories;

  const GiftApiResponse({this.items = const [], this.categories = const []});

  factory GiftApiResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final itemsList =
        (data['items'] as List<dynamic>?)
            ?.map((e) => GiftApiItem.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    final categoriesList =
        (data['categories'] as List<dynamic>?)
            ?.map((e) => GiftApiCategory.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    return GiftApiResponse(items: itemsList, categories: categoriesList);
  }
}
