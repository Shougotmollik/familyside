import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/model/provider_feed_item.dart';
import 'package:familyside/provider/service_provider/sp_manage_provider.dart';
import 'package:familyside/view/family/explorer/widgets/explorer_tab_bar.dart';
import 'package:familyside/view/service_provider/home/widgets/sp_home_skeleton.dart';
import 'package:familyside/view/service_provider/manage/widgets/sp_manage_card.dart'
    show SpCardType, SpManageCard;
import 'package:familyside/view/service_provider/manage/widgets/sp_edit_bottom_sheet.dart';
import 'package:familyside/view/service_provider/manage/widgets/sp_delete_confirm_sheet.dart';

final manageItemsProvider = FutureProvider.family<List<ProviderFeedItem>, String>((ref, type) async {
  return ref.read(spManageProviderProvider.notifier).getManageItems(type: type);
});

class SpManageScreen extends ConsumerStatefulWidget {
  const SpManageScreen({super.key});

  @override
  ConsumerState<SpManageScreen> createState() => _SpManageScreenState();
}

class _SpManageScreenState extends ConsumerState<SpManageScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openEdit(int id, String name, String type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SpEditBottomSheet(
        id: id,
        initialName: name,
        type: type,
        onUpdated: () {
          ref.invalidate(manageItemsProvider(type));
        },
      ),
    );
  }

  void _openDelete(VoidCallback onConfirm) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => SpDeleteConfirmSheet(onDelete: onConfirm),
    );
  }

  Widget _buildList(String type) {
    final asyncItems = ref.watch(manageItemsProvider(type));
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(manageItemsProvider(type));
        await ref.read(manageItemsProvider(type).future);
      },
      child: asyncItems.when(
        loading: () => ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: 3,
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
          itemBuilder: (_, __) => const Padding(
            padding: EdgeInsets.only(bottom: 14),
            child: SpHomeSkeleton(),
          ),
        ),
        error: (err, _) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 48.sp),
                  SizedBox(height: 16.h),
                  Text(
                    'Error: $err',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.text, fontSize: 14.sp),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Pull down to retry',
                    style: TextStyle(color: AppColors.grey, fontSize: 12.sp),
                  ),
                ],
              ),
            ),
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Center(
                  child: Text(
                    'No $type found',
                    style: TextStyle(color: AppColors.grey, fontSize: 14.sp),
                  ),
                ),
              ),
            );
          }
          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
            itemCount: items.length,
            itemBuilder: (_, i) {
              final item = items[i];
              return SpManageCard(
                imagePath: item.imageUrl ?? '',
                category: item.categoryLabel,
                title: item.name,
                price: item.price.toStringAsFixed(0),
                distance: '${item.distanceKm} km',
                ageRange: item.ageRange,
                date: item.dateLabel,
                tag: item.itemType,
                type: type == 'activity'
                    ? SpCardType.activity
                    : (type == 'event' ? SpCardType.event : SpCardType.gift),
                onEdit: () => _openEdit(item.id, item.name, type),
                onDelete: () => _openDelete(() {}),
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
              child: Text(
                'Manage',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            ExplorerTabBar(controller: _tabController),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildList('activity'),
                  _buildList('event'),
                  _buildList('gift'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
