import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/utils/form_validator.dart';
import 'package:familyside/view/widgets/auth_text_form_field.dart';
import 'package:familyside/view/widgets/custom_app_bar.dart';
import 'package:familyside/view/widgets/custom_elevated_button.dart';

class SpChangePasswordScreen extends StatefulWidget {
  const SpChangePasswordScreen({super.key});

  @override
  State<SpChangePasswordScreen> createState() => _SpChangePasswordScreenState();
}

class _SpChangePasswordScreenState extends State<SpChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _newCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  bool _hasMinLength(String p) => p.length >= 8;
  bool _hasUpperLower(String p) =>
      RegExp(r'[A-Z]').hasMatch(p) && RegExp(r'[a-z]').hasMatch(p);
  bool _hasSpecial(String p) => RegExp(r'[!@#$%&*]').hasMatch(p);
  bool _hasNumber(String p) => RegExp(r'[0-9]').hasMatch(p);

  @override
  Widget build(BuildContext context) {
    final pw = _newCtrl.text;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomAppBar(title: 'Change Password'),
                      SizedBox(height: 32.h),
                      _label('Current password'),
                      SizedBox(height: 8.h),
                      AuthTextFormField(
                        hintText: 'Enter current password',
                        controller: _currentCtrl,
                        isPassword: true,
                        textInputAction: TextInputAction.next,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Required' : null,
                      ),
                      SizedBox(height: 16.h),
                      _label('New password'),
                      SizedBox(height: 8.h),
                      AuthTextFormField(
                        hintText: 'Enter new password',
                        controller: _newCtrl,
                        isPassword: true,
                        textInputAction: TextInputAction.next,
                        validator: FormValidator.validatePassword,
                      ),
                      SizedBox(height: 16.h),
                      _label('Confirm new password'),
                      SizedBox(height: 8.h),
                      AuthTextFormField(
                        hintText: 'Confirm new password',
                        controller: _confirmCtrl,
                        isPassword: true,
                        textInputAction: TextInputAction.done,
                        validator: (v) => FormValidator.validateConfirmPassword(
                          v,
                          _newCtrl.text,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        'Password must include:',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _req('At least 8 characters', _hasMinLength(pw)),
                      SizedBox(height: 8.h),
                      _req('Capital and lowercase letters', _hasUpperLower(pw)),
                      SizedBox(height: 8.h),
                      _req(
                        'A special character - # @ \$ % & ! *',
                        _hasSpecial(pw),
                      ),
                      SizedBox(height: 8.h),
                      _req('A number', _hasNumber(pw)),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
              child: CustomElevatedButton(
                onPressed: () => FormValidator.validateAndProceed(
                  _formKey,
                  () => context.pop(),
                ),
                title: 'Update',
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

  Widget _req(String label, bool met) => Row(
    children: [
      Icon(
        met ? Icons.check_circle : Icons.check_circle_outline,
        size: 18.sp,
        color: met ? AppColors.primaryLight : AppColors.mutedIcon,
      ),
      SizedBox(width: 8.w),
      Expanded(
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 13.sp,
            color: met ? AppColors.text : AppColors.lightText,
          ),
        ),
      ),
    ],
  );
}
