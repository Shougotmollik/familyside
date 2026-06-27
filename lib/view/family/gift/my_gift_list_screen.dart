import 'package:familyside/core/config/credential.dart';
import 'package:familyside/core/localization/app_localizations.dart';
import 'package:familyside/core/router/router_path.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/model/gift_list_response.dart';
import 'package:familyside/provider/family/gift_provider.dart';
import 'package:familyside/view/family/gift/widgets/gift_flow.dart';
import 'package:familyside/view/family/gift/widgets/my_gift_list_cards.dart';
import 'package:familyside/view/family/gift/widgets/my_gift_list_models.dart';
import 'package:familyside/view/widgets/custom_app_bar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:familyside/view/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class MyGiftListScreen extends ConsumerStatefulWidget {
  const MyGiftListScreen({super.key});

  @override
  ConsumerState<MyGiftListScreen> createState() => _MyGiftListScreenState();
}

class _MyGiftListScreenState extends ConsumerState<MyGiftListScreen> {
  GiftListsResponse? _giftListsResponse;
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
          .fetchGiftLists();

      if (!mounted) return;
      setState(() {
        _giftListsResponse = response;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      if (_giftListsResponse == null) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  int get _giftListsItemCount =>
      _giftListsResponse?.folders.fold<int>(
        0,
        (sum, folder) => sum + folder.itemsCount,
      ) ??
      0;

  GiftListSummaryModel _folderToSummary(GiftListFolder folder) {
    return GiftListSummaryModel(
      id: folder.id.toString(),
      title: folder.name,
      emoji: _emojiForOccasion(folder.occasion),
      iconBackgroundColor: _colorForOccasion(folder.occasion),
      itemCount: folder.itemsCount,
      lastUpdated: folder.lastUpdatedLabel,
      imagePath: folder.imageUrl != null
          ? AppCredentials.fixurl(folder.imageUrl!)
          : null,
    );
  }

  String _emojiForOccasion(String occasion) {
    switch (occasion) {
      case 'Christmas':
        return '🎄';
      case 'Special':
        return '👶';
      default:
        return '🎂';
    }
  }

  Color _colorForOccasion(String occasion) {
    switch (occasion) {
      case 'Christmas':
        return const Color(0xFFE8F5E9);
      case 'Special':
        return const Color(0xFFE3F2FD);
      default:
        return const Color(0xFFFFE5E8);
    }
  }

  Future<void> _onCreateList() async {
    final list = await GiftFlow.showCreateNewList(context);
    if (list == null || !mounted) return;

    // Re-fetch to get real data from API
    await _loadData(showSkeleton: false);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: CustomAppBar(title: loc.translate('myGiftList')),
            ),
            Expanded(child: _buildBody()),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
              child: CustomElevatedButton(
                onPressed: _onCreateList,
                title: loc.translate('createList'),
                color: Theme.of(context).colorScheme.primary,
                textColor: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    final loc = AppLocalizations.of(context);
    if (_isLoading) {
      return const _GiftListSkeleton();
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
                  loc.translate('failedToLoadGiftLists'),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.mutedIcon, fontSize: 16.sp),
                ),
                SizedBox(height: 16.h),
                ElevatedButton.icon(
                  onPressed: _loadData,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: Text(loc.translate('retry')),
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

    final response = _giftListsResponse!;
    final folders = response.folders;

    if (folders.isEmpty && response.looseItems.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 80.h),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.card_giftcard_outlined,
                  size: 48.sp,
                  color: AppColors.mutedIcon,
                ),
                SizedBox(height: 12.h),
                Text(
                  loc.translate('noGiftListsYet'),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.mutedIcon, fontSize: 16.sp),
                ),
                SizedBox(height: 4.h),
                Text(
                  loc.translate('createFirstList'),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.mutedIcon, fontSize: 14.sp),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        children: [
          SizedBox(height: 16.h),
          GiftListSection(
            title: loc.translate('yourGiftList'),
            subtitle: loc.translate('giftsSavedInsideLists'),
            badgeLabel: '$_giftListsItemCount list items',
            cards: folders
                .map(
                  (folder) => GiftListCard(
                    list: _folderToSummary(folder),
                    onTap: () => context.push(
                      RouterPath.familyGiftListDetailScreen,
                      extra: folder.id,
                    ),
                  ),
                )
                .toList(),
          ),
          if (response.looseItems.isNotEmpty) ...[
            SizedBox(height: 24.h),
            GiftListSection(
              title: loc.translate('savedGiftsWithoutList'),
              subtitle: loc.translate('giftsNotInAnyList'),
              badgeLabel: '${response.looseItems.length} list items',
              cards: const [], // Loose items data not fully mapped yet
            ),
          ],
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

class _GiftListSkeleton extends StatelessWidget {
  const _GiftListSkeleton();

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
              width: 180.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(height: 4.h),
            Container(
              width: 240.w,
              height: 14.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(height: 16.h),
            ...List.generate(3, (_) => _cardSkeleton()),
          ],
        ),
      ),
    );
  }

  Widget _cardSkeleton() {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            height: 44.w,
            width: 44.w,
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
                  width: 140.w,
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
                SizedBox(height: 4.h),
                Container(
                  width: 120.w,
                  height: 12.h,
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
