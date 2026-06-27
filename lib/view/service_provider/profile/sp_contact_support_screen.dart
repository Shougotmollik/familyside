import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:familyside/core/localization/app_localizations.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/view/widgets/auth_text_form_field.dart';
import 'package:familyside/view/widgets/custom_app_bar.dart';
import 'package:familyside/view/widgets/custom_elevated_button.dart';

class SpContactSupportScreen extends StatefulWidget {
  const SpContactSupportScreen({super.key});

  @override
  State<SpContactSupportScreen> createState() => _SpContactSupportScreenState();
}

class _SpContactSupportScreenState extends State<SpContactSupportScreen> {
  final _subjectCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();

  @override
  void dispose() {
    _subjectCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomAppBar(title: loc.translate('contactSupport')),
                    SizedBox(height: 28.h),
                    // Info card
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.primaryLight.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.headset_mic_outlined,
                            color: AppColors.primaryLight,
                            size: 28.sp,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  loc.translate('wereHereToHelp'),
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.text,
                                      ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  loc.translate('teamRespondsWithin24'),
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: AppColors.lightText),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 28.h),
                    _label(loc.translate('subject')),
                    SizedBox(height: 8.h),
                    AuthTextFormField(
                      hintText: loc.translate('enterSubject'),
                      controller: _subjectCtrl,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 16.h),
                    _label(loc.translate('message')),
                    SizedBox(height: 8.h),
                    AuthTextFormField(
                      hintText: loc.translate('describeIssue'),
                      controller: _messageCtrl,
                      maxLines: 6,
                      minLines: 5,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
              child: CustomElevatedButton(
                onPressed: () {},
                title: loc.translate('sendMessage'),
                color: AppColors.primaryLight,
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w500,
      color: AppColors.lightText,
    ),
  );
}
