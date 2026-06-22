import 'package:cached_network_image/cached_network_image.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/model/gift_api_item.dart';
import 'package:familyside/model/gift_list_response.dart';
import 'package:familyside/provider/family/gift_provider.dart';
import 'package:familyside/utils/app_snackbar.dart';
import 'package:familyside/view/family/gift/widgets/gift_flow.dart';
import 'package:familyside/view/family/gift/widgets/my_gift_list_cards.dart';
import 'package:familyside/view/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GiftListDetailScreen extends ConsumerStatefulWidget {
  final int folderId;

  const GiftListDetailScreen({super.key, required this.folderId});

  @override
  ConsumerState<GiftListDetailScreen> createState() =>
      _GiftListDetailScreenState();
}

class _GiftListDetailScreenState extends ConsumerState<GiftListDetailScreen> {
  FolderDetailResponse? _detail;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData({bool showSkeleton = true}) async {
    if (showSkeleton) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final response = await ref
          .read(giftProviderProvider.notifier)
          .fetchGiftListItems(widget.folderId);

      if (!mounted) return;
      setState(() {
        _detail = response;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  List<GiftApiItem> get _items => _detail?.items ?? [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: CustomAppBar(title: _detail?.name ?? 'Gift List'),
            ),
            Expanded(child: _buildBody()),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: GiftDottedAddButton(
                label: '+ Add another gift to this list',
                onTap: _onAddGift,
              ),
            ),
            SizedBox(height: 18.h),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const _DetailSkeleton();
    }

    if (_error != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 80.h),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cloud_off_outlined,
                  size: 48.sp,
                  color: AppColors.mutedIcon,
                ),
                SizedBox(height: 12.h),
                Text(
                  'Failed to load list items',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.mutedIcon,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 16.h),
                ElevatedButton.icon(
                  onPressed: _loadData,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryLight,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    final items = _items;

    return RefreshIndicator(
      onRefresh: () => _loadData(showSkeleton: false),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        children: [
          SizedBox(height: 8.h),
          Text('Your gift list', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 6.h),
          Text(
            '${items.length} gift(s) in this list',
            style: TextStyle(fontSize: 14.sp, color: AppColors.lightText),
          ),
          SizedBox(height: 20.h),
          if (items.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 40.h),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.card_giftcard_outlined,
                      size: 48.sp,
                      color: AppColors.mutedIcon,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'No gifts in this list yet',
                      style: TextStyle(
                        color: AppColors.mutedIcon,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...items.map((item) => _GiftListItemCard(
              item: item,
              onDelete: () => _confirmDelete(item),
            )),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Future<void> _onAddGift() async {
    await GiftFlow.showPickGiftToAdd(
      context,
      folderId: widget.folderId,
    );

    if (!mounted) return;
    await _loadData(showSkeleton: false);
  }

  Future<void> _confirmDelete(GiftApiItem item) async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _DeleteConfirmSheet(itemName: item.name),
    );

    if (confirmed != true || !mounted) return;

    final success = await ref
        .read(giftProviderProvider.notifier)
        .deleteGiftListItem(folderId: widget.folderId, itemId: item.id);

    if (!mounted) return;

    if (success) {
      AppSnackbar.show(
        message: '"${item.name}" removed from list',
        type: SnackType.success,
      );
      await _loadData(showSkeleton: false);
    } else {
      AppSnackbar.show(
        message: 'Failed to remove gift. Please try again.',
        type: SnackType.error,
      );
    }
  }
}

class _GiftListItemCard extends StatelessWidget {
  final GiftApiItem item;
  final VoidCallback onDelete;

  const _GiftListItemCard({
    required this.item,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final displayPrice = item.price.toStringAsFixed(0);

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: CachedNetworkImage(
                imageUrl: item.imageUrl ?? '',
                width: 80.w,
                height: 80.w,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 80.w,
                  height: 80.w,
                  color: Colors.grey.shade200,
                ),
                errorWidget: (context, url, error) => Container(
                  width: 80.w,
                  height: 80.w,
                  color: Colors.grey.shade200,
                  child: Icon(Icons.image_outlined,
                      color: Colors.grey.shade400, size: 24.sp),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + delete button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
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
                              'assets/icon/delete.svg',
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
                  // Type tag
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      item.itemType,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colors.primary,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  // Price
                  Text(
                    '\$$displayPrice',
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
    );
  }
}

class _DeleteConfirmSheet extends StatelessWidget {
  final String itemName;

  const _DeleteConfirmSheet({required this.itemName});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 24.h),
          // Warning icon
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.text, width: 1.5),
            ),
            child: Center(
              child: Text(
                '!',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Remove gift?',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            'Are you sure you want to remove\n"$itemName" from this list?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.lightText,
            ),
          ),
          SizedBox(height: 28.h),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(false),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: AppColors.primaryLight,
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(true),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: Text(
                        'Remove',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            Container(
              width: 120.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              width: 140.w,
              height: 14.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(height: 20.h),
            ...List.generate(3, (_) => _cardSkeleton()),
          ],
        ),
      ),
    );
  }

  Widget _cardSkeleton() {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(10.w),
      height: 130.h,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Container(
            width: 110.w,
            height: 110.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  width: 100.w,
                  height: 14.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                const Spacer(),
                Container(
                  width: double.infinity,
                  height: 14.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
