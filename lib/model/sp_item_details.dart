import 'package:familyside/core/config/credential.dart';

class SpItemDetails {
  final int id;
  final String itemType;
  final String name;
  final String location;
  final int categoryId;
  final double price;
  final String description;
  final String? website;
  final String? whatsapp;
  final String? email;
  final String? instagram;
  final String? openingDays;
  final String? openingHours;
  final String? date;
  final String? time;
  final List<String> subCategories;
  final List<String> tags;
  final String? imageUrl;
  final String status;

  const SpItemDetails({
    required this.id,
    this.itemType = '',
    this.name = '',
    this.location = '',
    this.categoryId = 0,
    this.price = 0.0,
    this.description = '',
    this.website,
    this.whatsapp,
    this.email,
    this.instagram,
    this.openingDays,
    this.openingHours,
    this.date,
    this.time,
    this.subCategories = const [],
    this.tags = const [],
    this.imageUrl,
    this.status = '',
  });

  factory SpItemDetails.fromJson(Map<String, dynamic> json) {
    return SpItemDetails(
      id: json['id'] as int? ?? 0,
      itemType: json['item_type'] as String? ?? '',
      name: json['name'] as String? ?? '',
      location: json['location'] as String? ?? '',
      categoryId: json['category_id'] as int? ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? '',
      website: json['website'] as String?,
      whatsapp: json['whatsapp'] as String?,
      email: json['email'] as String?,
      instagram: json['instagram'] as String?,
      openingDays: json['opening_days'] as String?,
      openingHours: json['opening_hours'] as String?,
      date: json['date'] as String?,
      time: json['time'] as String?,
      subCategories: (json['sub_categories'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      imageUrl: AppCredentials.fixurl(json['image_url'] as String?),
      status: json['status'] as String? ?? '',
    );
  }
}
