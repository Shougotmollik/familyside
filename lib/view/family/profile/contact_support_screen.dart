import 'package:familyside/core/localization/app_localizations.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/provider/family/family_profile_provider.dart';
import 'package:familyside/services/local_storage.dart';
import 'package:familyside/utils/app_snackbar.dart';
import 'package:familyside/utils/form_validator.dart';
import 'package:familyside/view/widgets/auth_text_form_field.dart';
import 'package:familyside/view/widgets/custom_app_bar.dart';
import 'package:familyside/view/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ContactSupportScreen extends ConsumerStatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  ConsumerState<ContactSupportScreen> createState() =>
      _ContactSupportScreenState();
}

class _ContactSupportScreenState extends ConsumerState<ContactSupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();
  final _problemDetailsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final profile = ref.read(familyProfileProvider).value;
      if (profile != null) {
        _locationController.text = profile.locationName;
      }
      final email = await LocalStorage.user_email.get();
      _emailController.text = email ?? '';
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _locationController.dispose();
    _problemDetailsController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final loc = AppLocalizations.of(context);
    final success = await ref
        .read(familyProfileProvider.notifier)
        .contactSupport(
          email: _emailController.text.trim(),
          location: _locationController.text.trim(),
          problemDetails: _problemDetailsController.text.trim(),
        );

    if (!mounted) return;

    if (success) {
      AppSnackbar.show(
        message: loc.translate('supportRequestSuccess'),
        type: SnackType.success,
      );
      if (context.mounted) context.pop();
    } else {
      AppSnackbar.show(
        message: loc.translate('failedToSubmitSupport'),
        type: SnackType.error,
      );
    }
  }

  String? _validateProblemDetails(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please describe your problem';
    }
    if (value.trim().length < 10) {
      return 'Please provide more details';
    }
    return null;
  }

  String? _validateLocation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your location';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final state = ref.watch(familyProfileProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const CustomAppBar(title: 'Contact Support'),
                      SizedBox(height: 32.h),
                      _buildFieldLabel(theme, loc.translate('yourEmail')),
                      SizedBox(height: 8.h),
                      AuthTextFormField(
                        hintText: loc.translate('enterEmail'),
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        readOnly: true,
                        validator: FormValidator.validateEmail,
                      ),
                      SizedBox(height: 16.h),
                      _buildFieldLabel(theme, loc.translate('yourLocation')),
                      SizedBox(height: 8.h),
                      AuthTextFormField(
                        hintText: loc.translate('enterYourLocation'),
                        controller: _locationController,
                        keyboardType: TextInputType.streetAddress,
                        textInputAction: TextInputAction.next,
                        validator: _validateLocation,
                      ),
                      SizedBox(height: 16.h),
                      _buildFieldLabel(theme, loc.translate('problemDetails')),
                      SizedBox(height: 8.h),
                      AuthTextFormField(
                        hintText: loc.translate('describeQueryHere'),
                        controller: _problemDetailsController,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        maxLines: 5,
                        minLines: 5,
                        validator: _validateProblemDetails,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
              child: CustomElevatedButton(
                onPressed: state.isLoading ? () {} : _onSubmit,
                title: loc.translate('submit'),
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
