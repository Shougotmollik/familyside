import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/core/router/router_path.dart';

class FamilyChooseRoleScreen extends StatefulWidget {
  const FamilyChooseRoleScreen({super.key});

  @override
  State<FamilyChooseRoleScreen> createState() => _FamilyChooseRoleScreenState();
}

class _FamilyChooseRoleScreenState extends State<FamilyChooseRoleScreen> {
  String _selectedRole = 'Mother';

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
              SizedBox(height: 200.h),
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
              Text(
                'Choose Your Role',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 50.h),
              RoleSelectionButton(
                title: 'Mother',
                icon: 'assets/logo/mother.svg',
                isSelected: _selectedRole == 'Mother',
                onTap: () {
                  setState(() {
                    _selectedRole = 'Mother';
                  });
                  context.push(RouterPath.familyChildInformationScreen);
                },
              ),
              SizedBox(height: 16.h),
              RoleSelectionButton(
                title: 'Father',
                icon: 'assets/logo/father.svg',
                isSelected: _selectedRole == 'Father',
                onTap: () {
                  setState(() {
                    _selectedRole = 'Father';
                  });
                  context.push(RouterPath.familyChildInformationScreen);
                },
              ),
              SizedBox(height: 16.h),
              RoleSelectionButton(
                title: 'Relative',
                icon: 'assets/logo/relative.svg',
                isSelected: _selectedRole == 'Relative',
                onTap: () {
                  setState(() {
                    _selectedRole = 'Relative';
                  });
                  context.push(RouterPath.familyChildInformationScreen);
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

class RoleSelectionButton extends StatelessWidget {
  final String title;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleSelectionButton({
    super.key,
    required this.title,
    required this.icon,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : Colors.transparent,
          borderRadius: BorderRadius.circular(50.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryLight : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              colorFilter: ColorFilter.mode(
                isSelected ? Colors.white : AppColors.text,
                BlendMode.srcIn,
              ),
              height: 24.h,
            ),
            SizedBox(width: 12.w),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
