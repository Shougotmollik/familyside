import 'package:familyside/view/family/gift/widgets/my_gift_list_models.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class GiftListSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final String badgeLabel;
  final List<Widget> cards;

  const GiftListSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.badgeLabel,
    required this.cards,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium),
                  SizedBox(height: 4.h),
                  Text(subtitle, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(badgeLabel, style: theme.textTheme.labelMedium),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        ...cards,
      ],
    );
  }
}

/// Card for a saved gift list
class GiftListCard extends StatelessWidget {
  final GiftListSummaryModel list;
  final VoidCallback? onTap;

  const GiftListCard({super.key, required this.list, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: Row(
            children: [
              Container(
                height: 44.w,
                width: 44.w,
                decoration: BoxDecoration(
                  color: list.iconBackgroundColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                alignment: Alignment.center,
                child: Text(list.emoji, style: TextStyle(fontSize: 22.sp)),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(list.title, style: theme.textTheme.labelLarge),
                    SizedBox(height: 4.h),
                    Text(
                      '${list.itemCount} items saved',
                      style: theme.textTheme.bodySmall,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Last updated ${list.lastUpdated}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withValues(
                          alpha: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: colors.outline, size: 22.sp),
            ],
          ),
        ),
      ),
    );
  }
}

/// Card for a saved gift that is not in any list yet.
class SavedGiftCard extends StatelessWidget {
  final SavedGiftItemModel item;
  final bool isBookmarked;
  final VoidCallback? onTap;
  final VoidCallback? onBookmarkTap;

  const SavedGiftCard({
    super.key,
    required this.item,
    this.isBookmarked = true,
    this.onTap,
    this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final displayPrice = item.price.startsWith('\$')
        ? item.price
        : '\$${item.price}';

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(10.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.asset(
                  item.imagePath,
                  width: 80.w,
                  height: 80.w,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80.w,
                      height: 80.w,
                      color: colors.surfaceContainerHighest,
                      child: Icon(Icons.image_outlined, size: 24.sp),
                    );
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelLarge,
                          ),
                        ),
                        GestureDetector(
                          onTap: onBookmarkTap,
                          child: Container(
                            height: 28.w,
                            width: 28.w,
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Icon(
                              isBookmarked
                                  ? Icons.bookmark
                                  : Icons.bookmark_outline,
                              color: colors.primary,
                              size: 16.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        item.category,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colors.primary,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      displayPrice,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 15.sp,
                        color: colors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Gift item inside a specific gift list — includes delete action.
class GiftListItemCard extends StatelessWidget {
  final SavedGiftItemModel item;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const GiftListItemCard({
    super.key,
    required this.item,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final displayPrice = item.price.startsWith('\$')
        ? item.price
        : '\$${item.price}';

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(10.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.asset(
                  item.imagePath,
                  width: 80.w,
                  height: 80.w,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80.w,
                      height: 80.w,
                      color: colors.surfaceContainerHighest,
                      child: Icon(Icons.image_outlined, size: 24.sp),
                    );
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelLarge,
                          ),
                        ),
                        GestureDetector(
                          onTap: onDelete,
                          child: Container(
                            height: 28.w,
                            width: 28.w,
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                "assets/icon/delete.svg",
                                height: 16.w,
                                width: 16.w,
                                colorFilter: ColorFilter.mode(
                                  colors.primary,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        item.category,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colors.primary,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      displayPrice,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 15.sp,
                        color: colors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dashed border button for adding gifts to a list.
class GiftDottedAddButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const GiftDottedAddButton({super.key, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          dashPattern: const [6, 4],
          strokeWidth: 1.5,
          radius: Radius.circular(12.r),
          color: colors.primary,
          padding: EdgeInsets.zero,
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          alignment: Alignment.center,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
