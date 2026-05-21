import 'dart:io';

import 'package:familyside/view/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/utils/form_validator.dart';
import 'package:familyside/utils/image_picker.dart';
import 'package:familyside/view/widgets/auth_text_form_field.dart';
import 'package:familyside/view/widgets/custom_elevated_button.dart';

class FamilyEditProfileScreen extends StatefulWidget {
  const FamilyEditProfileScreen({super.key});

  @override
  State<FamilyEditProfileScreen> createState() => _FamilyEditProfileScreenState();
}

class _FamilyEditProfileScreenState extends State<FamilyEditProfileScreen> {
  static const String _defaultAvatarAsset = 'assets/image/demo_image.jpg';

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Shougot mollik');
  final _emailController = TextEditingController(text: 'shougotmollik@gmail.com');
  final _locationController = TextEditingController(
    text: 'mohakhali, dhaka, Bangladesh',
  );

  File? _pickedImage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final file = await pickSingleImage(context: context, source: source);
    if (file != null) {
      setState(() => _pickedImage = file);
    }
  }

  void _onUpdate() {
    FormValidator.validateAndProceed(_formKey, () {
      context.pop();
    });
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
                      const CustomAppBar(title: 'Edit profile'),
                      SizedBox(height: 32.h),
                      Center(child: _buildProfileAvatar()),
                      SizedBox(height: 32.h),
                      _buildFieldLabel(theme, 'Name'),
                      SizedBox(height: 8.h),
                      AuthTextFormField(
                        hintText: 'Enter your name',
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        validator: FormValidator.validateName,
                      ),
                      SizedBox(height: 16.h),
                      _buildFieldLabel(theme, 'Email'),
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
                      _buildFieldLabel(theme, 'Location'),
                      SizedBox(height: 8.h),
                      AuthTextFormField(
                        hintText: 'Enter your location',
                        controller: _locationController,
                        keyboardType: TextInputType.streetAddress,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _onUpdate(),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your location';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
              child: CustomElevatedButton(
                onPressed: _onUpdate,
                title: 'Update',
                color: AppColors.primaryLight,
                textColor: AppColors.onPrimaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileAvatar() {
    const double avatarSize = 120;

    return SizedBox(
      width: avatarSize.w,
      height: avatarSize.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: avatarSize.w,
            height: avatarSize.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border, width: 2.w),
            ),
            child: ClipOval(child: _buildAvatarImage(avatarSize)),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => showImagePickerOptions(context, _pickImage),
              child: Container(
                height: 36.w,
                width: 36.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.w),
                ),
                child: Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarImage(double size) {
    if (_pickedImage != null) {
      return Image.file(
        _pickedImage!,
        width: size.w,
        height: size.w,
        fit: BoxFit.cover,
      );
    }

    return Image.asset(
      _defaultAvatarAsset,
      width: size.w,
      height: size.w,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: size.w,
          height: size.w,
          color: AppColors.border,
          child: Icon(
            Icons.person_outline,
            size: 48.sp,
            color: AppColors.grey,
          ),
        );
      },
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
