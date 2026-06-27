import 'package:familyside/core/localization/app_localizations.dart';
import 'package:familyside/model/notification.dart';
import 'package:familyside/provider/family/family_notification_provider.dart';
import 'package:familyside/view/family/notification/widgets/notification_skeleton.dart';
import 'package:familyside/view/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:familyside/core/theme/app_colors.dart';

class NotificationCard extends StatelessWidget {
  final NotificationItem notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.white : const Color(0xFFF8F4FF),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48.w,
            width: 48.w,
            decoration: BoxDecoration(
              color: notification.isRead
                  ? AppColors.primaryLight.withValues(alpha: 0.1)
                  : AppColors.primaryLight.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                _iconForType(notification.itemType),
                color: AppColors.primaryLight,
                size: 24.sp,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1D1B20),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      notification.timeAgo,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF939094),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  notification.subtitle,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF6C6C6C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForType(String itemType) {
    switch (itemType) {
      case 'event':
        return Icons.event;
      case 'activity':
        return Icons.sports_kabaddi;
      case 'gift':
        return Icons.card_giftcard;
      case 'message':
        return Icons.message_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }
}

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(familyNotificationProvider.notifier).fetchNotifications();
    });
  }

  Future<void> _onRefresh() async {
    await ref.read(familyNotificationProvider.notifier).fetchNotifications();
  }

  Future<void> _onMarkAllAsRead() async {
    final success = await ref
        .read(familyNotificationProvider.notifier)
        .markAllAsRead();
    if (mounted && !success) {
      final loc = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.translate('failedToMarkAllRead'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final notificationState = ref.watch(familyNotificationProvider);
    final unreadCount = notificationState.asData?.value.unreadCount ?? 0;

    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: CustomAppBar(
                title: loc.translate('notifications'),
                trailing: unreadCount > 0
                    ? GestureDetector(
                        onTap: _onMarkAllAsRead,
                        child: Text(
                          loc.translate('markAllAsRead'),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryLight,
                          ),
                        ),
                      )
                    : null,
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: notificationState.when(
                  loading: () => const NotificationSkeleton(),
                  error: (error, _) => ListView(
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
                              loc.translate('failedToLoadNotifications'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.mutedIcon,
                                fontSize: 16.sp,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            ElevatedButton.icon(
                              onPressed: _onRefresh,
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
                  ),
                  data: (response) {
                    if (response.groups.isEmpty) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(height: 80.h),
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.notifications_off_outlined,
                                  size: 48.sp,
                                  color: AppColors.mutedIcon,
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  loc.translate('noNotifications'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.mutedIcon,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }

                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      children: [
                        ...response.groups.map((group) {
                          return _buildSection(group.groupName, group.notifications);
                        }),
                        SizedBox(height: 20.h),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<NotificationItem> notifications) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1D1B20),
          ),
        ),
        SizedBox(height: 12.h),
        ...notifications.map(
          (notification) => NotificationCard(notification: notification),
        ),
      ],
    );
  }
}
