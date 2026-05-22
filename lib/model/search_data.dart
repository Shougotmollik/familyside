import 'package:flutter/material.dart';

class QuickAccessItem {
  final String label;
  final String iconAssetPath;
  final Color? iconColor;

  const QuickAccessItem({
    required this.label,
    required this.iconAssetPath,
    this.iconColor,
  });
}

class BrowseCategoryItem {
  final String title;
  final String imageUrl;
  final Color backgroundColor;
  final Color iconColor;

  const BrowseCategoryItem({
    required this.title,
    required this.imageUrl,
    required this.backgroundColor,
    required this.iconColor,
  });

  factory BrowseCategoryItem.fromJson(Map<String, dynamic> json) {
    final title = json['title'] as String;
    return BrowseCategoryItem(
      title: title,
      imageUrl: json['image_url'] as String? ?? '',
      backgroundColor: json['background_color'] != null
          ? Color(int.parse((json['background_color'] as String).replaceFirst('#', '0xFF')))
          : _colorForCategory(title),
      iconColor: json['icon_color'] != null
          ? Color(int.parse((json['icon_color'] as String).replaceFirst('#', '0xFF')))
          : _iconColorForCategory(title),
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'image_url': imageUrl,
        'background_color': '#${backgroundColor.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
        'icon_color': '#${iconColor.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
      };

  static Color _colorForCategory(String title) {
    switch (title) {
      case 'Health':
        return const Color(0xFFE8F5E9);
      case 'Schools':
        return const Color(0xFFE3F2FD);
      case 'Events':
        return const Color(0xFFFCE4EC);
      case 'Outdoor':
        return const Color(0xFFE8F5E9);
      case 'Sports':
        return const Color(0xFFFFF3E0);
      case 'Products':
        return const Color(0xFFFFFDE7);
      default:
        return const Color(0xFFF5F5F5);
    }
  }

  static Color _iconColorForCategory(String title) {
    switch (title) {
      case 'Health':
        return const Color(0xFF66BB6A);
      case 'Schools':
        return const Color(0xFF42A5F5);
      case 'Events':
        return const Color(0xFFEC407A);
      case 'Outdoor':
        return const Color(0xFF81C784);
      case 'Sports':
        return const Color(0xFFFF9800);
      case 'Products':
        return const Color(0xFFFFCA28);
      default:
        return const Color(0xFF9E9E9E);
    }
  }
}

class SearchData {
  SearchData._();

  static const String searchHint = 'Search activity & events....';
  static const String promoMessage = 'For you, Mum';

  static const List<QuickAccessItem> quickAccessItems = [
    QuickAccessItem(
      label: 'For you',
      iconAssetPath: 'assets/icon/noto_star.png',
    ),
    QuickAccessItem(
      label: 'Near you',
      iconAssetPath: 'assets/icon/fluent_location.png',
    ),
    QuickAccessItem(
      label: 'Gifts',
      iconAssetPath: 'assets/icon/wrapped-gift.png',
    ),
    QuickAccessItem(
      label: 'Events',
      iconAssetPath: 'assets/icon/party-popper.png',
    ),
  ];

  static List<BrowseCategoryItem> get browseCategories => _defaultCategories;

  static List<BrowseCategoryItem> _defaultCategories = _buildDefaultCategories();

  static List<BrowseCategoryItem> _buildDefaultCategories() {
    final data = [
      (title: 'Health',   img: 'https://cdn.jsdelivr.net/npm/undraw-js@1.0.6/illus/Doctors.svg',     bg: 0xFFF8FAFF, fg: 0xFF6C63FF),
      (title: 'Schools',  img: 'https://cdn.jsdelivr.net/npm/undraw-js@1.0.6/illus/Education.svg',  bg: 0xFFFAF8FF, fg: 0xFF7C6CFF),
      (title: 'Events',   img: 'https://cdn.jsdelivr.net/npm/undraw-js@1.0.6/illus/Celebration.svg', bg: 0xFFFFF8FA, fg: 0xFFFF6B9D),
      (title: 'Outdoor',  img: 'https://cdn.jsdelivr.net/npm/undraw-js@1.0.6/illus/Adventure.svg',   bg: 0xFFF8FFF8, fg: 0xFF6BCB77),
      (title: 'Sports',   img: 'https://cdn.jsdelivr.net/npm/undraw-js@1.0.6/illus/Basketball.svg',  bg: 0xFFFFF9F3, fg: 0xFFFF8C42),
      (title: 'Products', img: 'https://cdn.jsdelivr.net/npm/undraw-js@1.0.6/illus/Shopping.svg',    bg: 0xFFFFFCF5, fg: 0xFFFFB84D),
    ];
    return List.generate(data.length, (i) {
      final d = data[i];
      return BrowseCategoryItem(
        title: d.title,
        imageUrl: d.img,
        backgroundColor: Color(d.bg),
        iconColor: Color(d.fg),
      );
    });
  }

  static void updateCategoriesFromJson(List<Map<String, dynamic>> jsonList) {
    _defaultCategories = jsonList.map((j) => BrowseCategoryItem.fromJson(j)).toList();
  }
}
