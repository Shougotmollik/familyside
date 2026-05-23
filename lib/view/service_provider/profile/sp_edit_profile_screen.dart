import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/utils/form_validator.dart';
import 'package:familyside/utils/image_picker.dart';
import 'package:familyside/view/widgets/auth_text_form_field.dart';
import 'package:familyside/view/widgets/custom_app_bar.dart';
import 'package:familyside/view/widgets/custom_elevated_button.dart';

class SpEditProfileScreen extends StatefulWidget {
  const SpEditProfileScreen({super.key});

  @override
  State<SpEditProfileScreen> createState() => _SpEditProfileScreenState();
}

class _SpEditProfileScreenState extends State<SpEditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController(text: 'Shahid');
  final _emailCtrl = TextEditingController(text: 'shahid@example.com');
  final _phoneCtrl = TextEditingController(text: '+880 1234 567890');
  final _businessCtrl = TextEditingController(text: 'Little Stars Clinic');
  final _locationCtrl = TextEditingController(text: 'Dhaka, Bangladesh');
  File? _pickedImage;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _businessCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final file = await pickSingleImage(context: context, source: source);
    if (file != null) setState(() => _pickedImage = file);
  }

  @override
  Widget build(BuildContext context) {
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
                      const CustomAppBar(title: 'Edit Profile'),
                      SizedBox(height: 32.h),
                      Center(child: _buildAvatar()),
                      SizedBox(height: 32.h),
                      _label('Full Name'),
                      SizedBox(height: 8.h),
                      AuthTextFormField(
                        hintText: 'Enter your name',
                        controller: _nameCtrl,
                        validator: FormValidator.validateName,
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(height: 16.h),
                      _label('Email'),
                      SizedBox(height: 8.h),
                      AuthTextFormField(
                        hintText: 'Enter your email',
                        controller: _emailCtrl,
                        readOnly: true,
                        keyboardType: TextInputType.emailAddress,
                        validator: FormValidator.validateEmail,
                      ),
                      SizedBox(height: 16.h),
                      _label('Phone Number'),
                      SizedBox(height: 8.h),
                      AuthTextFormField(
                        hintText: 'Enter phone number',
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(height: 16.h),
                      _label('Business Name'),
                      SizedBox(height: 8.h),
                      AuthTextFormField(
                        hintText: 'Enter business name',
                        controller: _businessCtrl,
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(height: 16.h),
                      _label('Location'),
                      SizedBox(height: 8.h),
                      AuthTextFormField(
                        hintText: 'Enter location',
                        controller: _locationCtrl,
                        textInputAction: TextInputAction.done,
                      ),
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

  Widget _buildAvatar() {
    const double size = 110;
    return SizedBox(
      width: size.w,
      height: size.w,
      child: Stack(
        children: [
          ClipOval(
            child: _pickedImage != null
                ? Image.file(
                    _pickedImage!,
                    width: size.w,
                    height: size.w,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/image/demo_image.jpg',
                    width: size.w,
                    height: size.w,
                    fit: BoxFit.cover,
                  ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => showImagePickerOptions(context, _pickImage),
              child: Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                  size: 16.sp,
                ),
              ),
            ),
          ),
        ],
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
