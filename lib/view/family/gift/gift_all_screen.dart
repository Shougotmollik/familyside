import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/model/gift_item_model.dart';
import 'package:familyside/view/family/gift/widgets/gift_card.dart';
import 'package:familyside/view/family/gift/widgets/gift_flow.dart';
import 'package:familyside/view/family/gift/widgets/gift_list_model.dart';
import 'package:familyside/view/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GiftAllScreenConfig {
  final String title;
  final List<GiftItemModel> items;

  const GiftAllScreenConfig({required this.title, required this.items});
}

class GiftAllScreen extends StatefulWidget {
  final GiftAllScreenConfig config;

  const GiftAllScreen({super.key, required this.config});

  @override
  State<GiftAllScreen> createState() => _GiftAllScreenState();
}

class _GiftAllScreenState extends State<GiftAllScreen> {
  final Set<int> _bookmarkedIndices = {};
  final List<GiftListModel> _giftLists = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: CustomAppBar(title: widget.config.title),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: widget.config.items.length,
                itemBuilder: (context, index) {
                  final item = widget.config.items[index];
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
