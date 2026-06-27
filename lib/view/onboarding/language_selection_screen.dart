import 'package:familyside/core/localization/app_localizations.dart';
import 'package:familyside/core/localization/language_provider.dart';
import 'package:familyside/core/router/router_path.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class LanguageSelectionScreen extends ConsumerWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);
    final currentLocale = ref.watch(languageProvider);

    return Scaffold(
      backgroundColor: AppColors.profileHeaderBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 40.h),
              SvgPicture.asset(
                'assets/logo/app_logo.svg',
                height: 80.h,
                colorFilter: ColorFilter.mode(
                  AppColors.primaryLight,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                loc.translate('brandName'),
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontFamily: 'Quando',
                  fontSize: 28.sp,
                  color: AppColors.text,
                ),
              ),
              SizedBox(height: 48.h),
              Text(
                loc.translate('chooseLanguage'),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 22.sp,
                  color: AppColors.text,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                loc.translate('selectPreferredLanguage'),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.lightText,
                ),
              ),
              SizedBox(height: 40.h),
              _LanguageOption(
                flag: '\uD83C\uDDFA\uD83C\uDDF8',
                label: 'English',
                isSelected: currentLocale.languageCode == 'en',
                onTap: () {
                  ref.read(languageProvider.notifier).changeLanguage(const Locale('en'));
                },
              ),
              SizedBox(height: 16.h),
              _LanguageOption(
                flag: '\uD83C\uDDEE\uD83C\uDDF9',
                label: 'Italiano',
                isSelected: currentLocale.languageCode == 'it',
                onTap: () {
                  ref.read(languageProvider.notifier).changeLanguage(const Locale('it'));
                },
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: () {
                    context.go(RouterPath.onBoardingScreen);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryLight,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.r),
                    ),
                  ),
                  child: Text(
                    loc.translate('continueText'),
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              GestureDetector(
                onTap: () {
                  ref.read(languageProvider.notifier).changeLanguage(const Locale('en'));
                  context.go(RouterPath.onBoardingScreen);
                },
                child: Text(
                  loc.translate('skip'),
                  style: TextStyle(
                    color: AppColors.lightText,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.flag,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String flag;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryLight.withValues(alpha: 0.08)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryLight : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              flag,
              style: TextStyle(fontSize: 32.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                size: 24.sp,
                color: AppColors.primaryLight,
              )
            else
              Icon(
                Icons.circle_outlined,
                size: 24.sp,
                color: AppColors.border,
              ),
          ],
        ),
      ),
    );
  }
}
