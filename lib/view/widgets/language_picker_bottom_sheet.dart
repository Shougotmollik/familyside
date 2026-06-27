import 'package:familyside/core/localization/app_localizations.dart';
import 'package:familyside/core/localization/language_provider.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showLanguagePicker(BuildContext context, WidgetRef ref) {
  final currentLocale = ref.read(languageProvider);
  final loc = AppLocalizations.of(context);

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              loc.translate('language'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
            SizedBox(height: 20.h),
            _LanguageOption(
              label: loc.translate('english'),
              subtitle: 'English',
              isSelected: currentLocale.languageCode == 'en',
              onTap: () {
                ref
                    .read(languageProvider.notifier)
                    .changeLanguage(const Locale('en'));
                Navigator.of(ctx).pop();
              },
            ),
            SizedBox(height: 8.h),
            _LanguageOption(
              label: loc.translate('italian'),
              subtitle: 'Italiano',
              isSelected: currentLocale.languageCode == 'it',
              onTap: () {
                ref
                    .read(languageProvider.notifier)
                    .changeLanguage(const Locale('it'));
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
    },
  );
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryLight.withValues(alpha: 0.08)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryLight : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                      fontSize: 15.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.lightText,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                size: 22.sp,
                color: AppColors.primaryLight,
              )
            else
              Icon(
                Icons.radio_button_unchecked,
                size: 22.sp,
                color: AppColors.border,
              ),
          ],
        ),
      ),
    );
  }
}
