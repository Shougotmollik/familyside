import 'dart:io';
import 'package:familyside/core/router/router_path.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/utils/image_picker.dart';
import 'package:familyside/view/widgets/custom_app_bar.dart';
import 'package:familyside/view/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class SpUploadImageScreen extends StatefulWidget {
  const SpUploadImageScreen({super.key});

  @override
  State<SpUploadImageScreen> createState() => _SpUploadImageScreenState();
}

class _SpUploadImageScreenState extends State<SpUploadImageScreen> {
  File? _pickedImage;

  Future<void> _pickImage(ImageSource source) async {
    final file = await pickSingleImage(context: context, source: source);
    if (file != null) {
      setState(() {
        _pickedImage = file;
      });
    }
  }

  Widget _buildAvatar() {
    if (_pickedImage != null) {
      return Container(
        height: 180.w,
        width: 180.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primaryLight, width: 2.w),
        ),
        child: ClipOval(child: Image.file(_pickedImage!, fit: BoxFit.cover)),
      );
    }

    return Container(
      height: 180.w,
      width: 180.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primaryLight, width: 2.w),
      ),
      child: ClipOval(
        child: Container(
          color: const Color(0xFFD2D6DC),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 38.h,
                child: Container(
                  width: 52.w,
                  height: 52.w,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: -5.h,
                child: Container(
                  width: 120.w,
                  height: 64.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60.r),
                      topRight: Radius.circular(60.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10.h),
              const CustomAppBar(title: "Profile"),
              SizedBox(height: 30.h),
              Text(
                'Upload your image',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                  fontSize: 22.sp,
                ),
              ),
              SizedBox(height: 70.h),
              Center(
                child: Stack(
                  children: [
                    _buildAvatar(),
                    Positioned(
                      bottom: 5.h,
                      right: 5.w,
                      child: GestureDetector(
                        onTap: () {
                          showImagePickerOptions(context, _pickImage);
                        },
                        child: Container(
                          height: 38.w,
                          width: 38.w,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2.w),
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 2),
              CustomElevatedButton(
                onPressed: () {
                  context.push(RouterPath.spMainNavBarScreen);
                },
                title: 'Continue',
                color: AppColors.primaryLight,
                textColor: Colors.white,
              ),
              SizedBox(height: 16.h),
              CustomElevatedButton(
                onPressed: () {
                  context.push(RouterPath.spMainNavBarScreen);
                },
                title: 'Skip',
                color: Colors.transparent,
                textColor: AppColors.primaryLight,
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
