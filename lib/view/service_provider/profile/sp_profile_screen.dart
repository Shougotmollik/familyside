import 'package:familyside/core/config/credential.dart';
import 'package:familyside/core/localization/app_localizations.dart';
import 'package:familyside/core/localization/language_provider.dart';
import 'package:familyside/model/provider_profile_data.dart';
import 'package:familyside/provider/service_provider/sp_profile_provider.dart';
import 'package:familyside/view/widgets/language_picker_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/core/router/router_path.dart';
import 'package:familyside/provider/auth_provider.dart';
import 'package:familyside/view/family/profile/widgets/profile_svg_icon.dart';

class SpProfileScreen extends ConsumerStatefulWidget {
  const SpProfileScreen({super.key});

  @override
  ConsumerState<SpProfileScreen> createState() => _SpProfileScreenState();
}

class _SpProfileScreenState extends ConsumerState<SpProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Auto-retry on first load: if the provider has stale/null data,
    // refresh it after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final current = ref.read(spProfileProvider);
      if (current is AsyncData && current.value == null) {
        ref.invalidate(spProfileProvider);
      }
    });
  }

  static const List<_SettingItem> _settings = [
    _SettingItem(
      title: 'changePassword',
      iconPath: 'assets/icon/password.svg',
      routePath: RouterPath.spChangePasswordScreen,
    ),
    _SettingItem(
      title: 'editProfile',
      iconPath: 'assets/icon/edit_profile.svg',
      routePath: RouterPath.spEditProfileScreen,
    ),
    _SettingItem(
      title: 'subscription',
      iconPath: 'assets/icon/subscriptions.svg',
      routePath: RouterPath.spSubscriptionScreen,
    ),
    _SettingItem(
      title: 'privacyPolicy',
      iconPath: 'assets/icon/privacy.svg',
      routePath: RouterPath.spPrivacyPolicyScreen,
    ),
    _SettingItem(
      title: 'contactSupport',
      iconPath: 'assets/icon/customer-service.svg',
      routePath: RouterPath.spContactSupportScreen,
    ),
    _SettingItem(
      title: 'yourSuggestions',
      iconPath: 'assets/icon/feedback.svg',
      routePath: RouterPath.spSuggestionScreen,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final profileAsync = ref.watch(spProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.profileHeaderBackground,
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return _buildNullState(context);
          }
          return _buildProfileContent(context, profile);
        },
        error: (err, stack) {
          debugPrint('Error: $err');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(loc.translate('errorLoadingProfile')),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () => ref.refresh(spProfileProvider.future),
                  child: Text(loc.translate('retry')),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildNullState(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline,
            size: 64.sp,
            color: AppColors.mutedIcon,
          ),
          SizedBox(height: 16.h),
          Text(
            loc.translate('errorLoadingProfile'),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.lightText,
                ),
          ),
          SizedBox(height: 16.h),
          ElevatedButton.icon(
            onPressed: () => ref.refresh(spProfileProvider.future),
            icon: const Icon(Icons.refresh, size: 18),
            label: Text(loc.translate('retry')),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent(
      BuildContext context, ProviderProfileData profile) {
    return RefreshIndicator(
      onRefresh: () => ref.refresh(spProfileProvider.future),
      child: Column(
        children: [
          _SpProfileHeader(profile: profile),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24.r),
                ),
              ),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    _GeneralSettingsSection(settings: _settings),
                    SizedBox(height: 16.h),
                    _LanguageSection(),
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
  const _SpProfileHeader({required this.profile});
  final ProviderProfileData profile;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
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
              _AvatarWithBadge(theme: theme, imageUrl: profile.imageUrl),
              SizedBox(height: 12.h),
              Text(
                profile.name ?? loc.translate('loading'),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                profile.location ?? '',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.lightText,
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: LinearProgressIndicator(
                        value: (profile.stats?.progressPercentage ?? 0)
                            .toDouble()
                            .clamp(0.0, 1.0),
                        minHeight: 8.h,
                        backgroundColor: AppColors.progressTrack,
                        color: AppColors.primaryLight,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    '${((profile.stats?.progressPercentage ?? 0) * 100).toInt()}%',
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
  const _AvatarWithBadge({required this.theme, this.imageUrl});
  final ThemeData theme;
  final String? imageUrl;

  static const double _size = 120;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return SizedBox(
      width: double.infinity,
      height: (_size + 14).h,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          ClipOval(
            child: imageUrl != null && imageUrl!.isNotEmpty
                ? Image.network(
                    AppCredentials.fixurl(imageUrl!),
                    width: _size.w,
                    height: _size.w,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: _size.w,
                    height: _size.w,
                    color: AppColors.border,
                    child: Icon(
                      Icons.person,
                      color: AppColors.grey,
                      size: 36.sp,
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
                    loc.translate('localContributor'),
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



class _GeneralSettingsSection extends StatelessWidget {
  const _GeneralSettingsSection({required this.settings});
  final List<_SettingItem> settings;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
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
              loc.translate('generalSettings'),
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
                  title: loc.translate(item.title),
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

class _LanguageSection extends ConsumerWidget {
  const _LanguageSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);
    final currentLocale = ref.watch(languageProvider);
    final languageName =
        currentLocale.languageCode == 'it' ? 'Italiano' : 'English';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => showLanguagePicker(context, ref),
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              children: [
                Icon(Icons.language, size: 22.sp, color: AppColors.text),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    loc.translate('language'),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.text,
                    ),
                  ),
                ),
                Text(
                  languageName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.lightText,
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 22.sp,
                  color: AppColors.mutedIcon,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoutSection extends ConsumerWidget {
  const _LogoutSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context);
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
                Icon(Icons.logout, size: 22.sp, color: AppColors.error),
                SizedBox(width: 12.w),
                Text(
                  loc.translate('logOut'),
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
    final loc = AppLocalizations.of(context);
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
                loc.translate('logOut'),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                loc.translate('areYouSureLogOut'),
                style: TextStyle(fontSize: 14.sp, color: AppColors.lightText),
              ),
              SizedBox(height: 32.h),
              Row(
                children: [
                  Expanded(
                    child: _DialogButton(
                      label: loc.translate('cancel'),
                      onTap: () => Navigator.of(ctx).pop(),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _DialogButton(
                      label: loc.translate('logOut'),
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
