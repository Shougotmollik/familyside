import 'package:familyside/core/config/credential.dart';
import 'package:familyside/model/gift_api_item.dart';

class ActivityDetailsReview {
  final String userName;
  final String? userImage;
  final String recommendationLevel;
  final String comment;
  final String date;

  const ActivityDetailsReview({
    required this.userName,
    this.userImage,
    required this.recommendationLevel,
    required this.comment,
    required this.date,
  });

  factory ActivityDetailsReview.fromJson(Map<String, dynamic> json) {
    return ActivityDetailsReview(
      userName: json['user_name'] as String? ?? '',
      userImage: AppCredentials.fixurl(json['user_image'] as String?),
      recommendationLevel: json['recommendation_level'] as String? ?? '',
      comment: json['comment'] as String? ?? '',
      date: json['date'] as String? ?? '',
    );
  }
}

class ActivityDetails {
  final int id;
  final String name;
  final String description;
  final String? imageUrl;
  final String categoryName;
  final double lat;
  final double lng;
  final String address;
  final String openingHours;
  final String? website;
  final String? instagram;
  final String? whatsapp;
  final List<GiftApiItem> relatedEvents;
  final List<GiftApiItem> giftIdeas;
  final List<ActivityDetailsReview> reviews;
  final String averageRatingLabel;

  const ActivityDetails({
    this.id = 0,
    this.name = '',
    this.description = '',
    this.imageUrl,
    this.categoryName = '',
    this.lat = 0.0,
    this.lng = 0.0,
    this.address = '',
    this.openingHours = '',
    this.website,
    this.instagram,
    this.whatsapp,
    this.relatedEvents = const [],
    this.giftIdeas = const [],
    this.reviews = const [],
    this.averageRatingLabel = '',
  });

  factory ActivityDetails.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return ActivityDetails(
      id: data['id'] as int? ?? 0,
      name: data['name'] as String? ?? '',
      description: data['description'] as String? ?? '',
      imageUrl: AppCredentials.fixurl(data['image_url'] as String?),
      categoryName: data['category_name'] as String? ?? '',
      lat: (data['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (data['lng'] as num?)?.toDouble() ?? 0.0,
      address: data['address'] as String? ?? '',
      openingHours: data['opening_hours'] as String? ?? '',
      website: data['website'] as String?,
      instagram: data['instagram'] as String?,
      whatsapp: data['whatsapp'] as String?,
      relatedEvents: (data['related_events'] as List<dynamic>?)
              ?.map((e) => GiftApiItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      giftIdeas: (data['gift_ideas'] as List<dynamic>?)
              ?.map((e) => GiftApiItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      reviews: (data['reviews'] as List<dynamic>?)
              ?.map(
                  (e) => ActivityDetailsReview.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      averageRatingLabel: data['average_rating_label'] as String? ?? '',
    );
  }
}
