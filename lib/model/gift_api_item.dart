class GiftApiItem {
  final int id;
  final String itemType;
  final String name;
  final String? imageUrl;
  final String? categoryName;
  final double price;
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
      imageUrl: json['image_url'] as String?,
      categoryName: json['category_name'] as String?,
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

  const GiftApiCategory({
    required this.id,
    required this.name,
  });

  factory GiftApiCategory.fromJson(Map<String, dynamic> json) {
    return GiftApiCategory(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
    );
  }
}

class GiftApiResponse {
  final List<GiftApiItem> items;
  final List<GiftApiCategory> categories;

  const GiftApiResponse({
    this.items = const [],
    this.categories = const [],
  });

  factory GiftApiResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final itemsList = (data['items'] as List<dynamic>?)
            ?.map((e) => GiftApiItem.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    final categoriesList = (data['categories'] as List<dynamic>?)
            ?.map((e) => GiftApiCategory.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    return GiftApiResponse(
      items: itemsList,
      categories: categoriesList,
    );
  }
}
