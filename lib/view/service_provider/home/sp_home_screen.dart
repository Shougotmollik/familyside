import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/core/router/router_path.dart';
import 'package:familyside/view/widgets/custom_icon_button.dart';
import 'package:familyside/view/service_provider/home/widgets/sp_event_card.dart';
import 'package:go_router/go_router.dart';

class _SpEventModel {
  final String imagePath;
  final String category;
  final String title;
  final String price;
  final String distance;
  final String ageRange;
  final String date;
  final String tag;

  const _SpEventModel({
    required this.imagePath,
    required this.category,
    required this.title,
    required this.price,
    required this.distance,
    required this.ageRange,
    required this.date,
    required this.tag,
  });
}

class SpHomeScreen extends StatefulWidget {
  const SpHomeScreen({super.key});

  @override
  State<SpHomeScreen> createState() => _SpHomeScreenState();
}

class _SpHomeScreenState extends State<SpHomeScreen> {
  static const List<_SpEventModel> _upcomingEvents = [
    _SpEventModel(
      imagePath: 'assets/image/onboarding 1.jpg',
      category: 'Birthday',
      title: 'Birthday Party',
      price: '20',
      distance: '0.05 km',
      ageRange: 'Age: 0-20 years',
      date: '25 June, 2026',
      tag: 'Event',
    ),
    _SpEventModel(
      imagePath: 'assets/image/onboarding 2.jpg',
      category: 'Birthday',
      title: 'Birthday Party',
      price: '20',
      distance: '0.05 km',
      ageRange: 'Age: 0-20 years',
      date: '25 June, 2026',
      tag: 'Event',
    ),
  ];

  static const List<_SpEventModel> _topServices = [
    _SpEventModel(
      imagePath: 'assets/image/onboarding 3.jpg',
      category: 'Activity',
      title: 'Birthday Party',
      price: '20',
      distance: '0.05 km',
      ageRange: 'Age: 0-20 years',
      date: '25 June, 2026',
      tag: 'Activity',
    ),
    _SpEventModel(
      imagePath: 'assets/image/onboarding 4.jpg',
      category: 'Birthday',
      title: 'Birthday Party',
      price: '20',
      distance: '0.05 km',
      ageRange: 'Age: 0-20 years',
      date: '25 June, 2026',
      tag: 'Event',
    ),
    _SpEventModel(
      imagePath: 'assets/image/onboarding 1.jpg',
      category: 'Birthday',
      title: 'Birthday Party',
      price: '20',
      distance: '0.05 km',
      ageRange: 'Age: 0-20 years',
      date: '25 June, 2026',
      tag: 'Event',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 24.h),
              _buildSectionHeader('Upcoming events', onSeeAll: () {}),
              SizedBox(height: 12.h),
              ..._upcomingEvents.map(
                (e) => SpEventCard(
                  imagePath: e.imagePath,
                  category: e.category,
                  title: e.title,
                  price: e.price,
                  distance: e.distance,
                  ageRange: e.ageRange,
                  date: e.date,
                  tag: e.tag,
                ),
              ),
              SizedBox(height: 8.h),
              _buildSectionHeader('Top service', onSeeAll: () {}),
              SizedBox(height: 12.h),
              ..._topServices.map(
                (e) => SpEventCard(
                  imagePath: e.imagePath,
                  category: e.category,
                  title: e.title,
                  price: e.price,
                  distance: e.distance,
                  ageRange: e.ageRange,
                  date: e.date,
                  tag: e.tag,
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Avatar
        ClipOval(
          child: Image.asset(
            'assets/image/demo_image.jpg',
            width: 52.w,
            height: 52.w,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 52.w,
              height: 52.w,
              color: Colors.grey.shade300,
              child: Icon(Icons.person, color: Colors.grey, size: 24.sp),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        // Name + location
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back Shahid',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              SizedBox(height: 3.h),
              Row(
                children: [
                  Text(
                    'Dhaka, Bangladesh',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.lightText,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  SvgPicture.asset(
                    'assets/logo/edit.svg',
                    width: 13.w,
                    height: 13.w,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primaryLight,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Notification bell
        Stack(
          clipBehavior: Clip.none,
          children: [
            CustomIconButton(
              assetPath: 'assets/logo/notification.svg',
              onTap: () => context.push(RouterPath.familyNotificationScreen),
            ),
            Positioned(
              top: -2.h,
              right: -2.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {required VoidCallback onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
        GestureDetector(
          onTap: onSeeAll,
          child: Text(
            'See All',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryLight,
            ),
          ),
        ),
      ],
    );
  }
}
