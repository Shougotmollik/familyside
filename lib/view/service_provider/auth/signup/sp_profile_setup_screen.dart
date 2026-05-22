import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/core/router/router_path.dart';
import 'package:familyside/view/widgets/custom_app_bar.dart';
import 'package:familyside/view/widgets/custom_elevated_button.dart';
import 'package:familyside/view/widgets/auth_text_form_field.dart';

class SpProfileSetupScreen extends StatefulWidget {
  const SpProfileSetupScreen({super.key});

  @override
  State<SpProfileSetupScreen> createState() => _SpProfileSetupScreenState();
}

class _SpProfileSetupScreenState extends State<SpProfileSetupScreen> {
  // Each entry: { 'platform': String?, 'link': TextEditingController }
  final List<Map<String, dynamic>> _socialEntries = [];

  final List<String> _platforms = [
    'Facebook',
    'Instagram',
    'Twitter',
    'LinkedIn',
    'YouTube',
    'TikTok',
    'Pinterest',
    'Snapchat',
  ];

  @override
  void initState() {
    super.initState();
    _addEntry(); // start with one entry
  }

  @override
  void dispose() {
    for (final entry in _socialEntries) {
      (entry['link'] as TextEditingController).dispose();
    }
    super.dispose();
  }

  void _addEntry() {
    setState(() {
      _socialEntries.add({
        'platform': null,
        'link': TextEditingController(),
      });
    });
  }

  void _removeEntry(int index) {
    setState(() {
      ((_socialEntries[index]['link']) as TextEditingController).dispose();
      _socialEntries.removeAt(index);
    });
  }

  void _onContinue() {
    context.push(RouterPath.spUploadImageScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.h),
                  CustomAppBar(title: 'Profile setup'),
                  SizedBox(height: 24.h),
                  Text(
                    'Help us to connect more\nabout your business',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 22.sp,
                          color: AppColors.text,
                        ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._socialEntries.asMap().entries.map(
                          (entry) => _buildSocialEntry(entry.key),
                        ),
                    SizedBox(height: 8.h),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
              child: Column(
                children: [
                  // Add more social button
                  GestureDetector(
                    onTap: _addEntry,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: Text(
                          'Add more social',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.primaryLight,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  // Continue button
                  CustomElevatedButton(
                    onPressed: _onContinue,
                    title: 'Continue',
                    color: AppColors.primaryLight,
                    textColor: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialEntry(int index) {
    final entry = _socialEntries[index];
    final bool canRemove = _socialEntries.length > 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Select Platform',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.text,
                    fontWeight: FontWeight.w400,
                  ),
            ),
            if (canRemove)
              GestureDetector(
                onTap: () => _removeEntry(index),
                child: Icon(
                  Icons.close,
                  size: 18.sp,
                  color: AppColors.lightText,
                ),
              ),
          ],
        ),
        SizedBox(height: 8.h),
        _buildPlatformDropdown(index, entry['platform'] as String?),
        SizedBox(height: 16.h),
        Text(
          'Website Link',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.text,
                fontWeight: FontWeight.w400,
              ),
        ),
        SizedBox(height: 8.h),
        AuthTextFormField(
          hintText: 'Enter your Business website link',
          controller: entry['link'] as TextEditingController,
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildPlatformDropdown(int index, String? selectedValue) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      onChanged: (value) {
        setState(() {
          _socialEntries[index]['platform'] = value;
        });
      },
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.lightText,
      ),
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 14.sp,
            color: AppColors.text,
          ),
      decoration: InputDecoration(
        hintText: 'ex. facebook, instagram',
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 14.sp,
              color: AppColors.lightText,
            ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: AppColors.lightText.withValues(alpha: 0.3),
            width: 1.w,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: AppColors.lightText.withValues(alpha: 0.3),
            width: 1.w,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: AppColors.text.withValues(alpha: 0.7),
            width: 1.2.w,
          ),
        ),
      ),
      items: _platforms.map((String platform) {
        return DropdownMenuItem<String>(
          value: platform,
          child: Text(platform),
        );
      }).toList(),
    );
  }
}
