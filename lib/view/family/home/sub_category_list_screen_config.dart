import 'package:familyside/view/family/home/family_home_screen.dart';

class SubCategoryListScreenConfig {
  final String title;
  final List<RecommendedItemModel> items;

  const SubCategoryListScreenConfig({
    required this.title,
    this.items = defaultItems,
  });

  static const List<RecommendedItemModel> defaultItems = [
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
      category: 'Health',
      date: '25 Jun',
      title: 'Little Stars Pediatric Clinic',
      price: '20',
      distance: '0.05 km',
      ageRange: 'Age: 0-20 years',
      tag: 'Recommended',
    ),
  ];
}
