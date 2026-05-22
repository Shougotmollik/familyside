import 'package:familyside/core/router/router_path.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/view/family/explorer/models/explorer_data.dart';
import 'package:familyside/view/family/explorer/models/explorer_map_screen_config.dart';
import 'package:familyside/view/family/gift/gift_all_screen.dart';
import 'package:familyside/view/family/home/family_home_screen.dart';
import 'package:familyside/view/family/home/recomandation_screen.dart';
import 'package:familyside/view/family/home/sub_category_list_screen_config.dart';
import 'package:familyside/model/search_data.dart';
import 'package:familyside/view/family/search/widgets/browse_category_section.dart';
import 'package:familyside/view/family/search/widgets/quick_access_row.dart';
import 'package:familyside/view/family/search/widgets/search_promo_banner.dart';
import 'package:familyside/view/family/search/widgets/search_toolbar.dart';
import 'package:familyside/view/widgets/home_filter_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  FilterResultModel? _currentFilters;

  static const List<RecommendedItemModel> _recommendedItems = [
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
  ];

  static const List<RecommendedItemModel> _eventItems = [
    RecommendedItemModel(
      imagePath: 'assets/image/onboarding 3.jpg',
      category: 'Events',
      date: '25 Jun',
      title: 'Summer Kids Festival',
      price: '15',
      distance: '0.12 km',
      ageRange: 'Age: 3-12 years',
      tag: 'Event',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openFilterBottomSheet() async {
    final result = await showModalBottomSheet<FilterResultModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          HomeFilterBottomSheet(initialFilters: _currentFilters),
    );

    if (result != null && mounted) {
      setState(() => _currentFilters = result);
    }
  }

  void _openMapScreen() {
    context.push(
      RouterPath.familyExplorerMapScreen,
      extra: ExplorerMapScreenConfig(
        items: ExplorerData.toMapItems([..._recommendedItems, ..._eventItems]),
      ),
    );
  }

  void _onQuickAccessTap(QuickAccessItem item) {
    switch (item.label) {
      case 'For you':
        context.push(
          RouterPath.familyRecommendationScreen,
          extra: ListScreenConfig(
            title: 'For You',
            items: _recommendedItems,
          ),
        );
      case 'Near you':
        _openMapScreen();
      case 'Gifts':
        context.push(
          RouterPath.familyGiftAllScreen,
          extra: GiftAllScreenConfig(
            title: 'All Gifts',
            items: ExplorerData.giftItems,
          ),
        );
      case 'Events':
        context.push(
          RouterPath.familyRecommendationScreen,
          extra: ListScreenConfig(
            title: 'Events',
            items: _eventItems,
          ),
        );
    }
  }

  void _onCategoryTap(BrowseCategoryItem item) {
    context.push(
      RouterPath.familySubCategoryListScreen,
      extra: SubCategoryListScreenConfig(title: item.title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SearchToolbar(
                controller: _searchController,
                hintText: SearchData.searchHint,
                onFilterTap: _openFilterBottomSheet,
                onLocationTap: _openMapScreen,
              ),
              SizedBox(height: 20.h),
              QuickAccessRow(
                items: SearchData.quickAccessItems,
                onItemTap: _onQuickAccessTap,
              ),
              SizedBox(height: 16.h),
              const SearchPromoBanner(message: SearchData.promoMessage),
              SizedBox(height: 24.h),
              BrowseCategorySection(
                categories: SearchData.browseCategories,
                onCategoryTap: _onCategoryTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
