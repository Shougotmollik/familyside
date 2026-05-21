import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/view/family/home/family_home_screen.dart';
import 'package:familyside/view/family/explorer/explorer_screen.dart';
import 'package:familyside/view/family/search/search_screen.dart';
import 'package:familyside/view/family/gift/gift_screen.dart';
import 'package:familyside/view/family/profile/family_profile_screen.dart';

class FamilyMainNavBarScreen extends StatefulWidget {
  const FamilyMainNavBarScreen({super.key});

  @override
  State<FamilyMainNavBarScreen> createState() => _FamilyMainNavBarScreenState();
}

class _FamilyMainNavBarScreenState extends State<FamilyMainNavBarScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    FamilyHomeScreen(),
    ExplorerScreen(),
    SearchScreen(),
    GiftScreen(),
    FamilyProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
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
                top: BorderSide(
                  color: Color(0xFFE5E5E5),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                _buildNavItem(0, 'Home', 'assets/icon/Home.svg'),
                _buildNavItem(1, 'Explore', 'assets/icon/explore.svg'),
                _buildNavItem(2, 'Search', 'assets/icon/search.svg'),
                _buildNavItem(3, 'Gift', 'assets/icon/gift.svg'),
                _buildNavItem(4, 'Profile', 'assets/icon/profile.svg'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label, String iconPath) {
    final isSelected = _selectedIndex == index;
    final color = isSelected ? AppColors.primaryLight : const Color(0xFF9EA3AE);

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
                child: Container(
                  height: 3.h,
                  color: AppColors.primaryLight,
                ),
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