import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/core/router/router_path.dart';
import 'package:familyside/view/widgets/custom_icon_button.dart';
import 'package:familyside/view/widgets/search_bar_widget.dart';
import 'package:familyside/view/widgets/item_card.dart';
import 'package:familyside/view/widgets/sub_category_card.dart';
import 'package:familyside/view/family/home/recomandation_screen.dart';
import 'package:familyside/view/family/home/sub_category_list_screen.dart';
import 'package:familyside/view/widgets/home_filter_bottom_sheet.dart';

class RecommendedItemModel {
  final String imagePath;
  final String category;
  final String date;
  final String title;
  final String price;
  final String distance;
  final String ageRange;
  final String tag;

  const RecommendedItemModel({
    required this.imagePath,
    required this.category,
    required this.date,
    required this.title,
    required this.price,
    required this.distance,
    required this.ageRange,
    required this.tag,
  });
}

class SubCategoryModel {
  final String imagePath;
  final String title;
  final String subtitle;

  const SubCategoryModel({
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });
}

class FamilyHomeScreen extends StatefulWidget {
  const FamilyHomeScreen({super.key});

  @override
  State<FamilyHomeScreen> createState() => _FamilyHomeScreenState();
}

class _FamilyHomeScreenState extends State<FamilyHomeScreen> {
  final TextEditingController searchController = TextEditingController();
  String _selectedCategory = 'All';
  FilterResultModel? _currentFilters;

  final List<String> _categories = [
    'All',
    'Health',
    'Schools',
    'Events',
    'Outdoor',
    'Sports',
  ];

  final List<RecommendedItemModel> _recommendedItems = const [
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
  ];

  final List<RecommendedItemModel> _eventsItems = const [
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

  final List<SubCategoryModel> _subCategories = const [
    SubCategoryModel(
      imagePath: "assets/image/doctor.jpg",
      title: "Pediatrician",
      subtitle: "Clinic / Center",
    ),
    SubCategoryModel(
      imagePath: "assets/image/doctor.jpg",
      title: "Pediatrician",
      subtitle: "Clinic / Center",
    ),
    SubCategoryModel(
      imagePath: "assets/image/doctor.jpg",
      title: "Pediatrician",
      subtitle: "Clinic / Center",
    ),
    SubCategoryModel(
      imagePath: "assets/image/doctor.jpg",
      title: "Pediatrician",
      subtitle: "Clinic / Center",
    ),
    SubCategoryModel(
      imagePath: "assets/image/doctor.jpg",
      title: "Pediatrician",
      subtitle: "Clinic / Center",
    ),
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _openFilterBottomSheet() async {
    final result = await showModalBottomSheet<FilterResultModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          HomeFilterBottomSheet(initialFilters: _currentFilters),
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
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(context),
                SizedBox(height: 24.h),
                _buildSearchSection(),
                SizedBox(height: 24.h),
                _buildCategoriesSection(),
                SizedBox(height: 24.h),
                if (_selectedCategory == 'All') ...[
                  _buildSectionHeader('Recommended for You', () {
                    context.push(
                      RouterPath.familyRecommendationScreen,
                      extra: ListScreenConfig(
                        title: 'Recommended for You',
                        items: _recommendedItems,
                      ),
                    );
                  }),
                  SizedBox(height: 12.h),
                  ...List.generate(_recommendedItems.length, (index) {
                    final item = _recommendedItems[index];
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
                  }),
                  SizedBox(height: 24.h),
                  _buildSectionHeader('Events Near You', () {
                    context.push(
                      RouterPath.familyRecommendationScreen,
                      extra: ListScreenConfig(
                        title: 'Events Near You',
                        items: _eventsItems,
                      ),
                    );
                  }),
                  SizedBox(height: 12.h),
                  ...List.generate(_eventsItems.length, (index) {
                    final item = _eventsItems[index];
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
                  }),
                ] else ...[
                  Text(
                    "Sub-categories",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1D1B20),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ...List.generate(_subCategories.length, (index) {
                    final sub = _subCategories[index];
                    return SubCategoryCard(
                      imagePath: sub.imagePath,
                      title: sub.title,
                      subtitle: sub.subtitle,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                SubCategoryListScreen(title: sub.title),
                          ),
                        );
                      },
                    );
                  }),
                ],
              ],
            ),
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

  Widget _buildProfileHeader(BuildContext context) {
    return Row(
      children: [
        ClipOval(
          child: Image.asset(
            "assets/image/demo_image.jpg",
            height: 52.w,
            width: 52.w,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 52.w,
                width: 52.w,
                color: Colors.grey.shade300,
                child: Icon(Icons.person, color: Colors.grey, size: 24.sp),
              );
            },
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome back Shahid",
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1D1B20),
                ),
              ),
              SizedBox(height: 4.h),
              _buildLocationRow(context),
            ],
          ),
        ),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildLocationRow(BuildContext context) {
    return Row(
      children: [
        Text(
          "Dhaka, Bangladesh",
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF6C6C6C),
          ),
        ),
        SizedBox(width: 4.w),
        SvgPicture.asset(
          "assets/logo/edit.svg",
          height: 14.w,
          width: 14.w,
          colorFilter: const ColorFilter.mode(
            AppColors.primaryLight,
            BlendMode.srcIn,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconButton(assetPath: "assets/logo/save.svg"),
        SizedBox(width: 8.w),
        Stack(
          clipBehavior: Clip.none,
          children: [
            CustomIconButton(
              assetPath: "assets/logo/notification.svg",
              onTap: () {
                context.push(RouterPath.familyNotificationScreen);
              },
            ),
            Positioned(
              top: -2.h,
              right: -2.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "3",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Categories",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1D1B20),
          ),
        ),
        SizedBox(height: 12.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _categories.map((category) {
              final isSelected = _selectedCategory == category;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(right: 10.w),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryLight.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : const Color(0xFFE5E5E5),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.primaryLight
                          : const Color(0xFF939094),
                      fontSize: 14.sp,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onSeeAllTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1D1B20),
          ),
        ),
        GestureDetector(
          onTap: onSeeAllTap,
          child: Text(
            "See All",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryLight,
            ),
          ),
        ),
      ],
    );
  }
}
