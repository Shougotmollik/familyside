import 'package:familyside/core/localization/app_localizations.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/model/gift_item_model.dart';
import 'package:familyside/utils/share_helper.dart';
import 'package:familyside/view/family/gift/widgets/gift_item_compact_preview.dart';
import 'package:familyside/view/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShareGiftCardDialog extends StatelessWidget {
  final GiftItemModel giftItem;
  final VoidCallback? onShare;

  const ShareGiftCardDialog({
    super.key,
    required this.giftItem,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Dialog(
      backgroundColor: AppColors.surfaceLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${loc.translate('share')} ${loc.translate('gift')}',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            SizedBox(height: 16.h),
            Divider(height: 1.h, color: AppColors.divider),
            SizedBox(height: 16.h),
            GiftItemCompactPreview(
              imagePath: giftItem.imagePath,
              title: giftItem.title,
              price: giftItem.price,
              description: giftItem.description,
            ),
            SizedBox(height: 24.h),
            CustomElevatedButton(
              onPressed: () {
                if (onShare != null) {
                  onShare!();
                } else {
                  ShareHelper.shareItem(
                    name: giftItem.title,
                    description: giftItem.description,
                    price: '\$${giftItem.price}',
                  );
                }
                Navigator.pop(context);
              },
              title: '${loc.translate('share')} ${loc.translate('gift')}',
              color: AppColors.primaryLight,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
