import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/view/widgets/custom_elevated_button.dart';
import 'package:familyside/view/widgets/filter_chip_widget.dart';

class FilterResultModel {
  final String location;
  final List<String> categories;
  final List<String> ages;
  final String price;

  FilterResultModel({
    required this.location,
    required this.categories,
    required this.ages,
    required this.price,
  });

  @override
  String toString() {
    return 'FilterResultModel(location: $location, categories: $categories, ages: $ages, price: $price)';
  }
}

class HomeFilterBottomSheet extends StatefulWidget {
  final FilterResultModel? initialFilters;

  const HomeFilterBottomSheet({super.key, this.initialFilters});

  @override
  State<HomeFilterBottomSheet> createState() => _HomeFilterBottomSheetState();
}

class _HomeFilterBottomSheetState extends State<HomeFilterBottomSheet> {
  late final TextEditingController _locationController;
  final List<String> _selectedCategories = [];
  final List<String> _selectedAges = [];
  String _selectedPrice = 'All';

  final List<String> _categories = [
    'Education',
    'Music',
    'Sports',
    'Dance',
    'Health',
    'Schools',
    'Events',
    'Outdoor',
  ];

  final List<String> _ageRanges = [
    '0-3 years',
    '3-8 years',
    '8-13 years',
    '15+ years',
  ];

  final List<String> _prices = ['All', 'Free', 'Paid'];

  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController(
      text: widget.initialFilters?.location ?? '',
    );
    if (widget.initialFilters != null) {
      _selectedCategories.addAll(widget.initialFilters!.categories);
      _selectedAges.addAll(widget.initialFilters!.ages);
      _selectedPrice = widget.initialFilters!.price;
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  void _clearAll() {
    setState(() {
      _locationController.clear();
      _selectedCategories.clear();
      _selectedAges.clear();
      _selectedPrice = 'All';
    });
  }

  void _applyFilter() {
    final result = FilterResultModel(
      location: _locationController.text,
      categories: List.from(_selectedCategories),
      ages: List.from(_selectedAges),
      price: _selectedPrice,
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
            SizedBox(height: 20.h),

            // Location Input
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                hintText: "Enter the name of the Location",
                hintStyle: TextStyle(
                  color: AppColors.lightText,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 14.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: AppColors.primaryLight),
                ),
              ),
              style: TextStyle(color: AppColors.text, fontSize: 14.sp),
            ),
            SizedBox(height: 24.h),

            // Category Label
            Row(
              children: [
                Text(
                  "Category",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  "(multi-select)",
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                    color: AppColors.lightText,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Category Horizontal Scroll List
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: _categories.map((category) {
                  final isSelected = _selectedCategories.contains(category);
                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: FilterChipWidget(
                      label: category,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedCategories.remove(category);
                          } else {
                            _selectedCategories.add(category);
                          }
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
            SizedBox(height: 24.h),

            // Price Label
            Row(
              children: [
                Text(
                  "Price",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  "(Select one)",
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                    color: AppColors.lightText,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Price Horizontal Scroll Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: _prices.map((price) {
                  final isSelected = _selectedPrice == price;
                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: FilterChipWidget(
                      label: price,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _selectedPrice = price;
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
