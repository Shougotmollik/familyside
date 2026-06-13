import 'package:familyside/model/provider_feed_item.dart';

class ProviderFeed {
  final List<ProviderFeedItem> upcomingEvents;
  final List<ProviderFeedItem> topServices;

  ProviderFeed({required this.upcomingEvents, required this.topServices});

  factory ProviderFeed.fromJson(Map<String, dynamic> json) {
    return ProviderFeed(
      upcomingEvents: (json['upcoming_events'] as List)
          .map((e) => ProviderFeedItem.fromJson(e))
          .toList(),
      topServices: (json['top_services'] as List)
          .map((e) => ProviderFeedItem.fromJson(e))
          .toList(),
    );
  }
}
