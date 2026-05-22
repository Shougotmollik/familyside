import 'package:familyside/core/router/router_path.dart';
import 'package:familyside/view/family/explorer/models/explorer_data.dart';
import 'package:familyside/view/family/explorer/models/explorer_map_item.dart';
import 'package:familyside/view/family/explorer/models/explorer_map_screen_config.dart';
import 'package:familyside/view/family/home/family_home_screen.dart';
import 'package:familyside/view/family/home/sub_category_list_screen_config.dart';
import 'package:familyside/view/widgets/custom_icon_button.dart';
import 'package:familyside/view/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/view/widgets/custom_app_bar.dart';
import 'package:familyside/view/widgets/event_card.dart';
import 'package:familyside/view/widgets/category_filter_bottom_sheet.dart';
import 'package:go_router/go_router.dart';

class SubCategoryListScreen extends StatefulWidget {
  final SubCategoryListScreenConfig config;

  const SubCategoryListScreen({super.key, required this.config});

  @override
  State<SubCategoryListScreen> createState() => _SubCategoryListScreenState();
}

class _SubCategoryListScreenState extends State<SubCategoryListScreen> {
  final TextEditingController searchController = TextEditingController();
  CategoryFilterResultModel? _currentFilters;

  List<RecommendedItemModel> get _items => widget.config.items;

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

  void _openMapScreen() {
    context.push(
      RouterPath.familyExplorerMapScreen,
      extra: ExplorerMapScreenConfig(
        items: ExplorerData.toMapItems(
          widget.config.items,
          type: ExplorerItemType.activity,
        ),
        initialCategory: 'All',
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
              CustomAppBar(title: widget.config.title),
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
            hintText: 'Search...',
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
        SizedBox(width: 12.w),
        CustomIconButton(
          assetPath: 'assets/logo/location.svg',
          containerHeight: 48.h,
          containerWidth: 48.w,
          borderRadius: 8.r,
          iconWidth: 24.w,
          iconHeight: 24.h,
          onTap: _openMapScreen,
        ),
      ],
    );
  }
}
