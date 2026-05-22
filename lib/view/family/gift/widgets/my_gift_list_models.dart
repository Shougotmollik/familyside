import 'package:flutter/material.dart';

class GiftListSummaryModel {
  final String id;
  final String title;
  final String emoji;
  final Color iconBackgroundColor;
  final int itemCount;
  final String lastUpdated;

  const GiftListSummaryModel({
    required this.id,
    required this.title,
    required this.emoji,
    required this.iconBackgroundColor,
    required this.itemCount,
    required this.lastUpdated,
  });
}

class SavedGiftItemModel {
  final String imagePath;
  final String title;
  final String category;
  final String price;

  const SavedGiftItemModel({
    required this.imagePath,
    required this.title,
    required this.category,
    required this.price,
  });
}

class GiftListDetailScreenConfig {
  final GiftListSummaryModel list;
  final String description;
  final List<SavedGiftItemModel> items;

  const GiftListDetailScreenConfig({
    required this.list,
    required this.description,
    required this.items,
  });
}

const Map<String, String> giftListDescriptions = {
  '1': 'Gift ideas that Emma will love for her special day!',
  '2': 'Holiday gifts picked for the whole family.',
  '3': 'Sweet surprises for the little one on the way.',
};

const Map<String, List<SavedGiftItemModel>> giftListItemsById = {
  '1': [
    SavedGiftItemModel(
      imagePath: 'assets/image/onboarding 1.jpg',
      title: 'Pediatric Osteopath Session',
      category: 'Activities',
      price: '45',
    ),
    SavedGiftItemModel(
      imagePath: 'assets/image/onboarding 2.jpg',
      title: 'Pediatric Osteopath Session',
      category: 'Toys and Games',
      price: '45',
    ),
    SavedGiftItemModel(
      imagePath: 'assets/image/onboarding 3.jpg',
      title: 'Pediatric Osteopath Session',
      category: 'Activities',
      price: '45',
    ),
    SavedGiftItemModel(
      imagePath: 'assets/image/onboarding 1.jpg',
      title: 'Pediatric Osteopath Session',
      category: 'Toys and Games',
      price: '45',
    ),
  ],
  '2': [
    SavedGiftItemModel(
      imagePath: 'assets/image/onboarding 2.jpg',
      title: 'Holiday Craft Kit',
      category: 'Activities',
      price: '35',
    ),
    SavedGiftItemModel(
      imagePath: 'assets/image/onboarding 3.jpg',
      title: 'Winter Story Book Set',
      category: 'Toys and Games',
      price: '28',
    ),
    SavedGiftItemModel(
      imagePath: 'assets/image/onboarding 1.jpg',
      title: 'Family Movie Night Pass',
      category: 'Activities',
      price: '50',
    ),
  ],
  '3': [
    SavedGiftItemModel(
      imagePath: 'assets/image/onboarding 3.jpg',
      title: 'Soft Plush Toy Set',
      category: 'Toys and Games',
      price: '32',
    ),
    SavedGiftItemModel(
      imagePath: 'assets/image/onboarding 1.jpg',
      title: 'Baby Care Essentials Box',
      category: 'Health',
      price: '55',
    ),
    SavedGiftItemModel(
      imagePath: 'assets/image/onboarding 2.jpg',
      title: 'Nursery Rhyme Book Bundle',
      category: 'Activities',
      price: '24',
    ),
  ],
};

GiftListDetailScreenConfig giftListDetailConfigFor(GiftListSummaryModel list) {
  return GiftListDetailScreenConfig(
    list: list,
    description: giftListDescriptions[list.id] ?? 'Gifts saved in this list.',
    items: List.from(
      giftListItemsById[list.id] ?? defaultSavedGiftsWithoutList,
    ),
  );
}

const List<GiftListSummaryModel> defaultGiftListSummaries = [
  GiftListSummaryModel(
    id: '1',
    title: "Emma's Birthday",
    emoji: '🎂',
    iconBackgroundColor: Color(0xFFFFE5E8),
    itemCount: 12,
    lastUpdated: '2 days',
  ),
  GiftListSummaryModel(
    id: '2',
    title: 'Christmas 2025',
    emoji: '🎄',
    iconBackgroundColor: Color(0xFFE8F5E9),
    itemCount: 12,
    lastUpdated: '2 days',
  ),
  GiftListSummaryModel(
    id: '3',
    title: 'Baby shower',
    emoji: '👶',
    iconBackgroundColor: Color(0xFFE3F2FD),
    itemCount: 12,
    lastUpdated: '2 days',
  ),
];

const List<SavedGiftItemModel> browseGiftsForPicker = [
  SavedGiftItemModel(
    imagePath: 'assets/image/onboarding 1.jpg',
    title: 'Pediatric Osteopath Session',
    category: 'Health',
    price: '45',
  ),
  SavedGiftItemModel(
    imagePath: 'assets/image/onboarding 2.jpg',
    title: '1 Month Activity Pass',
    category: 'Activities',
    price: '45',
  ),
  SavedGiftItemModel(
    imagePath: 'assets/image/onboarding 3.jpg',
    title: 'Winter Story Book Set',
    category: 'Toys and Games',
    price: '28',
  ),
];

const List<SavedGiftItemModel> defaultSavedGiftsWithoutList = [
  SavedGiftItemModel(
    imagePath: 'assets/image/onboarding 1.jpg',
    title: 'Pediatric Osteopath Session',
    category: 'Health',
    price: '45',
  ),
  SavedGiftItemModel(
    imagePath: 'assets/image/onboarding 2.jpg',
    title: 'Pediatric Osteopath Session',
    category: 'Health',
    price: '45',
  ),
];
