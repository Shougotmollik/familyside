import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/model/gift_item_model.dart';
import 'package:familyside/view/family/gift/widgets/add_to_gift_list_bottom_sheet.dart';
import 'package:familyside/view/family/gift/widgets/create_gift_bottom_sheet.dart';
import 'package:familyside/view/family/gift/widgets/create_new_list_bottom_sheet.dart';
import 'package:familyside/view/family/gift/widgets/gift_list_model.dart';
import 'package:familyside/view/family/gift/widgets/my_gift_list_cards.dart';
import 'package:familyside/view/family/gift/widgets/my_gift_list_models.dart';
import 'package:familyside/view/family/gift/widgets/share_gift_card_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Coordinates gift-related bottom sheets and dialogs.
class GiftFlow {
  GiftFlow._();

  static Future<CreateGiftCardData?> showCreateGiftCard(
    BuildContext context,
    GiftItemModel item,
  ) {
    return showModalBottomSheet<CreateGiftCardData>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => CreateGiftBottomSheet(
        giftItem: item,
        onSharePressed: (giftItem) => showShareGiftCard(context, giftItem),
      ),
    );
  }

  static Future<void> showShareGiftCard(
    BuildContext context,
    GiftItemModel item,
  ) {
    return showDialog<void>(
      context: context,
      builder: (context) => ShareGiftCardDialog(giftItem: item),
    );
  }

  static Future<GiftListModel?> showCreateNewList(BuildContext context) async {
    final result = await showModalBottomSheet<CreateNewListResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CreateNewListBottomSheet(),
    );

    if (result == null) return null;

    return GiftListModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: result.name,
      occasion: result.occasion,
    );
  }

  static Future<CreateNewListResult?> showEditListDetails(
    BuildContext context, {
    required String listName,
    required String occasion,
  }) {
    return showModalBottomSheet<CreateNewListResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateNewListBottomSheet(
        title: 'Edit list Details',
        submitLabel: 'Save',
        initialName: listName,
        initialOccasion: occasion,
      ),
    );
  }

  static Future<SavedGiftItemModel?> showPickGiftToAdd(BuildContext context) {
    return showModalBottomSheet<SavedGiftItemModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _PickGiftBottomSheet(),
    );
  }

  static Future<AddToGiftListResult?> showAddToGiftList(
    BuildContext context, {
    required GiftItemModel item,
    required List<GiftListModel> giftLists,
    required void Function(GiftListModel list) onListCreated,
  }) async {
    return showModalBottomSheet<AddToGiftListResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => AddToGiftListBottomSheet(
        giftItem: item,
        giftLists: giftLists,
        onCreateList: () => showCreateNewList(sheetContext).then((list) {
          if (list != null) onListCreated(list);
          return list;
        }),
      ),
    );
  }
}

class _PickGiftBottomSheet extends StatelessWidget {
  const _PickGiftBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 0.7.sh),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28.r),
          topRight: Radius.circular(28.r),
        ),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add gift to list',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.close, size: 24.sp, color: AppColors.text),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: browseGiftsForPicker.length,
              separatorBuilder: (context, index) => SizedBox(height: 8.h),
              itemBuilder: (context, index) {
                final gift = browseGiftsForPicker[index];
                return SavedGiftCard(
                  item: gift,
                  isBookmarked: false,
                  onTap: () => Navigator.pop(context, gift),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
