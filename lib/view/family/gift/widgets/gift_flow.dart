import 'package:cached_network_image/cached_network_image.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/model/gift_api_item.dart';
import 'package:familyside/model/gift_item_model.dart';
import 'package:familyside/provider/family/gift_provider.dart';
import 'package:familyside/view/family/gift/widgets/add_to_gift_list_bottom_sheet.dart';
import 'package:familyside/view/family/gift/widgets/create_gift_bottom_sheet.dart';
import 'package:familyside/view/family/gift/widgets/create_new_list_bottom_sheet.dart';
import 'package:familyside/view/family/gift/widgets/gift_list_model.dart';
import 'package:familyside/view/family/gift/widgets/share_gift_card_dialog.dart';
import 'package:familyside/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      id: result.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: result.name,
      occasion: result.occasion,
      imagePath: result.imagePath,
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

  static Future<void> showPickGiftToAdd(
    BuildContext context, {
    required int folderId,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _PickGiftBottomSheet(folderId: folderId),
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

class _PickGiftBottomSheet extends ConsumerStatefulWidget {
  final int folderId;

  const _PickGiftBottomSheet({required this.folderId});

  @override
  ConsumerState<_PickGiftBottomSheet> createState() =>
      _PickGiftBottomSheetState();
}

class _PickGiftBottomSheetState extends ConsumerState<_PickGiftBottomSheet> {
  List<GiftApiItem>? _items;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final items = await ref
        .read(giftProviderProvider.notifier)
        .fetchAvailableItems(widget.folderId);

    if (!mounted) return;
    setState(() {
      _items = items;
      _isLoading = false;
    });
  }

  Future<void> _addAndClose(GiftApiItem item) async {
    final success = await ref.read(giftProviderProvider.notifier).addItemToFolder(
      folderId: widget.folderId,
      itemId: item.id,
    );

    if (!mounted) return;

    if (success) {
      AppSnackbar.show(
        message: '"${item.name}" added to list',
        type: SnackType.success,
      );
      Navigator.of(context).pop();
    } else {
      AppSnackbar.show(
        message: 'Failed to add gift. Please try again.',
        type: SnackType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      constraints: BoxConstraints(maxHeight: 0.75.sh),
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
          // Header
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
          // Content
          Flexible(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _items == null || _items!.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.h),
                          child: Column(
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                size: 48.sp,
                                color: AppColors.mutedIcon,
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                'All items are already in this list',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: AppColors.lightText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: _items!.length,
                        separatorBuilder: (_, _) => SizedBox(height: 10.h),
                        itemBuilder: (context, index) {
                          final item = _items![index];
                          final displayPrice =
                              '\$${item.price.toStringAsFixed(0)}';
                          return GestureDetector(
                            onTap: () => _addAndClose(item),
                            child: Card(
                              margin: EdgeInsets.zero,
                              child: Padding(
                                padding: EdgeInsets.all(10.w),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(8.r),
                                      child: CachedNetworkImage(
                                        imageUrl: item.imageUrl ?? '',
                                        width: 80.w,
                                        height: 80.w,
                                        fit: BoxFit.cover,
                                        placeholder: (_, _) => Container(
                                          width: 80.w,
                                          height: 80.w,
                                          color: Colors.grey.shade200,
                                        ),
                                        errorWidget: (_, _, _) =>
                                            Container(
                                          width: 80.w,
                                          height: 80.w,
                                          color: Colors.grey.shade200,
                                          child: Icon(
                                            Icons.image_outlined,
                                            color: Colors.grey.shade400,
                                            size: 24.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: theme
                                                .textTheme.labelLarge
                                                ?.copyWith(fontSize: 14.sp),
                                          ),
                                          SizedBox(height: 6.h),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8.w,
                                              vertical: 3.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: colors.primary
                                                  .withValues(alpha: 0.12),
                                              borderRadius:
                                                  BorderRadius.circular(4.r),
                                            ),
                                            child: Text(
                                              item.itemType,
                                              style: theme
                                                  .textTheme.labelMedium
                                                  ?.copyWith(
                                                color: colors.primary,
                                                fontSize: 10.sp,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 6.h),
                                          Text(
                                            displayPrice,
                                            style: theme
                                                .textTheme.titleMedium
                                                ?.copyWith(
                                              fontSize: 15.sp,
                                              color: colors.secondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.add_circle_outline,
                                      color: colors.primary,
                                      size: 24.sp,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
