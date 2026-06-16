class FamilyHomeFeed {
  final List<FamilyHomeCategory> categories;
  final List<FamilyHomeItem> recommended;
  final List<FamilyHomeItem> eventsNearYou;

  FamilyHomeFeed({
    required this.categories,
    required this.recommended,
    required this.eventsNearYou,
  });

  factory FamilyHomeFeed.fromJson(Map<String, dynamic> json) {
    return FamilyHomeFeed(
      categories: (json['categories'] as List?)
              ?.map((e) => FamilyHomeCategory.fromJson(e))
              .toList() ??
          [],
      recommended: (json['recommended'] as List?)
              ?.map((e) => FamilyHomeItem.fromJson(e))
              .toList() ??
          [],
      eventsNearYou: (json['events_near_you'] as List?)
              ?.map((e) => FamilyHomeItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class FamilyHomeCategory {
  final int id;
  final String name;

  FamilyHomeCategory({required this.id, required this.name});

  factory FamilyHomeCategory.fromJson(Map<String, dynamic> json) {
    return FamilyHomeCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class FamilyHomeItem {
  final int id;
  final String itemType;
  final String name;
  final String? imageUrl;
  final String categoryName;
  final double price;
  final double? distanceKm;
  final String ageRange;
  final String dateLabel;
  final bool isRecommended;
  final bool isSaved;

  FamilyHomeItem({
    required this.id,
    required this.itemType,
    required this.name,
    this.imageUrl,
    required this.categoryName,
    required this.price,
    this.distanceKm,
    required this.ageRange,
    required this.dateLabel,
    required this.isRecommended,
    required this.isSaved,
  });

  factory FamilyHomeItem.fromJson(Map<String, dynamic> json) {
    return FamilyHomeItem(
      id: json['id'] ?? 0,
      itemType: json['item_type'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['image_url'],
      categoryName: json['category_name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
      ageRange: json['age_range'] ?? '',
      dateLabel: json['date_label'] ?? '',
      isRecommended: json['is_recommended'] ?? false,
      isSaved: json['is_saved'] ?? false,
    );
  }
}

class FamilySubCategory {
  final int id;
  final String name;
  final String? imageUrl;
  final String description;

  FamilySubCategory({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.description,
  });

  factory FamilySubCategory.fromJson(Map<String, dynamic> json) {
    return FamilySubCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      imageUrl: json['image_url'],
      description: json['description'] ?? '',
    );
  }
}
