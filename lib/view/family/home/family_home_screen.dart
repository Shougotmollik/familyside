import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:familyside/model/family_home_feed.dart';
import 'package:familyside/model/sp_home_header.dart';
import 'package:familyside/provider/family/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/core/router/router_path.dart';
import 'package:familyside/view/widgets/custom_icon_button.dart';
import 'package:familyside/view/widgets/search_bar_widget.dart';
import 'package:familyside/view/widgets/event_card.dart';
import 'package:familyside/view/widgets/sub_category_card.dart';
import 'package:familyside/view/family/explorer/models/explorer_data.dart';
import 'package:familyside/view/family/explorer/models/explorer_map_screen_config.dart';
import 'package:familyside/view/family/home/recomandation_screen.dart';
import 'package:familyside/view/widgets/home_filter_bottom_sheet.dart';
import 'package:familyside/view/family/home/widgets/family_home_skeleton.dart';

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

class FamilyHomeScreen extends ConsumerStatefulWidget {
  const FamilyHomeScreen({super.key});

  @override
  ConsumerState<FamilyHomeScreen> createState() => _FamilyHomeScreenState();
}

class _FamilyHomeScreenState extends ConsumerState<FamilyHomeScreen> {
  final TextEditingController searchController = TextEditingController();
  String _selectedCategory = 'All';
  FilterResultModel? _currentFilters;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeProviderProvider.notifier).fetchHomeData();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(homeProviderProvider.notifier).fetchHomeData(query: query);
    });
  }

  RecommendedItemModel _mapToRecommended(FamilyHomeItem item) {
    // Format date: "06 June, 2026" -> "06 June"
    String formattedDate = item.dateLabel;
    if (formattedDate.contains(',')) {
      formattedDate = formattedDate.split(',').first.trim();
    }

    return RecommendedItemModel(
      imagePath: item.imageUrl ?? "",
      category: item.categoryName,
      date: formattedDate,
      title: item.name,
      price: item.price.toStringAsFixed(0),
      distance: item.distanceKm != null
          ? "${item.distanceKm!.toStringAsFixed(2)} km"
          : "N/A",
      ageRange: item.ageRange,
      tag: item.itemType,
    );
  }

  void _openMapScreen(FamilyHomeFeed? feed) {
    if (feed == null) return;

    final List<FamilyHomeItem> items;
    if (_selectedCategory == 'All') {
      items = [...feed.recommended, ...feed.eventsNearYou];
    } else {
      items = [
        ...feed.recommended.where((i) => i.categoryName == _selectedCategory),
        ...feed.eventsNearYou.where((i) => i.categoryName == _selectedCategory),
      ];
    }

    context.push(
      RouterPath.familyExplorerMapScreen,
      extra: ExplorerMapScreenConfig(
        items: ExplorerData.toMapItems(items.map(_mapToRecommended).toList()),
        initialCategory: _selectedCategory,
      ),
    );
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
    final homeState = ref.watch(homeProviderProvider);

    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () =>
              ref.read(homeProviderProvider.notifier).fetchHomeData(),
          child: homeState.when(
            loading: () => const FamilyHomeSkeleton(),
            error: (err, stack) => Center(child: Text('Error: $err')),
            data: (data) {
              final header = data['header'] as SpHomeHeader?;
              final feed = data['feed'] as FamilyHomeFeed?;
              final subCategories = data['subCategories'] as List<FamilySubCategory>;

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileHeader(context, header),
                      SizedBox(height: 24.h),
                      _buildSearchSection(feed),
                      SizedBox(height: 24.h),
                      if (feed != null) _buildCategoriesSection(feed.categories),
                      SizedBox(height: 24.h),
                      if (_selectedCategory == 'All') ...[
                        _buildSectionHeader('Recommended for You', () {
                          if (feed != null && feed.recommended.isNotEmpty) {
                            context.push(
                              RouterPath.familyRecommendationScreen,
                              extra: ListScreenConfig(
                                title: 'Recommended for You',
                                items: feed.recommended
                                    .map(_mapToRecommended)
                                    .toList(),
                              ),
                            );
                          }
                        }),
                        SizedBox(height: 12.h),
                        if (feed == null || feed.recommended.isEmpty)
                          _buildEmptyState('No recommended items found')
                        else
                          ...feed.recommended.take(2).map((item) {
                            final mapped = _mapToRecommended(item);
                            return EventCard(
                              imagePath: mapped.imagePath,
                              category: mapped.category,
                              date: mapped.date,
                              title: mapped.title,
                              price: mapped.price,
                              distance: mapped.distance,
                              ageRange: mapped.ageRange,
                              tag: mapped.tag,
                            );
                          }),
                        SizedBox(height: 24.h),
                        _buildSectionHeader('Events Near You', () {
                          if (feed != null && feed.eventsNearYou.isNotEmpty) {
                            context.push(
                              RouterPath.familyRecommendationScreen,
                              extra: ListScreenConfig(
                                title: 'Events Near You',
                                items: feed.eventsNearYou
                                    .map(_mapToRecommended)
                                    .toList(),
                              ),
                            );
                          }
                        }),
                        SizedBox(height: 12.h),
                        if (feed == null || feed.eventsNearYou.isEmpty)
                          _buildEmptyState('No events found near you')
                        else
                          ...feed.eventsNearYou.take(2).map((item) {
                            final mapped = _mapToRecommended(item);
                            return EventCard(
                              imagePath: mapped.imagePath,
                              category: mapped.category,
                              date: mapped.date,
                              title: mapped.title,
                              price: mapped.price,
                              distance: mapped.distance,
                              ageRange: mapped.ageRange,
                              tag: mapped.tag,
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
                        if (subCategories.isEmpty)
                          const Center(child: Text("No sub-categories found"))
                        else
                          ...subCategories.map((sub) => SubCategoryCard(
                                imagePath: sub.imageUrl ?? "",
                                title: sub.name,
                                subtitle: sub.description,
                                onTap: () {
                                  // Navigate to sub-category details or list
                                },
                              )),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSection(FamilyHomeFeed? feed) {
    return Row(
      children: [
        Expanded(
          child: SearchBarWidget(
            controller: searchController,
            hintText: "Search...",
            onChanged: _onSearchChanged,
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
          onTap: () => _openMapScreen(feed),
        ),
      ],
    );
  }

  Widget _buildProfileHeader(BuildContext context, SpHomeHeader? header) {
    return Row(
      children: [
        ClipOval(
          child: header?.profileImageUrl != null
              ? CachedNetworkImage(
                imageUrl: header!.profileImageUrl!,
                height: 52.w,
                width: 52.w,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 52.w,
                  width: 52.w,
                  color: Colors.grey.shade300,
                  child: Icon(Icons.person, color: Colors.grey, size: 24.sp),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 52.w,
                  width: 52.w,
                  color: Colors.grey.shade300,
                  child: Icon(Icons.person, color: Colors.grey, size: 24.sp),
                ),
              )
              : Image.asset(
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
                "Welcome back ${header?.name.split(' ').first ?? 'User'}",
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1D1B20),
                ),
              ),
              SizedBox(height: 4.h),
              _buildLocationRow(context, header?.location ?? "Location not set"),
            ],
          ),
        ),
        _buildActionButtons(header?.unreadNotifications ?? 0),
      ],
    );
  }

  Widget _buildLocationRow(BuildContext context, String location) {
    return Row(
      children: [
        Text(
          location,
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

  Widget _buildActionButtons(int unreadNotifications) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconButton(
          assetPath: "assets/logo/save.svg",
          onTap: () {
            context.push(RouterPath.familySavedScreen);
          },
        ),
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
            if (unreadNotifications > 0)
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
                    unreadNotifications.toString(),
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

  Widget _buildCategoriesSection(List<FamilyHomeCategory> apiCategories) {
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
            children: [
              _buildCategoryChip('All', null),
              ...apiCategories.map((c) => _buildCategoryChip(c.name, c.id)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String name, int? id) {
    final isSelected = _selectedCategory == name;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = name;
        });
        if (id != null) {
          ref.read(homeProviderProvider.notifier).fetchSubCategories(id);
        }
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
          name,
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
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      width: double.infinity,
      alignment: Alignment.center,
      child: Text(
        message,
        style: TextStyle(
          fontSize: 14.sp,
          color: AppColors.grey,
          fontStyle: FontStyle.italic,
        ),
      ),
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
