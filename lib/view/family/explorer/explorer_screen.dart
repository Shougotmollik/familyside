import 'package:familyside/core/router/router_path.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/model/gift_item_model.dart';
import 'package:familyside/view/family/explorer/models/explorer_data.dart';
import 'package:familyside/view/family/explorer/models/explorer_map_screen_config.dart';
import 'package:go_router/go_router.dart';
import 'package:familyside/view/family/explorer/widgets/activity_card.dart';
import 'package:familyside/view/family/explorer/widgets/explorer_header.dart';
import 'package:familyside/view/family/explorer/widgets/explorer_tab_bar.dart';
import 'package:familyside/view/family/gift/widgets/gift_card.dart';
import 'package:familyside/view/family/gift/widgets/gift_flow.dart';
import 'package:familyside/view/family/gift/widgets/gift_list_model.dart';
import 'package:familyside/view/family/home/family_home_screen.dart';
import 'package:familyside/view/widgets/event_card.dart';
import 'package:familyside/view/widgets/home_filter_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExplorerScreen extends StatefulWidget {
  const ExplorerScreen({super.key});

  @override
  State<ExplorerScreen> createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  FilterResultModel? _currentFilters;
  final Set<int> _bookmarkedGiftIndices = {};
  final List<GiftListModel> _giftLists = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: ExplorerTabBar.tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openMapScreen() {
    context.push(
      RouterPath.familyExplorerMapScreen,
      extra: ExplorerMapScreenConfig.defaults(),
    );
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

  Future<void> _openAddToGiftList(GiftItemModel item) async {
    final result = await GiftFlow.showAddToGiftList(
      context,
      item: item,
      giftLists: _giftLists,
      onListCreated: (list) => setState(() => _giftLists.add(list)),
    );
    if (result != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added to ${result.list.name}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
              child: ExplorerHeader(
                onLocationTap: _openMapScreen,
                onFilterTap: _openFilterBottomSheet,
              ),
            ),
            ExplorerTabBar(controller: _tabController),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _ExplorerListTab(
                    items: ExplorerData.activityItems,
                    itemBuilder: (item) => ActivityCard(
                      imagePath: item.imagePath,
                      category: item.category,
                      date: item.date,
                      title: item.title,
                      price: item.price,
                      distance: item.distance,
                      ageRange: item.ageRange,
                      tag: item.tag,
                    ),
                  ),
                  _ExplorerListTab(
                    items: ExplorerData.eventItems,
                    itemBuilder: (item) => EventCard(
                      imagePath: item.imagePath,
                      category: item.category,
                      date: item.date,
                      title: item.title,
                      price: item.price,
                      distance: item.distance,
                      ageRange: item.ageRange,
                      tag: item.tag,
                    ),
                  ),
                  _ExplorerGiftsTab(
                    items: ExplorerData.giftItems,
                    bookmarkedIndices: _bookmarkedGiftIndices,
                    onBookmarkTap: (index) {
                      setState(() {
                        if (_bookmarkedGiftIndices.contains(index)) {
                          _bookmarkedGiftIndices.remove(index);
                        } else {
                          _bookmarkedGiftIndices.add(index);
                        }
                      });
                    },
                    onAddToGiftList: _openAddToGiftList,
                    onShareTap: (item) => GiftFlow.showShareGiftCard(context, item),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExplorerListTab extends StatelessWidget {
  const _ExplorerListTab({
    required this.items,
    required this.itemBuilder,
  });

  final List<RecommendedItemModel> items;
  final Widget Function(RecommendedItemModel item) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      itemCount: items.length,
      itemBuilder: (context, index) => itemBuilder(items[index]),
    );
  }
}

class _ExplorerGiftsTab extends StatelessWidget {
  const _ExplorerGiftsTab({
    required this.items,
    required this.bookmarkedIndices,
    required this.onBookmarkTap,
    required this.onAddToGiftList,
    required this.onShareTap,
  });

  final List<GiftItemModel> items;
  final Set<int> bookmarkedIndices;
  final ValueChanged<int> onBookmarkTap;
  final Future<void> Function(GiftItemModel item) onAddToGiftList;
  final void Function(GiftItemModel item) onShareTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GiftCard(
          imagePath: item.imagePath,
          title: item.title,
          price: item.price,
          description: item.description,
          location: item.location,
          isBookmarked: bookmarkedIndices.contains(index),
          onAddToGiftList: () => onAddToGiftList(item),
          onShareTap: () => onShareTap(item),
          onBookmarkTap: () => onBookmarkTap(index),
        );
      },
    );
  }
}
