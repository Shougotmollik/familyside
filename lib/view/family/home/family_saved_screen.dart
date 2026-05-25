import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/core/router/router_path.dart';
import 'package:familyside/model/gift_item_model.dart';
import 'package:familyside/view/family/explorer/widgets/activity_card.dart';
import 'package:familyside/view/widgets/event_card.dart';
import 'package:familyside/view/family/gift/widgets/gift_card.dart';
import 'package:familyside/view/family/home/family_home_screen.dart';

class FamilySavedScreen extends StatefulWidget {
  const FamilySavedScreen({super.key});

  @override
  State<FamilySavedScreen> createState() => _FamilySavedScreenState();
}

class _FamilySavedScreenState extends State<FamilySavedScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  String _selectedGiftCategory = 'Birthday';
  final List<String> _giftCategories = [
    'Birthday',
    'Christmas',
    'Special',
    'General',
    'Anniversary',
  ];

  final List<RecommendedItemModel> _savedActivities = const [
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

  final List<RecommendedItemModel> _savedEvents = const [
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
      category: 'Events',
      date: '25 Jun',
      title: 'Little Stars Pediatric Clinic',
      price: '20',
      distance: '0.05 km',
      ageRange: 'Age: 0-20 years',
      tag: 'Recommended',
    ),
  ];

  final List<Map<String, dynamic>> _savedGifts = [
    {
      'imagePath': 'assets/image/onboarding 1.jpg',
      'title': '1 Month Activity Pass',
      'price': '45',
      'description': 'Gift a month of fun activities at Green Meadows...',
      'location': 'Green meadows ark',
      'categories': ['Birthday', 'General'],
    },
    {
      'imagePath': 'assets/image/onboarding 2.jpg',
      'title': '1 Month Activity Pass',
      'price': '45',
      'description': 'Gift a month of fun activities at Green Meadows...',
      'location': 'Green meadows ark',
      'categories': ['Birthday', 'Christmas'],
    },
    {
      'imagePath': 'assets/image/onboarding 3.jpg',
      'title': 'Kids Toy Set Voucher',
      'price': '25',
      'description': 'Redeemable voucher for kids learning toys and sets...',
      'location': 'Toyland Center',
      'categories': ['Christmas', 'Special'],
    },
    {
      'imagePath': 'assets/image/onboarding 1.jpg',
      'title': 'Family Day Park Pass',
      'price': '60',
      'description': 'Full-day access for family to all rides and events...',
      'location': 'Green meadows ark',
      'categories': ['Special', 'Anniversary'],
    },
  ];

  List<Map<String, dynamic>> get _filteredGifts {
    return _savedGifts.where((item) {
      final cats = item['categories'] as List<String>;
      return cats.contains(_selectedGiftCategory);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with Back button and Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 22.sp,
                      color: AppColors.text,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Saved',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),
            ),

            // Tab Bar
            TabBar(
              controller: _tabController,
              dividerColor: Colors.transparent,
              indicatorColor: AppColors.primaryLight,
              indicatorWeight: 2.h,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: AppColors.primaryLight,
              unselectedLabelColor: AppColors.grey,
              labelStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              tabs: const [
                Tab(text: 'Activity'),
                Tab(text: 'Events'),
                Tab(text: 'Gifts'),
              ],
            ),

            // Tab Bar Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Activity Tab Content
                  _buildActivityList(),

                  // Events Tab Content
                  _buildEventList(),

                  // Gifts Tab Content
                  _buildGiftTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityList() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: _savedActivities.length,
      itemBuilder: (context, index) {
        final item = _savedActivities[index];
        return ActivityCard(
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
    );
  }

  Widget _buildEventList() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: _savedEvents.length,
      itemBuilder: (context, index) {
        final item = _savedEvents[index];
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
    );
  }

  Widget _buildGiftTab() {
    final filtered = _filteredGifts;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
          child: Text(
            'Browse from list',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 38.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: _giftCategories.length,
            itemBuilder: (context, index) {
              final cat = _giftCategories[index];
              final isSelected = _selectedGiftCategory == cat;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedGiftCategory = cat;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(right: 8.w),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryLight
                        : AppColors.primaryLight.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Center(
                    child: Text(
                      cat,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppColors.primaryLight,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 8.h),
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Text(
                    'No saved items in this category',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.lightText,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return GiftCard(
                      imagePath: item['imagePath'],
                      title: item['title'],
                      price: item['price'],
                      description: item['description'],
                      location: item['location'],
                      isBookmarked: true,
                      onTap: () => context.push(
                        RouterPath.familyGiftDetailsScreen,
                        extra: GiftItemModel(
                          imagePath: item['imagePath'],
                          title: item['title'],
                          price: item['price'],
                          description: item['description'],
                          location: item['location'],
                        ),
                      ),
                      onAddToGiftList: () {},
                      onShareTap: () {},
                      onBookmarkTap: () {},
                    );
                  },
                ),
        ),
      ],
    );
  }
}
