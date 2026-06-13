class ProviderFeedItem {
  final int id;
  final String name;
  final String? imageUrl;
  final String categoryLabel;
  final String itemType;
  final double price;
  final double distanceKm;
  final String ageRange;
  final String dateLabel;

  ProviderFeedItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.categoryLabel,
    required this.itemType,
    required this.price,
    required this.distanceKm,
    required this.ageRange,
    required this.dateLabel,
  });

  factory ProviderFeedItem.fromJson(Map<String, dynamic> json) {
    return ProviderFeedItem(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
      categoryLabel: json['category_label'],
      itemType: json['item_type'],
      price: (json['price'] as num).toDouble(),
      distanceKm: (json['distance_km'] as num).toDouble(),
      ageRange: json['age_range'],
      dateLabel: json['date_label'],
    );
  }
}
