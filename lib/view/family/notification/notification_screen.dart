import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/view/widgets/custom_app_bar.dart';

class NotificationModel {
  final String title;
  final String description;
  final String timeAgo;
  final IconData icon;
  final Color iconColor;
  // final Color iconBackgroundColor;

  NotificationModel({
    required this.title,
    required this.description,
    required this.timeAgo,
    this.icon = Icons.notifications_outlined,
    this.iconColor = AppColors.primaryLight,
    // this.iconBackgroundColor = AppColors.primaryLight.withValues(alpha: 0.1),
  });
}

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;

  const NotificationCard({super.key, required this.notification, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
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
                color: AppColors.primaryLight.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  notification.icon,
                  color: notification.iconColor,
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
                    notification.description,
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
      ),
    );
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final Map<String, List<NotificationModel>> _groupedNotifications = {
    'Today': [
      NotificationModel(
        title: 'New Events added',
        description: 'New Events added',
        timeAgo: '5min ago',
      ),
      NotificationModel(
        title: 'New Events added',
        description: 'New Events added',
        timeAgo: '5min ago',
      ),
    ],
    'This week': [
      NotificationModel(
        title: 'New Events added',
        description: 'New Events added',
        timeAgo: '5min ago',
      ),
      NotificationModel(
        title: 'New Events added',
        description: 'New Events added',
        timeAgo: '5min ago',
      ),
    ],
    'Last month': [
      NotificationModel(
        title: 'New Events added',
        description: 'New Events added',
        timeAgo: '5min ago',
      ),
      NotificationModel(
        title: 'New Events added',
        description: 'New Events added',
        timeAgo: '5min ago',
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: const CustomAppBar(title: 'Notifications'),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _groupedNotifications.entries.map((entry) {
                    return _buildSection(entry.key, entry.value);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<NotificationModel> notifications) {
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
