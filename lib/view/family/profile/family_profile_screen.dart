import 'package:familyside/core/router/router_path.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/provider/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:familyside/view/family/profile/widgets/profile_stat_card.dart';
import 'package:familyside/view/family/profile/widgets/profile_svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FamilyProfileScreen extends ConsumerWidget {
  const FamilyProfileScreen({super.key});

  static const List<_ProfileSettingItem> _settings = [
    _ProfileSettingItem(
      title: 'Change Password',
      iconPath: "assets/icon/password.svg",
      routePath: RouterPath.familyChangePasswordScreen,
    ),
    _ProfileSettingItem(
      title: 'Edit Profile',
      iconPath: "assets/icon/edit_profile.svg",
      routePath: RouterPath.familyEditProfileScreen,
    ),
    _ProfileSettingItem(
      title: 'Child Information',
      iconPath: "assets/icon/child_info.svg",
      routePath: RouterPath.familyUpdateChildInformationScreen,
    ),
    _ProfileSettingItem(
      title: 'Privacy policy',
      iconPath: "assets/icon/privacy.svg",
      routePath: RouterPath.spPrivacyPolicyScreen,
    ),
    _ProfileSettingItem(
      title: 'Contact Support',
      iconPath: "assets/icon/customer-service.svg",
      routePath: RouterPath.familyContactSupportScreen,
    ),
    _ProfileSettingItem(
      title: 'Your Suggestions',
      iconPath: 'assets/icon/feedback.svg',
      routePath: RouterPath.familySuggestionScreen,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.profileHeaderBackground,
      body: Column(
        children: [
          const _ProfileHeader(),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _ProfileStatsRow(),
                    SizedBox(height: 24.h),
                    _GeneralSettingsSection(settings: _settings),
                    SizedBox(height: 16.h),
                    const _LogoutSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatarWithBadge extends StatelessWidget {
  final ThemeData theme;

  const _ProfileAvatarWithBadge({required this.theme});

  static const double _avatarSize = 120;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: (_avatarSize + 14).h,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          ClipOval(
            child: Image.asset(
              'assets/image/demo_image.jpg',
              width: _avatarSize.w,
              height: _avatarSize.w,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: _avatarSize.w,
                  height: _avatarSize.w,
                  color: AppColors.border,
                  child: ProfileSvgIcon(
                    iconPath: "assets/icon/edit_profile.svg",
                    width: 40.w,
                    height: 40.h,
                    color: AppColors.grey,
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: AppColors.profileHeaderBackground,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ProfileSvgIcon(
                      iconPath: "assets/icon/coin.svg",
                      width: 16.w,
                      height: 16.h,
                      // color: AppColors.accentYellow,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'Local Contributor',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onPrimaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      color: AppColors.profileHeaderBackground,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 28.h),
          child: Column(
            children: [
              _ProfileAvatarWithBadge(theme: theme),
              SizedBox(height: 12.h),
              Text(
                'You are among the most active families in your area',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.text,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: LinearProgressIndicator(
                        value: 0.6,
                        minHeight: 8.h,
                        backgroundColor: AppColors.progressTrack,
                        color: AppColors.primaryLight,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Top 9%',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileStatsRow extends StatelessWidget {
  const _ProfileStatsRow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ProfileStatCard(
            iconPath: "assets/icon/star.svg",            
            label: 'Reviews',
            value: '32',
          ),
          ProfileStatCard(
            iconPath: "assets/icon/activity.svg",
            // iconColor: AppColors.primaryLight,
            label: 'Activities',
            value: '12',
          ),
          ProfileStatCard(
            iconPath: "assets/icon/invited_family.svg",
            // iconColor: AppColors.primaryLight,
            label: 'Invited Family',
            value: '12',
          ),
          ProfileStatCard(
            iconPath: "assets/icon/wrapped-gift.svg",
            // iconColor: AppColors.accentYellow,
            label: 'Gifts Shared',
            value: '12',
          ),
        ],
      ),
    );
  }
}

class _GeneralSettingsSection extends StatelessWidget {
  final List<_ProfileSettingItem> settings;

  const _GeneralSettingsSection({required this.settings});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
            child: Text(
              'General settings',
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
          ),
          ...List.generate(settings.length, (index) {
            final item = settings[index];
            return Column(
              children: [
                _ProfileSettingsTile(
                  title: item.title,
                  iconPath: item.iconPath,
                  routePath: item.routePath,
                ),
                if (index < settings.length - 1)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.divider,
                    indent: 16.w,
                    endIndent: 16.w,
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _ProfileSettingsTile extends StatelessWidget {
  final String title;
  final String iconPath;
  final String? routePath;

  const _ProfileSettingsTile({
    required this.title,
    required this.iconPath,
    this.routePath,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: routePath != null ? () => context.push(routePath!) : null,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            children: [
              ProfileSvgIcon(
                iconPath: iconPath,
                width: 22.w,
                height: 22.h,
                color: AppColors.text,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.text,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 22.sp,
                color: AppColors.mutedIcon,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileSettingItem {
  final String title;
  final String iconPath;
  final String? routePath;

  const _ProfileSettingItem({
    required this.title,
    required this.iconPath,
    this.routePath,
  });
}

class _LogoutSection extends ConsumerWidget {
  const _LogoutSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showLogoutDialog(context, ref),
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              children: [
                Icon(
                  Icons.logout,
                  size: 22.sp,
                  color: AppColors.error,
                ),
                SizedBox(width: 12.w),
                Text(
                  'Log Out',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: AppColors.surfaceLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.logout,
                size: 48.sp,
                color: AppColors.error,
              ),
              SizedBox(height: 16.h),
              Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Are you sure you want to log out?',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.lightText,
                ),
              ),
              SizedBox(height: 24.h),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Expanded(
                    child: _DialogButton(
                      label: 'Cancel',
                      onTap: () => Navigator.of(ctx).pop(),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _DialogButton(
                      label: 'Log Out',
                      isDestructive: true,
                      onTap: () async {
                        Navigator.of(ctx).pop();
                        await ref.read(authProvider.notifier).logout();
                        if (context.mounted) {
                          context.go(RouterPath.onBoardingScreen);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDestructive ? AppColors.error : AppColors.surface,
          borderRadius: BorderRadius.circular(8.r),
          border: isDestructive
              ? null
              : Border.all(color: AppColors.border),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.h),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isDestructive ? Colors.white : AppColors.text,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
