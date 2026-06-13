class SpHomeHeader {
  final String name;
  final String? profileImageUrl;
  final String location;
  final int unreadNotifications;

  SpHomeHeader({
    required this.name,
    required this.profileImageUrl,
    required this.location,
    required this.unreadNotifications,
  });

  factory SpHomeHeader.fromJson(Map<String, dynamic> json) {
    return SpHomeHeader(
      name: json['name'] ?? '',
      profileImageUrl: json['profile_image_url'],
      location: json['location'] ?? '',
      unreadNotifications: json['unread_notifications'] ?? 0,
    );
  }
}
