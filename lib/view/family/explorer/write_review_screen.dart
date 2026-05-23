import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/utils/image_picker.dart';
import 'package:familyside/view/family/auth/signup/widgets/custom_dropdown.dart';

class WriteReviewScreen extends StatefulWidget {
  const WriteReviewScreen({super.key});

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reviewController = TextEditingController();
  
  String? _selectedCategory;
  final Set<String> _selectedTags = {'Education'};
  String _selectedRecommendation = 'Highly Recommended';
  final List<File> _pickedImages = [];

  final List<String> _categories = [
    'Education',
    'Music',
    'Sports',
    'Dance',
    'Outdoor Play',
    'Coding',
    'Others',
  ];

  final List<String> _tags = [
    'Education',
    'Music',
    'Sports',
    'Dance',
    'Outdoor Play',
    'Coding',
    'Others',
  ];

  final List<String> _recommendationOptions = [
    'Highly Recommended',
    'Recommended',
    'Average',
    'Not suitable',
  ];

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    showImagePickerOptions(context, (source) async {
      final file = await pickSingleImage(context: context, source: source);
      if (file != null) {
        setState(() {
          _pickedImages.add(file);
        });
      }
    });
  }

  void _submitReview() {
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review submitted successfully!'),
          backgroundColor: AppColors.secondaryLight,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Custom AppBar Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Icon(Icons.arrow_back_ios_new_rounded, size: 22.sp, color: AppColors.text),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Write review',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h),
                      
                      // Category Dropdown
                      _buildSectionHeader('Category'),
                      SizedBox(height: 8.h),
                      CustomDropdown(
                        hintText: 'Select category',
                        value: _selectedCategory,
                        items: _categories,
                        onChanged: (value) {
                          setState(() => _selectedCategory = value);
                        },
                      ),
                      SizedBox(height: 16.h),

                      // Tag wrap chips
                      _buildSectionHeader('Tag'),
                      SizedBox(height: 12.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: _tags.map((tag) {
                          final isSelected = _selectedTags.contains(tag);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedTags.remove(tag);
                                } else {
                                  _selectedTags.add(tag);
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryLight
                                    : AppColors.primaryLight.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                tag,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : AppColors.primaryLight,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 24.h),

                      // Select recommendation
                      _buildSectionHeader('Select recommendation'),
                      SizedBox(height: 12.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: _recommendationOptions.map((option) {
                          final isSelected = _selectedRecommendation == option;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedRecommendation = option;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryLight
                                    : AppColors.primaryLight.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                option,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : AppColors.primaryLight,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 24.h),

                      // Write Review field
                      _buildSectionHeader('Write Review'),
                      SizedBox(height: 12.h),
                      TextFormField(
                        controller: _reviewController,
                        maxLines: 5,
                        minLines: 3,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please write your review';
                          }
                          return null;
                        },
                        style: TextStyle(fontSize: 14.sp, color: AppColors.text),
                        decoration: InputDecoration(
                          hintText: 'Share your experience with this place. What did you and your family enjoy most?',
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.lightText.withOpacity(0.7),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 14.h,
                            horizontal: 14.w,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: AppColors.lightText.withOpacity(0.3), width: 1.w),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: AppColors.lightText.withOpacity(0.3), width: 1.w),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: AppColors.text.withOpacity(0.7), width: 1.2.w),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: AppColors.error, width: 1.2.w),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: AppColors.error, width: 1.2.w),
                          ),
                          errorStyle: TextStyle(fontSize: 11.sp, color: AppColors.error),
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Add Photos
                      _buildPhotoUploader(),
                      SizedBox(height: 40.h),

                      // Actions: Cancel & Submit
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: AppColors.primaryLight,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      GestureDetector(
                        onTap: _submitReview,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: Center(
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
      ),
    );
  }

  Widget _buildPhotoUploader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Add Photos ',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            Text(
              '(Optional)',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                color: AppColors.lightText,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        if (_pickedImages.isEmpty)
          GestureDetector(
            onTap: _pickImages,
            child: CustomPaint(
              painter: DashedBorderPainter(
                color: AppColors.lightText.withOpacity(0.3),
                borderRadius: 12.r,
                dashWidth: 6,
                dashSpace: 4,
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 28.h),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_outlined,
                      size: 36.sp,
                      color: AppColors.mutedIcon,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Click to upload photos',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.text.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'PNG, JPG, up to 10MB',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.lightText.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          SizedBox(
            height: 100.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _pickedImages.length + 1,
              itemBuilder: (context, index) {
                if (index == _pickedImages.length) {
                  // "+" Button to add more images
                  return GestureDetector(
                    onTap: _pickImages,
                    child: Container(
                      width: 90.w,
                      margin: EdgeInsets.only(right: 8.w),
                      child: CustomPaint(
                        painter: DashedBorderPainter(
                          color: AppColors.lightText.withOpacity(0.3),
                          borderRadius: 8.r,
                          dashWidth: 4,
                          dashSpace: 3,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 28.sp,
                            color: AppColors.lightText,
                          ),
                        ),
                      ),
                    ),
                  );
                }

                final imageFile = _pickedImages[index];
                return Stack(
                  children: [
                    Container(
                      width: 90.w,
                      margin: EdgeInsets.only(right: 8.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: AppColors.border),
                        image: DecorationImage(
                          image: FileImage(imageFile),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4.h,
                      right: 12.w,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _pickedImages.removeAt(index);
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }
}

// Dashed border painter for upload container
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    ));

    final dashPath = Path();
    double distance = 0.0;
    for (final PathMetric measurePath in path.computeMetrics()) {
      while (distance < measurePath.length) {
        final length = dashWidth;
        final isLast = distance + length >= measurePath.length;
        dashPath.addPath(
          measurePath.extractPath(distance, isLast ? measurePath.length : distance + length),
          Offset.zero,
        );
        distance += length + dashSpace;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace ||
        oldDelegate.borderRadius != borderRadius;
  }
}
