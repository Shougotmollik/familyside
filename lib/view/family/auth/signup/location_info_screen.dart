import 'package:familyside/core/router/router_path.dart';
import 'package:familyside/env.dart';
import 'package:familyside/view/widgets/custom_app_bar.dart';
import 'package:familyside/view/widgets/custom_elevated_button.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/view/widgets/google_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationInfoScreen extends StatefulWidget {
  const LocationInfoScreen({super.key});

  @override
  State<LocationInfoScreen> createState() => _LocationInfoScreenState();
}

class _LocationInfoScreenState extends State<LocationInfoScreen> {
  final TextEditingController _locationController = TextEditingController();
  GoogleMapLocation? _selectedLocation;

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  void _openGoogleMap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GoogleMapScreen(
          apiKey: EnvHandler.googleMapApiKey,
          onLocationSelect: (location) {
            setState(() {
              _selectedLocation = location;
              _locationController.text = location.name;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h),
                      const CustomAppBar(title: "Location"),
                      SizedBox(height: 30.h),
                      Text(
                        "Enter your location",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                          height: 1,
                          fontSize: 22.sp,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F3F3),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: TextField(
                                controller: _locationController,
                                enabled: true,
                                decoration: InputDecoration(
                                  hintText: 'Enter your location',
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: AppColors.lightText),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: AppColors.lightText,
                                    size: 24.sp,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 14.h,
                                  ),
                                ),
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppColors.text),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          GestureDetector(
                            onTap: _openGoogleMap,
                            child: Container(
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 24.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 60.h),
                      Center(
                        child: SvgPicture.asset(
                          "assets/image/location_illstruction.svg",
                          height: 300.h,
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: CustomElevatedButton(
                onPressed: () {
                  context.push(RouterPath.familyUploadImageScreen);
                },
                title: 'Continue',
                color: AppColors.primaryLight,
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
