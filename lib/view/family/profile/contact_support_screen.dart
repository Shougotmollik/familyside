import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/utils/form_validator.dart';
import 'package:familyside/view/widgets/auth_text_form_field.dart';
import 'package:familyside/view/widgets/custom_app_bar.dart';
import 'package:familyside/view/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'shahidhasan@gmail.com');
  final _locationController = TextEditingController(
    text: 'mohakhali, dhaka, Bangladesh',
  );
  final _problemDetailsController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _locationController.dispose();
    _problemDetailsController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    FormValidator.validateAndProceed(_formKey, () {
      context.pop();
    });
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
    final theme = Theme.of(context);

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
                      _buildFieldLabel(theme, 'Your Email'),
                      SizedBox(height: 8.h),
                      AuthTextFormField(
                        hintText: 'Enter your email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        readOnly: true,
                        validator: FormValidator.validateEmail,
                      ),
                      SizedBox(height: 16.h),
                      _buildFieldLabel(theme, 'Your Location'),
                      SizedBox(height: 8.h),
                      AuthTextFormField(
                        hintText: 'Enter your location',
                        controller: _locationController,
                        keyboardType: TextInputType.streetAddress,
                        textInputAction: TextInputAction.next,
                        validator: _validateLocation,
                      ),
                      SizedBox(height: 16.h),
                      _buildFieldLabel(theme, 'Problem details'),
                      SizedBox(height: 8.h),
                      AuthTextFormField(
                        hintText: 'Describe your query here....',
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
                onPressed: _onSubmit,
                title: 'Submit',
                color: AppColors.primaryLight,
                textColor: AppColors.onPrimaryLight,
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
