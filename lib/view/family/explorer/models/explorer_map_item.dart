import 'package:familyside/model/gift_api_item.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum ExplorerItemType { activity, event, gift }

class ExplorerMapItem {
  final String id;
  final ExplorerItemType type;
  final String imagePath;
  final String category;
  final String title;
  final String price;
  final String distance;
  final String ageRange;
  final String tag;
  final LatLng position;
  final String? date;
  final String? description;
  final bool isSaved;

  const ExplorerMapItem({
    required this.id,
    required this.type,
    required this.imagePath,
    required this.category,
    required this.title,
    required this.price,
    required this.distance,
    required this.ageRange,
    required this.tag,
    required this.position,
    this.date,
    this.description,
    this.isSaved = false,
  });

  factory ExplorerMapItem.fromGiftApiItem(GiftApiItem item) {
    return ExplorerMapItem(
      id: item.id.toString(),
      type: _parseItemType(item.itemType),
      imagePath: item.imageUrl ?? '',
      category: item.categoryName ?? '',
      title: item.name,
      price: item.price.toStringAsFixed(0),
      distance: item.distanceKm != null
          ? '${item.distanceKm!.toStringAsFixed(2)} km'
          : (item.location ?? 'N/A'),
      ageRange: item.ageRange ?? '',
      tag: item.isRecommended ? 'Recommended' : item.itemType,
      position: LatLng(item.lat ?? 0.0, item.lng ?? 0.0),
      date: item.dateLabel,
      description: item.location,
      isSaved: item.isSaved,
    );
  }

  static ExplorerItemType _parseItemType(String type) {
    switch (type.toLowerCase()) {
      case 'activity':
        return ExplorerItemType.activity;
      case 'event':
        return ExplorerItemType.event;
      case 'gift':
        return ExplorerItemType.gift;
      default:
        return ExplorerItemType.activity;
    }
  }
}
