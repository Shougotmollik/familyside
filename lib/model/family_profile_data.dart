class FamilyProfileData {
  final String fullName;
  final String locationName;
  final String profileImageUrl;
  final FamilyProfileMetrics metrics;

  FamilyProfileData({
    required this.fullName,
    required this.locationName,
    required this.profileImageUrl,
    required this.metrics,
  });

  factory FamilyProfileData.fromJson(Map<String, dynamic> json) {
    return FamilyProfileData(
      fullName: json['full_name'] as String? ?? '',
      locationName: json['location_name'] as String? ?? '',
      profileImageUrl: json['profile_image_url'] as String? ?? '',
      metrics: json['metrics'] != null
          ? FamilyProfileMetrics.fromJson(json['metrics'])
          : FamilyProfileMetrics.empty(),
    );
  }
}

class FamilyProfileMetrics {
  final int reviewsCount;
  final int activitiesCount;
  final int invitedFamilyCount;
  final int giftsSharedCount;
  final String contributorLevel;
  final String topPercentage;
  final double progressPct;

  FamilyProfileMetrics({
    required this.reviewsCount,
    required this.activitiesCount,
    required this.invitedFamilyCount,
    required this.giftsSharedCount,
    required this.contributorLevel,
    required this.topPercentage,
    required this.progressPct,
  });

  factory FamilyProfileMetrics.empty() {
    return FamilyProfileMetrics(
      reviewsCount: 0,
      activitiesCount: 0,
      invitedFamilyCount: 0,
      giftsSharedCount: 0,
      contributorLevel: '',
      topPercentage: '',
      progressPct: 0.0,
    );
  }

  factory FamilyProfileMetrics.fromJson(Map<String, dynamic> json) {
    return FamilyProfileMetrics(
      reviewsCount: json['reviews_count'] as int? ?? 0,
      activitiesCount: json['activities_count'] as int? ?? 0,
      invitedFamilyCount: json['invited_family_count'] as int? ?? 0,
      giftsSharedCount: json['gifts_shared_count'] as int? ?? 0,
      contributorLevel: json['contributor_level'] as String? ?? '',
      topPercentage: json['top_percentage'] as String? ?? '',
      progressPct: (json['progress_pct'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
