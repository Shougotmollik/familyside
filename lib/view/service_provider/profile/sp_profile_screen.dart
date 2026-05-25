import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/core/router/router_path.dart';
import 'package:familyside/view/family/profile/widgets/profile_stat_card.dart';
import 'package:familyside/view/family/profile/widgets/profile_svg_icon.dart';

class SpProfileScreen extends StatelessWidget {
  const SpProfileScreen({super.key});

  static const List<_SettingItem> _settings = [
    _SettingItem(
      title: 'Change Password',
      iconPath: 'assets/icon/password.svg',
      routePath: RouterPath.spChangePasswordScreen,
    ),
    _SettingItem(
      title: 'Edit Profile',
      iconPath: 'assets/icon/edit_profile.svg',
      routePath: RouterPath.spEditProfileScreen,
    ),
    _SettingItem(
      title: 'Subscription',
      iconPath: 'assets/icon/subscriptions.svg',
      routePath: RouterPath.spSubscriptionScreen,
    ),
    _SettingItem(
      title: 'Privacy policy',
      iconPath: 'assets/icon/privacy.svg',
      routePath: RouterPath.spPrivacyPolicyScreen,
    ),
    _SettingItem(
      title: 'Contact Support',
      iconPath: 'assets/icon/customer-service.svg',
      routePath: RouterPath.spContactSupportScreen,
    ),
    _SettingItem(
      title: 'Your Suggestions',
      iconPath: 'assets/icon/feedback.svg',
      routePath: RouterPath.spSuggestionScreen,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.profileHeaderBackground,
      body: Column(
        children: [
          const _SpProfileHeader(),
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
                    _SpStatsRow(),
                    SizedBox(height: 16.h),
                    _ContributeSection(),
                    SizedBox(height: 16.h),
                    _GeneralSettingsSection(settings: _settings),
                    SizedBox(height: 16.h),
                    _LogoutSection(),
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

class _SpProfileHeader extends StatelessWidget {
  const _SpProfileHeader();

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
              _AvatarWithBadge(theme: theme),
              SizedBox(height: 12.h),
              Text(
                'You are among the most active\nfamilies in your area',
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

class _AvatarWithBadge extends StatelessWidget {
  const _AvatarWithBadge({required this.theme});
  final ThemeData theme;

  static const double _size = 120;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: (_size + 14).h,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          ClipOval(
            child: Image.asset(
              'assets/image/demo_image.jpg',
              width: _size.w,
              height: _size.w,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: _size.w,
                height: _size.w,
                color: AppColors.border,
                child: Icon(Icons.person, color: AppColors.grey, size: 36.sp),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
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
                    iconPath: 'assets/icon/coin.svg',
                    width: 16.w,
                    height: 16.h,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'Local Contributor',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpStatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ProfileStatCard(
            iconPath: 'assets/icon/star.svg',
            label: 'Reviews',
            value: '32',
          ),
          ProfileStatCard(
            iconPath: 'assets/icon/activity.svg',
            label: 'Activities',
            value: '12',
          ),
          ProfileStatCard(
            iconPath: 'assets/icon/invited_family.svg',
            label: 'Invited Family',
            value: '12',
          ),
          ProfileStatCard(
            iconPath: 'assets/icon/wrapped-gift.svg',
            label: 'Gifts Shared',
            value: '12',
          ),
        ],
      ),
    );
  }
}

class _ContributeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.progressTrack.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            'Contribute and Grow Your Level',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.text,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              _ContributeButton(
                label: 'Add Event',
                onTap: () => context.push(RouterPath.spCreateEventScreen),
              ),
              SizedBox(width: 8.w),
              _ContributeButton(
                label: 'Add Activity',
                onTap: () => context.push(RouterPath.spCreateActivityScreen),
              ),
              SizedBox(width: 8.w),
              _ContributeButton(label: 'Leave Review', onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContributeButton extends StatelessWidget {
  const _ContributeButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: AppColors.primaryLight.withValues(alpha: 0.4),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryLight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GeneralSettingsSection extends StatelessWidget {
  const _GeneralSettingsSection({required this.settings});
  final List<_SettingItem> settings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
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
          ...List.generate(settings.length, (i) {
            final item = settings[i];
            return Column(
              children: [
                _SettingTile(
                  title: item.title,
                  iconPath: item.iconPath,
                  routePath: item.routePath,
                ),
                if (i < settings.length - 1)
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

class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.title,
    required this.iconPath,
    this.routePath,
  });
  final String title;
  final String iconPath;
  final String? routePath;

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

class _LogoutSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          onTap: () => _showLogoutDialog(context),
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              children: [
                Icon(Icons.logout, size: 22.sp, color: AppColors.error),
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

  void _showLogoutDialog(BuildContext context) {
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
              Icon(Icons.logout, size: 48.sp, color: AppColors.error),
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
                style: TextStyle(fontSize: 14.sp, color: AppColors.lightText),
              ),
              SizedBox(height: 32.h),
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
                      onTap: () {
                        Navigator.of(ctx).pop();
                        context.go(RouterPath.onBoardingScreen);
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
          border: isDestructive ? null : Border.all(color: AppColors.border),
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

class _SettingItem {
  final String title;
  final String iconPath;
  final String? routePath;
  const _SettingItem({
    required this.title,
    required this.iconPath,
    this.routePath,
  });
}
