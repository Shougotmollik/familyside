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
  });
}
