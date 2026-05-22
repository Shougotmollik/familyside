import 'package:familyside/view/widgets/custom_icon_button.dart';
import 'package:familyside/view/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/view/widgets/custom_app_bar.dart';
import 'package:familyside/view/widgets/item_card.dart';
import 'package:familyside/view/family/home/family_home_screen.dart';
import 'package:familyside/view/widgets/category_filter_bottom_sheet.dart';

class SubCategoryListScreen extends StatefulWidget {
  final String title;

  const SubCategoryListScreen({super.key, required this.title});

  @override
  State<SubCategoryListScreen> createState() => _SubCategoryListScreenState();
}

class _SubCategoryListScreenState extends State<SubCategoryListScreen> {
  final TextEditingController searchController = TextEditingController();
  CategoryFilterResultModel? _currentFilters;

  void _openFilterBottomSheet() async {
    final result = await showModalBottomSheet<CategoryFilterResultModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CategoryFilterBottomSheet(
        initialFilters: _currentFilters,
      ),
    );

    if (result != null) {
      setState(() {
        _currentFilters = result;
      });
      debugPrint('Selected Filters: $result');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              CustomAppBar(title: widget.title),
              SizedBox(height: 24.h),
              _buildSearchSection(),
              SizedBox(height: 24.h),
              Expanded(
                child: ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return EventCard(
                      imagePath: item.imagePath,
                      category: item.category,
                      date: item.date,
                      title: item.title,
                      price: item.price,
                      distance: item.distance,
                      ageRange: item.ageRange,
                      tag: item.tag,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Row(
      children: [
        Expanded(
          child: SearchBarWidget(
            controller: searchController,
            hintText: "Search...",
          ),
        ),
        SizedBox(width: 12.w),
        CustomIconButton(
          assetPath: "assets/logo/filter.svg",
          containerHeight: 48.h,
          containerWidth: 48.w,
          borderRadius: 8.r,
          iconWidth: 24.w,
          iconHeight: 24.h,
          onTap: _openFilterBottomSheet,
        ),
        SizedBox(width: 12.w),
        CustomIconButton(
          assetPath: "assets/logo/location.svg",
          containerHeight: 48.h,
          containerWidth: 48.w,
          borderRadius: 8.r,
          iconWidth: 24.w,
          iconHeight: 24.h,
        ),
      ],
    );
  }
}

final List<RecommendedItemModel> _items = const [
  RecommendedItemModel(
    imagePath: "assets/image/onboarding 1.jpg",
    category: "Health",
    date: "25 Jun",
    title: "Little Stars Pediatric Clinic",
    price: "20",
    distance: "0.05 km",
    ageRange: "Age: 0-20 years",
    tag: "Recommended",
  ),
  RecommendedItemModel(
    imagePath: "assets/image/onboarding 2.jpg",
    category: "Health",
    date: "25 Jun",
    title: "Little Stars Pediatric Clinic",
    price: "20",
    distance: "0.05 km",
    ageRange: "Age: 0-20 years",
    tag: "Recommended",
  ),
  RecommendedItemModel(
    imagePath: "assets/image/onboarding 3.jpg",
    category: "Health",
    date: "25 Jun",
    title: "Little Stars Pediatric Clinic",
    price: "20",
    distance: "0.05 km",
    ageRange: "Age: 0-20 years",
    tag: "Recommended",
  ),
];
