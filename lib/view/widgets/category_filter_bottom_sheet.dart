import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/view/widgets/custom_elevated_button.dart';
import 'package:familyside/view/widgets/filter_chip_widget.dart';

class CategoryFilterResultModel {
  final String distance;
  final String review;
  final List<String> ages;

  CategoryFilterResultModel({
    required this.distance,
    required this.review,
    required this.ages,
  });

  @override
  String toString() {
    return 'CategoryFilterResultModel(distance: $distance, review: $review, ages: $ages)';
  }
}

class CategoryFilterBottomSheet extends StatefulWidget {
  final CategoryFilterResultModel? initialFilters;

  const CategoryFilterBottomSheet({super.key, this.initialFilters});

  @override
  State<CategoryFilterBottomSheet> createState() => _CategoryFilterBottomSheetState();
}

class _CategoryFilterBottomSheetState extends State<CategoryFilterBottomSheet> {
  String _selectedDistance = '1 km';
  String _selectedReview = '5';
  final List<String> _selectedAges = [];

  final List<String> _distances = [
    '1 km',
    '2-5km',
    '6-10km',
    '10+km',
  ];

  final List<String> _reviews = [
    '5',
    '4',
    '3',
    'less than 3',
  ];

  final List<String> _ageRanges = [
    '0-3 years',
    '3-8 years',
    '8-13 years',
    '15+ years',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialFilters != null) {
      _selectedDistance = widget.initialFilters!.distance;
      _selectedReview = widget.initialFilters!.review;
      _selectedAges.addAll(widget.initialFilters!.ages);
    }
  }

  void _clearAll() {
    setState(() {
      _selectedDistance = '1 km';
      _selectedReview = '5';
      _selectedAges.clear();
    });
  }

  void _applyFilter() {
    final result = CategoryFilterResultModel(
      distance: _selectedDistance,
      review: _selectedReview,
      ages: List.from(_selectedAges),
    );
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28.r),
          topRight: Radius.circular(28.r),
        ),
      ),
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 24.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              "Filter Result",
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            SizedBox(height: 24.h),

            // Distance Label
            Text(
              "Distance",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            SizedBox(height: 12.h),

            // Distance Horizontal Scroll List
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: _distances.map((dist) {
                  final isSelected = _selectedDistance == dist;
                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: FilterChipWidget(
                      label: dist,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _selectedDistance = dist;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 24.h),

            // Review Label
            Text(
              "Review",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            SizedBox(height: 12.h),

            // Review Horizontal Scroll List
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: _reviews.map((rev) {
                  final isSelected = _selectedReview == rev;
                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: FilterChipWidget(
                      label: rev,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _selectedReview = rev;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 24.h),

            // Child Age Label
            Text(
              "Child Age",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            SizedBox(height: 12.h),

            // Child Age Horizontal Scroll List
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: _ageRanges.map((age) {
                  final isSelected = _selectedAges.contains(age);
                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: FilterChipWidget(
                      label: age,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedAges.remove(age);
                          } else {
                            _selectedAges.add(age);
                          }
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 32.h),

            // Apply Filter Button
            CustomElevatedButton(
              onPressed: _applyFilter,
              title: "Apply Filter",
              color: AppColors.primaryLight,
              textColor: Colors.white,
            ),
            SizedBox(height: 12.h),

            // Clear All Button
            CustomElevatedButton(
              onPressed: _clearAll,
              title: "Clear all",
              color: AppColors.primaryLight.withValues(alpha: 0.1),
              textColor: AppColors.primaryLight,
            ),
          ],
        ),
      ),
    );
  }
}
