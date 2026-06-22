class NotificationItem {
  final int id;
  final String title;
  final String subtitle;
  final String timeAgo;
  final bool isRead;
  final String itemType;
  final int itemId;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.timeAgo,
    this.isRead = false,
    this.itemType = '',
    this.itemId = 0,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      timeAgo: json['time_ago'] as String? ?? '',
      isRead: json['is_read'] as bool? ?? false,
      itemType: json['item_type'] as String? ?? '',
      itemId: json['item_id'] as int? ?? 0,
    );
  }
}

class NotificationGroup {
  final String groupName;
  final List<NotificationItem> notifications;

  const NotificationGroup({
    required this.groupName,
    this.notifications = const [],
  });

  factory NotificationGroup.fromJson(Map<String, dynamic> json) {
    final List<dynamic> notifList = json['notifications'] as List<dynamic>? ?? [];
    return NotificationGroup(
      groupName: json['group_name'] as String? ?? '',
      notifications: notifList
          .map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class NotificationResponse {
  final int unreadCount;
  final List<NotificationGroup> groups;

  const NotificationResponse({
    this.unreadCount = 0,
    this.groups = const [],
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final List<dynamic> groupsList = data['groups'] as List<dynamic>? ?? [];
    return NotificationResponse(
      unreadCount: data['unread_count'] as int? ?? 0,
      groups: groupsList
          .map((e) => NotificationGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
