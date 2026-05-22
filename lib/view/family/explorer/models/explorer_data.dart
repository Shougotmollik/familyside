import 'package:familyside/model/gift_item_model.dart';
import 'package:familyside/view/family/explorer/models/explorer_map_item.dart';
import 'package:familyside/view/family/home/family_home_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ExplorerData {
  ExplorerData._();

  static const LatLng mapCenter = LatLng(37.4419, -122.1430);

  static const List<String> categories = [
    'All',
    'Health',
    'Schools',
    'Events',
    'Outdoor',
  ];

  static const List<RecommendedItemModel> activityItems = [
    RecommendedItemModel(
      imagePath: 'assets/image/onboarding 1.jpg',
      category: 'Health',
      date: '25 Jun',
      title: 'Little Stars Pediatric Clinic',
      price: '20',
      distance: '0.05 km',
      ageRange: 'Age: 0-20 years',
      tag: 'Recommended',
    ),
    RecommendedItemModel(
      imagePath: 'assets/image/onboarding 2.jpg',
      category: 'Health',
      date: '25 Jun',
      title: 'Little Stars Pediatric Clinic',
      price: '20',
      distance: '0.05 km',
      ageRange: 'Age: 0-20 years',
      tag: 'Recommended',
    ),
    RecommendedItemModel(
      imagePath: 'assets/image/onboarding 3.jpg',
      category: 'Schools',
      date: '25 Jun',
      title: 'Sunrise Learning Center',
      price: '35',
      distance: '0.8 km',
      ageRange: 'Age: 4-12 years',
      tag: 'Recommended',
    ),
  ];

  static const List<RecommendedItemModel> eventItems = [
    RecommendedItemModel(
      imagePath: 'assets/image/onboarding 3.jpg',
      category: 'Events',
      date: '25 Jun',
      title: 'Little Stars Pediatric Clinic',
      price: '20',
      distance: '0.05 km',
      ageRange: 'Age: 0-20 years',
      tag: 'Recommended',
    ),
    RecommendedItemModel(
      imagePath: 'assets/image/onboarding 1.jpg',
      category: 'Events',
      date: '12 Jul',
      title: 'Summer Kids Festival',
      price: '15',
      distance: '1.2 km',
      ageRange: 'Age: 3-12 years',
      tag: 'Recommended',
    ),
    RecommendedItemModel(
      imagePath: 'assets/image/onboarding 2.jpg',
      category: 'Outdoor',
      date: '18 Aug',
      title: 'Green Meadows Park Day',
      price: '10',
      distance: '2.1 km',
      ageRange: 'Age: 5-15 years',
      tag: 'Recommended',
    ),
  ];

  static const List<GiftItemModel> giftItems = [
    GiftItemModel(
      imagePath: 'assets/image/onboarding 1.jpg',
      title: '1 Month Activity Pass',
      price: '45',
      description: 'Gift a month of fun activities at Green Meadows...',
      location: 'Green meadows ark',
    ),
    GiftItemModel(
      imagePath: 'assets/image/onboarding 2.jpg',
      title: '1 Month Activity Pass',
      price: '45',
      description: 'Gift a month of fun activities at Green Meadows...',
      location: 'Green meadows ark',
    ),
  ];

  static List<ExplorerMapItem> get mapItems => [
    ..._activityMapItems,
    ..._eventMapItems,
    ..._giftMapItems,
  ];

  static final List<ExplorerMapItem> _activityMapItems = [
    _mapItemFromRecommended(activityItems[0], 0, ExplorerItemType.activity),
    _mapItemFromRecommended(activityItems[1], 1, ExplorerItemType.activity),
    _mapItemFromRecommended(activityItems[2], 2, ExplorerItemType.activity),
  ];

  static final List<ExplorerMapItem> _eventMapItems = [
    _mapItemFromRecommended(eventItems[0], 3, ExplorerItemType.event),
    _mapItemFromRecommended(eventItems[1], 4, ExplorerItemType.event),
    _mapItemFromRecommended(eventItems[2], 5, ExplorerItemType.event),
  ];

  static final List<ExplorerMapItem> _giftMapItems = [
    _mapItemFromGift(giftItems[0], 6),
    _mapItemFromGift(giftItems[1], 7),
  ];

  static ExplorerMapItem _mapItemFromRecommended(
    RecommendedItemModel item,
    int index,
    ExplorerItemType type,
  ) {
    return ExplorerMapItem(
      id: '${type.name}_$index',
      type: type,
      imagePath: item.imagePath,
      category: item.category,
      title: item.title,
      price: item.price,
      distance: item.distance,
      ageRange: item.ageRange,
      tag: item.tag,
      date: item.date,
      position: _positionForIndex(index),
    );
  }

  static ExplorerMapItem _mapItemFromGift(GiftItemModel item, int index) {
    return ExplorerMapItem(
      id: 'gift_$index',
      type: ExplorerItemType.gift,
      imagePath: item.imagePath,
      category: 'Gifts',
      title: item.title,
      price: item.price,
      distance: item.location,
      ageRange: '',
      tag: 'Gift',
      description: item.description,
      position: _positionForIndex(index),
    );
  }

  static LatLng _positionForIndex(int index) {
    const offsets = [
      (0.004, -0.006),
      (-0.003, 0.005),
      (0.006, 0.003),
      (-0.005, -0.004),
      (0.002, 0.007),
      (-0.007, 0.002),
      (0.003, -0.002),
      (-0.002, 0.006),
    ];
    final offset = offsets[index % offsets.length];
    return LatLng(
      mapCenter.latitude + offset.$1,
      mapCenter.longitude + offset.$2,
    );
  }

  static List<ExplorerMapItem> filterByCategory(
    List<ExplorerMapItem> items,
    String category,
  ) {
    if (category == 'All') return items;
    return items.where((item) => item.category == category).toList();
  }

  static List<String> categoriesFromItems(List<ExplorerMapItem> items) {
    final categories = items.map((item) => item.category).toSet().toList()..sort();
    return ['All', ...categories];
  }

  static List<ExplorerMapItem> toMapItems(
    List<RecommendedItemModel> items, {
    ExplorerItemType type = ExplorerItemType.activity,
    int startIndex = 0,
  }) {
    return items.asMap().entries.map((entry) {
      return _mapItemFromRecommended(
        entry.value,
        startIndex + entry.key,
        type,
      );
    }).toList();
  }
}
