import 'package:familyside/core/router/router_path.dart';
import 'package:familyside/view/family/gift/widgets/gift_flow.dart';
import 'package:familyside/view/family/gift/widgets/my_gift_list_cards.dart';
import 'package:familyside/view/family/gift/widgets/my_gift_list_models.dart';
import 'package:familyside/view/widgets/custom_app_bar.dart';
import 'package:familyside/view/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class MyGiftListScreenConfig {
  final List<GiftListSummaryModel> giftLists;
  final List<SavedGiftItemModel> savedGiftsWithoutList;

  const MyGiftListScreenConfig({
    required this.giftLists,
    required this.savedGiftsWithoutList,
  });
}

class MyGiftListScreen extends StatefulWidget {
  final MyGiftListScreenConfig config;

  const MyGiftListScreen({super.key, required this.config});

  @override
  State<MyGiftListScreen> createState() => _MyGiftListScreenState();
}

class _MyGiftListScreenState extends State<MyGiftListScreen> {
  late List<GiftListSummaryModel> _giftLists;
  late List<SavedGiftItemModel> _savedGiftsWithoutList;

  @override
  void initState() {
    super.initState();
    _giftLists = List.from(widget.config.giftLists);
    _savedGiftsWithoutList = List.from(widget.config.savedGiftsWithoutList);
  }

  int get _giftListsItemCount =>
      _giftLists.fold<int>(0, (sum, list) => sum + list.itemCount);

  Future<void> _onCreateList() async {
    final list = await GiftFlow.showCreateNewList(context);
    if (list == null || !mounted) return;

    final summary = _summaryFromOccasion(
      id: list.id,
      name: list.name,
      occasion: list.occasion,
    );

    setState(() => _giftLists.insert(0, summary));
  }

  GiftListSummaryModel _summaryFromOccasion({
    required String id,
    required String name,
    required String occasion,
  }) {
    switch (occasion) {
      case 'Christmas':
        return GiftListSummaryModel(
          id: id,
          title: name,
          emoji: '🎄',
          iconBackgroundColor: const Color(0xFFE8F5E9),
          itemCount: 0,
          lastUpdated: 'today',
        );
      case 'Special':
        return GiftListSummaryModel(
          id: id,
          title: name,
          emoji: '👶',
          iconBackgroundColor: const Color(0xFFE3F2FD),
          itemCount: 0,
          lastUpdated: 'today',
        );
      default:
        return GiftListSummaryModel(
          id: id,
          title: name,
          emoji: '🎂',
          iconBackgroundColor: const Color(0xFFFFE5E8),
          itemCount: 0,
          lastUpdated: 'today',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: const CustomAppBar(title: 'My gift list'),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GiftListSection(
                      title: 'Your gift list',
                      subtitle: 'Gifts saved inside your gift lists',
                      badgeLabel: '$_giftListsItemCount list items',
                      cards: _giftLists
                          .map(
                            (list) => GiftListCard(
                              list: list,
                              onTap: () => context.push(
                                RouterPath.familyGiftListDetailScreen,
                                extra: giftListDetailConfigFor(list),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    SizedBox(height: 24.h),
                    GiftListSection(
                      title: 'Saved gifts without a list',
                      subtitle:
                          "Gifts you saved but didn't add to any list yet",
                      badgeLabel:
                          '${_savedGiftsWithoutList.length} list items',
                      cards: _savedGiftsWithoutList
                          .map((item) => SavedGiftCard(item: item))
                          .toList(),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
              child: CustomElevatedButton(
                onPressed: _onCreateList,
                title: 'Create list',
                color: Theme.of(context).colorScheme.primary,
                textColor: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

