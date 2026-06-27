import 'package:familyside/core/localization/app_localizations.dart';
import 'package:familyside/core/router/router_path.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/model/gift_api_item.dart';
import 'package:familyside/provider/family/home_provider.dart';
import 'package:familyside/view/family/explorer/widgets/activity_card.dart';
import 'package:familyside/view/family/gift/widgets/gift_card.dart';
import 'package:familyside/view/family/home/family_home_screen.dart';
import 'package:familyside/view/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class FamilySavedScreen extends ConsumerStatefulWidget {
  const FamilySavedScreen({super.key});

  @override
  ConsumerState<FamilySavedScreen> createState() => _FamilySavedScreenState();
}

class _FamilySavedScreenState extends ConsumerState<FamilySavedScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  // final Set<int> _bookmarkedGiftIndices = {};  //  saved items only, no bookmark needed here

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAllTabs();
    });
  }

  void _fetchAllTabs() {
    ref
        .read(savedItemsProviderProvider.notifier)
        .fetchSavedItems(itemType: 'activity');
    ref
        .read(savedItemsProviderProvider.notifier)
        .fetchSavedItems(itemType: 'event');
    ref
        .read(savedItemsProviderProvider.notifier)
        .fetchSavedItems(itemType: 'gift');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  RecommendedItemModel _apiItemToRecommended(GiftApiItem item) {
    final formattedDate = item.dateLabel ?? '';
    return RecommendedItemModel(
      imagePath: item.imageUrl ?? '',
      category: item.categoryName ?? '',
      date: formattedDate,
      title: item.name,
      price: item.price.toStringAsFixed(0),
      distance: item.distanceKm != null
          ? '${item.distanceKm!.toStringAsFixed(2)} km'
          : (item.location ?? 'N/A'),
      ageRange: item.ageRange ?? '',
      tag: item.isRecommended ? 'Recommended' : item.itemType,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final savedState = ref.watch(savedItemsProviderProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: savedState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: $err', textAlign: TextAlign.center),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: _fetchAllTabs,
                    child: Text(loc.translate('retry')),
                ),
              ],
            ),
          ),
          data: (data) {
            final activities = data['activity'] ?? <GiftApiItem>[];
            final events = data['event'] ?? <GiftApiItem>[];
            final gifts = data['gift'] ?? <GiftApiItem>[];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header with Back button and Title
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
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
                        loc.translate('saved'),
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                      ),
                    ],
                  ),
                ),
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
                  tabs: [
                    Tab(text: loc.translate('activity')),
                    Tab(text: loc.translate('events')),
                    Tab(text: loc.translate('gifts')),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildList(activities, 'activity'),
                      _buildList(events, 'event'),
                      _buildGiftTab(gifts),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildList(List<GiftApiItem> items, String type) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          'No saved ${type}s found',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref
          .read(savedItemsProviderProvider.notifier)
          .fetchSavedItems(itemType: type),
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final mapped = _apiItemToRecommended(item);
          final card = type == 'activity'
              ? ActivityCard(
                  imagePath: mapped.imagePath,
                  category: mapped.category,
                  date: mapped.date,
                  title: mapped.title,
                  price: mapped.price,
                  distance: mapped.distance,
                  ageRange: mapped.ageRange,
                  tag: mapped.tag,
                  onTap: () => context.push(
                    RouterPath.familyActivityDetailsScreen,
                    extra: item.id,
                  ),
                )
              : EventCard(
                  imagePath: mapped.imagePath,
                  category: mapped.category,
                  date: mapped.date,
                  title: mapped.title,
                  price: mapped.price,
                  distance: mapped.distance,
                  ageRange: mapped.ageRange,
                  tag: mapped.tag,
                  onTap: () => context.push(
                    RouterPath.familyEventDetailsScreen,
                    extra: item.id,
                  ),
                );
          return card;
        },
      ),
    );
  }

  Widget _buildGiftTab(List<GiftApiItem> gifts) {
    if (gifts.isEmpty) {
      return Center(
        child: Text(
          'No saved gifts found',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref
          .read(savedItemsProviderProvider.notifier)
          .fetchSavedItems(itemType: 'gift'),
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: gifts.length,
        itemBuilder: (context, index) {
          final item = gifts[index];
          return GiftCard(
            imagePath: item.imageUrl ?? '',
            title: item.name,
            price: item.price.toStringAsFixed(0),
            description: item.categoryName ?? '',
            location: item.location ?? 'N/A',
            showGiftBadge: true,
            onTap: () => context.push(
              RouterPath.familyGiftDetailsScreen,
              extra: item.id,
            ),
            // saved items - addToGiftList, share, bookmark not needed here
            // onAddToGiftList: null,
            // onShareTap: null,
            // onBookmarkTap: null,
          );
        },
      ),
    );
  }
}
