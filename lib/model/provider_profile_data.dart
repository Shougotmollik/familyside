class ProviderProfileData {
  final String? name;
  final String? location;
  final String? imageUrl;
  final ProfileStats? stats;

  ProviderProfileData({this.name, this.location, this.imageUrl, this.stats});

  factory ProviderProfileData.fromJson(Map<String, dynamic> json) {
    return ProviderProfileData(
      name: json['name'],
      location: json['location'],
      imageUrl: json['image_url'],
      stats: json['stats'] != null
          ? ProfileStats.fromJson(json['stats'])
          : null,
    );
  }
}

class ProfileStats {
  final int? reviewsCount;
  final int? activitiesCount;
  final int? invitedFamilyCount;
  final int? giftsSharedCount;
  final String? contributorLevel;
  final num? progressPercentage;

  ProfileStats({
    this.reviewsCount,
    this.activitiesCount,
    this.invitedFamilyCount,
    this.giftsSharedCount,
    this.contributorLevel,
    this.progressPercentage,
  });

  factory ProfileStats.fromJson(Map<String, dynamic> json) {
    return ProfileStats(
      reviewsCount: json['reviews_count'],
      activitiesCount: json['activities_count'],
      invitedFamilyCount: json['invited_family_count'],
      giftsSharedCount: json['gifts_shared_count'],
      contributorLevel: json['contributor_level'],
      progressPercentage: json['progress_percentage'] as num?,
    );
  }
}
