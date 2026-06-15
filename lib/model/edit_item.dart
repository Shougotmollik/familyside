class EditItem {
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
  final String imageUrl;
  final String status;

  EditItem({
    required this.id,
    required this.itemType,
    required this.name,
    required this.location,
    required this.categoryId,
    required this.price,
    required this.description,
    this.website,
    this.whatsapp,
    this.email,
    this.instagram,
    this.openingDays,
    this.openingHours,
    this.date,
    this.time,
    required this.subCategories,
    required this.tags,
    required this.imageUrl,
    required this.status,
  });

  factory EditItem.fromJson(Map<String, dynamic> json) {
    return EditItem(
      id: json['id'] ?? 0,
      itemType: json['item_type'] ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      categoryId: json['category_id'] ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] ?? '',
      website: json['website'],
      whatsapp: json['whatsapp'],
      email: json['email'],
      instagram: json['instagram'],
      openingDays: json['opening_days'],
      openingHours: json['opening_hours'],
      date: json['date'],
      time: json['time'],
      subCategories:
          (json['sub_categories'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          [],
      imageUrl: json['image_url'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
