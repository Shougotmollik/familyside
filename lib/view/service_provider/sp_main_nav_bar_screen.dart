import 'package:familyside/view/service_provider/analytics/sp_analytics_screen.dart';
import 'package:familyside/view/service_provider/create_section/sp_create_screen.dart';
import 'package:familyside/view/service_provider/home/sp_home_screen.dart';
import 'package:familyside/view/service_provider/manage/sp_manage_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:flutter_svg/svg.dart';

class SpMainNavBarScreen extends StatefulWidget {
  const SpMainNavBarScreen({super.key});

  @override
  State<SpMainNavBarScreen> createState() => _SpMainNavBarScreenState();
}

class _SpMainNavBarScreenState extends State<SpMainNavBarScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    SpHomeScreen(),
    SpManageScreen(),
    SpCreateScreen(),
    SpAnalyticsScreen(),
    _SpProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Container(
            height: 70.h,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.navBorder, width: 1),
              ),
            ),
            child: Row(
              children: [
                _buildNavItem(0, 'Home', "assets/icon/Home.svg"),
                _buildNavItem(1, 'Manage', "assets/icon/hugeicons_work.svg"),
                _buildNavItem(2, 'Create', "assets/icon/add-outline.svg"),
                _buildNavItem(
                  3,
                  'Analytics',
                  "assets/icon/hugeicons_activity.svg",
                ),
                _buildNavItem(4, 'Profile', "assets/icon/profile.svg"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label, String iconPath) {
    final isSelected = _selectedIndex == index;
    final color = isSelected ? AppColors.primaryLight : AppColors.mutedIcon;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        behavior: HitTestBehavior.opaque,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isSelected)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(height: 3.h, color: AppColors.primaryLight),
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  iconPath,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                  height: 24.h,
                  width: 24.w,
                ),
                SizedBox(height: 6.h),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SpProfileScreen extends StatelessWidget {
  const _SpProfileScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('Profile - Placeholder')),
    );
  }
}
