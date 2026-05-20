import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/view/widgets/custom_app_bar.dart';
import 'package:familyside/view/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class FamilyUploadImageScreen extends StatelessWidget {
  const FamilyUploadImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: "Upload Family Photo"),
            SizedBox(height: 24.h),
            Center(
              child: Container(
                height: 180.h,
                width: 180.w,
                decoration: BoxDecoration(
                  color: AppColors.secondaryLight,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.lightText.withOpacity(0.3),
                    width: 1.w,
                  ),
                ),
                child: Icon(
                  Icons.camera_alt,
                  size: 80.sp,
                  color: AppColors.lightText,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Add a photo of your family',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.text,
                height: 1.3,
                fontSize: 22.sp,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'This photo will be visible to other families in your community',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.text,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SvgPicture.asset("assets/image/location_illstruction.svg"),
            Spacer(),
            CustomElevatedButton(
              onPressed: () {
                context.pop();
              },
              title: 'Continue',
              color: AppColors.primaryLight,
              textColor: Colors.white,
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
