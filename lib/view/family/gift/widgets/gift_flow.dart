import 'package:familyside/model/gift_item_model.dart';
import 'package:familyside/view/family/gift/widgets/add_to_gift_list_bottom_sheet.dart';
import 'package:familyside/view/family/gift/widgets/create_gift_bottom_sheet.dart';
import 'package:familyside/view/family/gift/widgets/create_new_list_bottom_sheet.dart';
import 'package:familyside/view/family/gift/widgets/gift_list_model.dart';
import 'package:familyside/view/family/gift/widgets/share_gift_card_dialog.dart';
import 'package:flutter/material.dart';

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
