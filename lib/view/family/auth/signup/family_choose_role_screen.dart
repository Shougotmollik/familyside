import 'package:familyside/provider/onboarding_controller.dart';
import 'package:familyside/view/widgets/role_selection_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/core/router/router_path.dart';

class FamilyChooseRoleScreen extends ConsumerStatefulWidget {
  const FamilyChooseRoleScreen({super.key});

  @override
  ConsumerState<FamilyChooseRoleScreen> createState() => _FamilyChooseRoleScreenState();
}

class _FamilyChooseRoleScreenState extends ConsumerState<FamilyChooseRoleScreen> {
  String _selectedRole = 'Mother';

  Future<void> _onRoleSelected(String role) async {
    setState(() => _selectedRole = role);
    await ref.read(onboardingProvider.notifier).setRole(role: role);
    if (mounted) {
      context.push(RouterPath.familyChildInformationScreen);
    }
  }

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
                onTap: () => _onRoleSelected('Mother'),
              ),
              SizedBox(height: 16.h),
              RoleSelectionButton(
                title: 'Father',
                icon: 'assets/logo/father.svg',
                isSelected: _selectedRole == 'Father',
                onTap: () => _onRoleSelected('Father'),
              ),
              SizedBox(height: 16.h),
              RoleSelectionButton(
                title: 'Relative',
                icon: 'assets/logo/relative.svg',
                isSelected: _selectedRole == 'Relative',
                onTap: () => _onRoleSelected('Relative'),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

