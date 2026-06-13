import 'package:cached_network_image/cached_network_image.dart';
import 'package:familyside/model/provider_feed.dart';
import 'package:familyside/model/sp_home_header.dart';
import 'package:familyside/view/service_provider/home/sp_see_all_screen.dart';
import 'package:familyside/view/service_provider/home/widgets/sp_home_skeleton.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/core/router/router_path.dart';
import 'package:familyside/provider/service_provider/sp_home_provider.dart';
import 'package:familyside/view/widgets/custom_icon_button.dart';
import 'package:familyside/view/service_provider/home/widgets/sp_event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SpHomeScreen extends ConsumerStatefulWidget {
  const SpHomeScreen({super.key});

  @override
  ConsumerState<SpHomeScreen> createState() => _SpHomeScreenState();
}

class _SpHomeScreenState extends ConsumerState<SpHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(spHomeProviderProvider.notifier).fetchSpHomeFeed();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(spHomeProviderProvider);

    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: SafeArea(
        child: state.when(
          loading: () => const SpHomeSkeleton(),
          error: (err, stack) {
            debugPrint('Error loading home feed: $err');
            return const SizedBox.shrink();
          },
          data: (data) {
            final feed = data['feed'] as ProviderFeed;
            final header = data['header'] as SpHomeHeader? ??
                SpHomeHeader(
                  name: 'User',
                  profileImageUrl: null,
                  location: 'Location not set',
                  unreadNotifications: 0,
                );
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(header),
                  SizedBox(height: 24.h),
                  _buildSectionHeader(
                    'Upcoming events',
                    onSeeAll: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SpSeeAllScreen(
                            title: 'Upcoming events',
                            items: feed.upcomingEvents,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 12.h),
                  if (feed.upcomingEvents.isEmpty)
                    Container(
                      margin: EdgeInsets.only(bottom: 14.h),
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      alignment: Alignment.center,
                      child: Text(
                        'No upcoming events found',
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 14.sp,
                        ),
                      ),
                    )
                  else
                    ...feed.upcomingEvents
                        .take(2)
                        .map(
                          (e) => SpEventCard(
                            imagePath: e.imageUrl ?? '',
                            category: e.categoryLabel,
                            title: e.name,
                            price: e.price.toStringAsFixed(0),
                            distance: '${e.distanceKm} km',
                            ageRange: e.ageRange,
                            date: e.dateLabel,
                            tag: e.itemType,
                          ),
                        ),
                  SizedBox(height: 8.h),
                  _buildSectionHeader(
                    'Top service',
                    onSeeAll: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SpSeeAllScreen(
                            title: 'Top service',
                            items: feed.topServices,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 12.h),
                  if (feed.topServices.isEmpty)
                    Container(
                      margin: EdgeInsets.only(bottom: 14.h),
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      alignment: Alignment.center,
                      child: Text(
                        'No top services found',
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 14.sp,
                        ),
                      ),
                    )
                  else
                    ...feed.topServices
                        .take(3)
                        .map(
                          (e) => SpEventCard(
                            imagePath: e.imageUrl ?? '',
                            category: e.categoryLabel,
                            title: e.name,
                            price: e.price.toStringAsFixed(0),
                            distance: '${e.distanceKm} km',
                            ageRange: e.ageRange,
                            date: e.dateLabel,
                            tag: e.itemType,
                          ),
                        ),
                  SizedBox(height: 16.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(SpHomeHeader header) {
    return Row(
      children: [
        // Avatar
        ClipOval(
          child: CachedNetworkImage(
            imageUrl: header.profileImageUrl ?? '',
            width: 52.w,
            height: 52.w,
            fit: BoxFit.cover,
            errorWidget: (_, __, ___) => Container(
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
                'Welcome back ${header.name.split(' ').first}',
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
                    header.location,
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
            if (header.unreadNotifications > 0)
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
                    header.unreadNotifications.toString(),
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
