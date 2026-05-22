import 'package:familyside/view/family/gift/widgets/gift_flow.dart';
import 'package:familyside/view/family/gift/widgets/my_gift_list_cards.dart';
import 'package:familyside/view/family/gift/widgets/my_gift_list_models.dart';
import 'package:familyside/view/widgets/custom_app_bar.dart';
import 'package:familyside/view/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GiftListDetailScreen extends StatefulWidget {
  final GiftListDetailScreenConfig config;

  const GiftListDetailScreen({super.key, required this.config});

  @override
  State<GiftListDetailScreen> createState() => _GiftListDetailScreenState();
}

class _GiftListDetailScreenState extends State<GiftListDetailScreen> {
  late GiftListSummaryModel _list;
  late String _description;
  late List<SavedGiftItemModel> _items;

  @override
  void initState() {
    super.initState();
    _list = widget.config.list;
    _description = widget.config.description;
    _items = List.from(widget.config.items);
  }

  String get _occasion {
    switch (_list.id) {
      case '2':
        return 'Christmas';
      case '3':
        return 'Special';
      default:
        return 'Birthday';
    }
  }

  void _removeItem(int index) {
    setState(() => _items.removeAt(index));
  }

  Future<void> _onAddGift() async {
    final gift = await GiftFlow.showPickGiftToAdd(context);
    if (gift == null || !mounted) return;

    final alreadyAdded = _items.any(
      (item) =>
          item.title == gift.title &&
          item.imagePath == gift.imagePath &&
          item.category == gift.category,
    );
    if (alreadyAdded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This gift is already in the list')),
      );
      return;
    }

    setState(() => _items.add(gift));
  }

  Future<void> _onEditListDetails() async {
    final result = await GiftFlow.showEditListDetails(
      context,
      listName: _list.title,
      occasion: _occasion,
    );
    if (result == null || !mounted) return;

    setState(() {
      _list = GiftListSummaryModel(
        id: _list.id,
        title: result.name,
        emoji: _list.emoji,
        iconBackgroundColor: _list.iconBackgroundColor,
        itemCount: _items.length,
        lastUpdated: 'today',
      );
      _description = giftListDescriptions[_list.id] ??
          'Gifts saved in ${result.name}.';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('List details updated')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: CustomAppBar(title: _list.title),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your gift list', style: theme.textTheme.titleMedium),
                    SizedBox(height: 6.h),
                    Text(_description, style: theme.textTheme.bodySmall),
                    SizedBox(height: 20.h),
                    ...List.generate(_items.length, (index) {
                      final item = _items[index];
                      return GiftListItemCard(
                        item: item,
                        onDelete: () => _removeItem(index),
                      );
                    }),
                    SizedBox(height: 8.h),
                  ],
                ),
              ),
            ),

             Padding(
               padding: EdgeInsets.all(16.w),
               child: GiftDottedAddButton(
                      label: '+ Add another gift to this list',
                      onTap: _onAddGift,
                    ),
             ),
             SizedBox(height: 18.h),
            // Padding(
            //   padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
            //   child: Column(
            //     children: [
            //       GiftDottedAddButton(
            //         label: '+ Add another gift to this list',
            //         onTap: _onAddGift,
            //       ),
            //       SizedBox(height: 12.h),
            //       // CustomElevatedButton(
            //       //   onPressed: _onEditListDetails,
            //       //   title: 'Edit list Details',
            //       //   color: colors.primary,
            //       //   textColor: colors.onPrimary,
            //       // ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
