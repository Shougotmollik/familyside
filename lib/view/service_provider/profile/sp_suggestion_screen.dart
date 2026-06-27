import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:familyside/core/localization/app_localizations.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/view/widgets/auth_text_form_field.dart';
import 'package:familyside/view/widgets/custom_app_bar.dart';
import 'package:familyside/view/widgets/custom_elevated_button.dart';

class SpSuggestionScreen extends StatefulWidget {
  const SpSuggestionScreen({super.key});

  @override
  State<SpSuggestionScreen> createState() => _SpSuggestionScreenState();
}

class _SpSuggestionScreenState extends State<SpSuggestionScreen> {
  final _titleCtrl = TextEditingController();
  final _suggestionCtrl = TextEditingController();
  String _selectedType = 'featureRequest';

  final List<String> _types = [
    'featureRequest',
    'bugReport',
    'uiImprovement',
    'other',
  ];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _suggestionCtrl.dispose();
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
                    CustomAppBar(title: loc.translate('yourSuggestions')),
                    SizedBox(height: 28.h),
                    _label(loc.translate('type')),
                    SizedBox(height: 10.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: _types.map((t) {
                        final sel = _selectedType == t;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedType = t),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: sel
                                  ? AppColors.primaryLight
                                  : AppColors.primaryLight.withValues(
                                      alpha: 0.08,
                                    ),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              loc.translate(t),
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: sel
                                    ? Colors.white
                                    : AppColors.primaryLight,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20.h),
                    _label(loc.translate('title')),
                    SizedBox(height: 8.h),
                    AuthTextFormField(
                      hintText: loc.translate('enterShortTitle'),
                      controller: _titleCtrl,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 16.h),
                    _label(loc.translate('suggestion')),
                    SizedBox(height: 8.h),
                    AuthTextFormField(
                      hintText: loc.translate('describeSuggestion'),
                      controller: _suggestionCtrl,
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
                title: loc.translate('submit'),
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
