import 'package:familyside/core/router/router_path.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/view/widgets/role_selection_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class SpCreateScreen extends StatefulWidget {
  const SpCreateScreen({super.key});

  @override
  State<SpCreateScreen> createState() => _SpCreateScreenState();
}

class _SpCreateScreenState extends State<SpCreateScreen> {
  String _selectedOption = 'Activities';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 150.h),
              SvgPicture.asset(
                'assets/logo/app_logo.svg',
                height: 90.h,
                colorFilter: ColorFilter.mode(
                  theme.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Familyside',
                style: TextStyle(
                  fontFamily: 'Quando',
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.text,
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: 280.w,
                child: Text(
                  'What Would You Like to Create?',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              SizedBox(
                width: 340.w,
                child: Text(
                  "Select whether you want to create an activity or an event.",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: AppColors.lightText,
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              RoleSelectionButton(
                title: 'Activities',
                icon: 'assets/icon/hugeicons_work.svg',
                isSelected: _selectedOption == 'Activities',
                onTap: () {
                  setState(() => _selectedOption = 'Activities');
                  context.push(RouterPath.spCreateActivityScreen);
                },
              ),
              SizedBox(height: 16.h),
              RoleSelectionButton(
                title: 'Events',
                icon: 'assets/icon/activity_icon.svg',
                isSelected: _selectedOption == 'Events',
                onTap: () {
                  setState(() => _selectedOption = 'Events');
                  context.push(RouterPath.spCreateEventScreen);
                },
              ),
              SizedBox(height: 16.h),
              RoleSelectionButton(
                title: 'Gift',
                icon: 'assets/icon/gift_icon.svg',
                isSelected: _selectedOption == 'Gift',
                onTap: () {
                  setState(() => _selectedOption = 'Gift');
                  context.push(RouterPath.spCreateGiftScreen);
                },
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
