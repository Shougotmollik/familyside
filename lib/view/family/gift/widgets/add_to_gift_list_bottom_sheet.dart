import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/model/gift_item_model.dart';
import 'package:familyside/view/family/gift/widgets/gift_item_compact_preview.dart';
import 'package:familyside/view/family/gift/widgets/gift_list_model.dart';
import 'package:familyside/view/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddToGiftListBottomSheet extends StatefulWidget {
  final GiftItemModel giftItem;
  final List<GiftListModel> giftLists;
  final Future<GiftListModel?> Function() onCreateList;

  const AddToGiftListBottomSheet({
    super.key,
    required this.giftItem,
    required this.giftLists,
    required this.onCreateList,
  });

  @override
  State<AddToGiftListBottomSheet> createState() =>
      _AddToGiftListBottomSheetState();
}

class _AddToGiftListBottomSheetState extends State<AddToGiftListBottomSheet> {
  late List<GiftListModel> _lists;

  @override
  void initState() {
    super.initState();
    _lists = List.from(widget.giftLists);
  }

  Future<void> _handleCreateList() async {
    final newList = await widget.onCreateList();
    if (newList != null && mounted) {
      setState(() => _lists.add(newList));
    }
  }

  void _selectList(GiftListModel list) {
    Navigator.pop(
      context,
      AddToGiftListResult(
        list: list,
        giftItemTitle: widget.giftItem.title,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28.r),
          topRight: Radius.circular(28.r),
        ),
      ),
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 24.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add to gift list',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.close,
                  size: 24.sp,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          GiftItemCompactPreview(
            imagePath: widget.giftItem.imagePath,
            title: widget.giftItem.title,
            price: widget.giftItem.price,
            description: widget.giftItem.description,
          ),
          SizedBox(height: 24.h),
          if (_lists.isEmpty) ...[
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32.h),
                child: Text(
                  'No list added yet',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.lightText,
                  ),
                ),
              ),
            ),
          ] else ...[
            ..._lists.map(
              (list) => Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: GestureDetector(
                  onTap: () => _selectList(list),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F9F9),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: const Color(0xFFE5E5E5)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                list.name,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.text,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                list.occasion,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.lightText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: AppColors.grey,
                          size: 22.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
          ],
          CustomElevatedButton(
            onPressed: _handleCreateList,
            title: 'Create list',
            color: AppColors.primaryLight,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
