import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/model/gift_item_model.dart';
import 'package:familyside/view/family/gift/widgets/gift_card.dart';
import 'package:familyside/view/widgets/custom_icon_button.dart';
import 'package:familyside/view/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:familyside/view/family/gift/widgets/gift_filter_result_model.dart';
import 'package:familyside/view/family/gift/widgets/gift_flow.dart';
import 'package:familyside/view/family/gift/widgets/gift_filter_bottom_sheet.dart';
import 'package:familyside/view/family/gift/widgets/gift_list_model.dart';

class GiftScreen extends StatefulWidget {
  const GiftScreen({super.key});

  @override
  State<GiftScreen> createState() => _GiftScreenState();
}

class _GiftScreenState extends State<GiftScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  GiftFilterResultModel? _currentFilters;
  final Set<int> _bookmarkedIndices = {};
  final List<GiftListModel> _giftLists = [];

  final List<String> _categories = const [
    'All',
    'My gifts',
    'Birthday',
    'Christmas',
    'Special',
  ];

  final List<GiftItemModel> _giftItems = const [
    GiftItemModel(
      imagePath: 'assets/image/onboarding 1.jpg',
      title: '1 Month Activity Pass',
      price: '45',
      description:
          'Gift a month of fun activities at Green Meadows...',
      location: 'Green meadows ark',
    ),
    GiftItemModel(
      imagePath: 'assets/image/onboarding 2.jpg',
      title: '1 Month Activity Pass',
      price: '45',
      description:
          'Gift a month of fun activities at Green Meadows...',
      location: 'Green meadows ark',
    ),
    GiftItemModel(
      imagePath: 'assets/image/onboarding 3.jpg',
      title: '1 Month Activity Pass',
      price: '45',
      description:
          'Gift a month of fun activities at Green Meadows...',
      location: 'Green meadows ark',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openCreateGiftBottomSheet([GiftItemModel? item]) async {
    final giftItem = item ?? _giftItems.first;
    await GiftFlow.showCreateGiftCard(context, giftItem);
  }

  Future<void> _openAddToGiftList(GiftItemModel item) async {
    final result = await GiftFlow.showAddToGiftList(
      context,
      item: item,
      giftLists: _giftLists,
      onListCreated: (list) => setState(() => _giftLists.add(list)),
    );
    if (result != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added to ${result.list.name}'),
        ),
      );
    }
  }

  void _openShareGiftCard(GiftItemModel item) {
    GiftFlow.showShareGiftCard(context, item);
  }

  Future<void> _openFilterBottomSheet() async {
    final result = await showModalBottomSheet<GiftFilterResultModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          GiftFilterBottomSheet(initialFilters: _currentFilters),
    );

    if (result != null) {
      setState(() => _currentFilters = result);
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
                _buildProfileHeader(),
                SizedBox(height: 24.h),
                _buildSearchSection(),
                SizedBox(height: 24.h),
                _buildCategoriesSection(),
                SizedBox(height: 24.h),
                _buildSearchResultSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        ClipOval(
          child: Image.asset(
            'assets/image/demo_image.jpg',
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
                'Welcome back Shahid',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Dhaka, Bangladesh',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.lightText,
                ),
              ),
            ],
          ),
        ),
        _buildHeaderActions(),
      ],
    );
  }

  Widget _buildHeaderActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.secondaryLight,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              'My list',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        GestureDetector(
          onTap: _openCreateGiftBottomSheet,
          child: Container(
            height: 36.w,
            width: 36.w,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(Icons.add, color: Colors.white, size: 22.sp),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchSection() {
    return Row(
      children: [
        Expanded(
          child: SearchBarWidget(
            controller: _searchController,
            hintText: 'Search Planner...',
          ),
        ),
        SizedBox(width: 12.w),
        CustomIconButton(
          assetPath: 'assets/logo/filter.svg',
          containerHeight: 48.h,
          containerWidth: 48.w,
          borderRadius: 8.r,
          iconWidth: 24.w,
          iconHeight: 24.h,
          onTap: _openFilterBottomSheet,
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
        SizedBox(height: 12.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _categories.map((category) {
              final isSelected = _selectedCategory == category;
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = category),
                child: Container(
                  margin: EdgeInsets.only(right: 10.w),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryLight
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryLight
                          : const Color(0xFFE5E5E5),
                    ),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.primaryLight,
                      fontSize: 14.sp,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
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

  Widget _buildSearchResultSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Search Result',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                'See All',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryLight,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        ...List.generate(_giftItems.length, (index) {
          final item = _giftItems[index];
          return GiftCard(
            imagePath: item.imagePath,
            title: item.title,
            price: item.price,
            description: item.description,
            location: item.location,
            isBookmarked: _bookmarkedIndices.contains(index),
            onAddToGiftList: () => _openAddToGiftList(item),
            onShareTap: () => _openShareGiftCard(item),
            onBookmarkTap: () {
              setState(() {
                if (_bookmarkedIndices.contains(index)) {
                  _bookmarkedIndices.remove(index);
                } else {
                  _bookmarkedIndices.add(index);
                }
              });
            },
          );
        }),
      ],
    );
  }
}
