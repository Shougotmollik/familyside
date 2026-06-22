import 'package:flutter/material.dart';

class GiftListSummaryModel {
  final String id;
  final String title;
  final String emoji;
  final Color iconBackgroundColor;
  final int itemCount;
  final String lastUpdated;
  final String? imagePath;

  const GiftListSummaryModel({
    required this.id,
    required this.title,
    required this.emoji,
    required this.iconBackgroundColor,
    required this.itemCount,
    required this.lastUpdated,
    this.imagePath,
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
