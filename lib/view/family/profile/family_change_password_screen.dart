import 'package:familyside/provider/family/family_profile_provider.dart';
import 'package:familyside/utils/app_snackbar.dart';
import 'package:familyside/view/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/utils/form_validator.dart';
import 'package:familyside/view/widgets/auth_text_form_field.dart';
import 'package:familyside/view/widgets/custom_elevated_button.dart';

class FamilyChangePasswordScreen extends ConsumerStatefulWidget {
  const FamilyChangePasswordScreen({super.key});

  @override
  ConsumerState<FamilyChangePasswordScreen> createState() =>
      _FamilyChangePasswordScreenState();
}

class _FamilyChangePasswordScreenState extends ConsumerState<FamilyChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(_onNewPasswordChanged);
  }

  void _onNewPasswordChanged() => setState(() {});

  @override
  void dispose() {
    _newPasswordController.removeListener(_onNewPasswordChanged);
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(familyProfileProvider.notifier)
        .changePassword(
          currentPassword: _currentPasswordController.text,
          newPassword: _newPasswordController.text,
        );

    if (!mounted) return;

    if (success) {
      AppSnackbar.show(
        message: 'Password changed successfully',
        type: SnackType.success,
      );
      if (context.mounted) context.pop();
    } else {
      AppSnackbar.show(
        message: 'Failed to change password',
        type: SnackType.error,
      );
    }
  }

  bool _hasMinLength(String password) => password.length >= 8;

  bool _hasUpperAndLowerCase(String password) =>
      RegExp(r'[A-Z]').hasMatch(password) && RegExp(r'[a-z]').hasMatch(password);

  bool _hasSpecialCharacter(String password) =>
      RegExp(r'[!@#$%&*]').hasMatch(password);

  bool _hasNumber(String password) => RegExp(r'[0-9]').hasMatch(password);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final newPassword = _newPasswordController.text;
    final state = ref.watch(familyProfileProvider);

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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const CustomAppBar(title: 'Change password'),
                      SizedBox(height: 32.h),
                      _buildFieldLabel(theme, 'Current password'),
                      SizedBox(height: 8.h),
                      AuthTextFormField(
                        hintText: 'Enter current password',
                        controller: _currentPasswordController,
                        isPassword: true,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your current password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),
                      _buildFieldLabel(theme, 'New password'),
                      SizedBox(height: 8.h),
                      AuthTextFormField(
                        hintText: 'Enter new password',
                        controller: _newPasswordController,
                        isPassword: true,
                        textInputAction: TextInputAction.next,
                        validator: FormValidator.validatePassword,
                      ),
                      SizedBox(height: 16.h),
                      _buildFieldLabel(theme, 'New confirm password'),
                      SizedBox(height: 8.h),
                      AuthTextFormField(
                        hintText: 'Confirm new password',
                        controller: _confirmPasswordController,
                        isPassword: true,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _onUpdate(),
                        validator: (value) => FormValidator.validateConfirmPassword(
                          value,
                          _newPasswordController.text,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        'Password must include:',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _PasswordRequirementRow(
                        label: 'At least 8 characters',
                        isMet: _hasMinLength(newPassword),
                      ),
                      SizedBox(height: 8.h),
                      _PasswordRequirementRow(
                        label: 'Capital and lowercase letters',
                        isMet: _hasUpperAndLowerCase(newPassword),
                      ),
                      SizedBox(height: 8.h),
                      _PasswordRequirementRow(
                        label: 'A special character - # @ \$ % & ! *',
                        isMet: _hasSpecialCharacter(newPassword),
                      ),
                      SizedBox(height: 8.h),
                      _PasswordRequirementRow(
                        label: 'A number',
                        isMet: _hasNumber(newPassword),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
              child: CustomElevatedButton(
                onPressed: state.isLoading ? () {} : _onUpdate,
                title: 'Update',
                color: AppColors.primaryLight,
                textColor: AppColors.onPrimaryLight,
                isLoading: state.isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(ThemeData theme, String label) {
    return Text(
      label,
      style: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w500,
        color: AppColors.lightText,
        fontSize: 14.sp,
      ),
    );
  }
}

class _PasswordRequirementRow extends StatelessWidget {
  const _PasswordRequirementRow({
    required this.label,
    required this.isMet,
  });

  final String label;
  final bool isMet;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = isMet ? AppColors.primaryLight : AppColors.mutedIcon;
    final textColor = isMet ? AppColors.text : AppColors.lightText;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.check_circle_outline,
          size: 18.sp,
          color: iconColor,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 13.sp,
              color: textColor,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}
