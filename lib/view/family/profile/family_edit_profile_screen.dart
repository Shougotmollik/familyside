import 'dart:io';

import 'package:familyside/core/config/credential.dart';
import 'package:familyside/provider/family/family_profile_provider.dart';
import 'package:familyside/services/local_storage.dart';
import 'package:familyside/utils/app_snackbar.dart';
import 'package:familyside/view/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/utils/form_validator.dart';
import 'package:familyside/utils/image_picker.dart';
import 'package:familyside/view/widgets/auth_text_form_field.dart';
import 'package:familyside/view/widgets/custom_elevated_button.dart';

class FamilyEditProfileScreen extends ConsumerStatefulWidget {
  const FamilyEditProfileScreen({super.key});

  @override
  ConsumerState<FamilyEditProfileScreen> createState() =>
      _FamilyEditProfileScreenState();
}

class _FamilyEditProfileScreenState extends ConsumerState<FamilyEditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();

  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final profile = ref.read(familyProfileProvider).value;
      if (profile != null) {
        _nameController.text = profile.fullName;
        _locationController.text = profile.locationName;
      }
      final email = await LocalStorage.user_email.get();
      _emailController.text = email ?? '';
    });
  }

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

  Future<void> _onUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(familyProfileProvider.notifier)
        .updateProfile(
          image: _pickedImage,
          name: _nameController.text.trim(),
          location: _locationController.text.trim(),
        );

    if (!mounted) return;

    if (success) {
      AppSnackbar.show(
        message: 'Profile updated successfully',
        type: SnackType.success,
      );
      if (context.mounted) context.pop();
    } else {
      AppSnackbar.show(
        message: 'Failed to update profile',
        type: SnackType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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

  Widget _buildProfileAvatar() {
    const double size = 110;
    final profile = ref.watch(familyProfileProvider).value;

    return SizedBox(
      width: size.w,
      height: size.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size.w,
            height: size.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border, width: 2.w),
            ),
            child: ClipOval(
              child: _pickedImage != null
                  ? Image.file(
                      _pickedImage!,
                      width: size.w,
                      height: size.w,
                      fit: BoxFit.cover,
                    )
                  : (profile?.profileImageUrl.isNotEmpty == true
                      ? Image.network(
                          AppCredentials.fixurl(profile!.profileImageUrl),
                          width: size.w,
                          height: size.w,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/image/demo_image.jpg',
                          width: size.w,
                          height: size.w,
                          fit: BoxFit.cover,
                        )),
            ),
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
