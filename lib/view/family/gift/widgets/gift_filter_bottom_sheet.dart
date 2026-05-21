import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/view/family/gift/widgets/gift_filter_result_model.dart';
import 'package:familyside/view/widgets/custom_elevated_button.dart';
import 'package:familyside/view/widgets/filter_chip_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GiftFilterBottomSheet extends StatefulWidget {
  final GiftFilterResultModel? initialFilters;

  const GiftFilterBottomSheet({super.key, this.initialFilters});

  @override
  State<GiftFilterBottomSheet> createState() => _GiftFilterBottomSheetState();
}

class _GiftFilterBottomSheetState extends State<GiftFilterBottomSheet> {
  String? _recipient;
  String? _forWhom;
  String? _childAge;
  String? _price;

  static const _recipients = ['Child', 'Adult'];
  static const _forWhomOptions = ['Boy', 'Girl', 'Unisex'];
  static const _childAges = [
    '0-3 years',
    '3-8 years',
    '8-13 years',
    '15+ years',
  ];
  static const _prices = [
    'Under \$25',
    '\$25 - \$50',
    '\$50 - \$100',
    '\$100+',
  ];

  @override
  void initState() {
    super.initState();
    final initial = widget.initialFilters;
    if (initial != null) {
      _recipient = initial.recipient;
      _forWhom = initial.forWhom;
      _childAge = initial.childAge;
      _price = initial.price;
    }
  }

  void _clearAll() {
    setState(() {
      _recipient = null;
      _forWhom = null;
      _childAge = null;
      _price = null;
    });
  }

  void _applyFilter() {
    Navigator.pop(
      context,
      GiftFilterResultModel(
        recipient: _recipient,
        forWhom: _forWhom,
        childAge: _childAge,
        price: _price,
      ),
    );
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Result',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.close,
                    size: 24.sp,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Divider(height: 1.h, color: AppColors.divider),
            SizedBox(height: 20.h),
            _buildFilterSection(
              label: 'Recipient',
              options: _recipients,
              selected: _recipient,
              onSelected: (value) => setState(() => _recipient = value),
            ),
            SizedBox(height: 24.h),
            _buildFilterSection(
              label: 'For whom',
              options: _forWhomOptions,
              selected: _forWhom,
              onSelected: (value) => setState(() => _forWhom = value),
            ),
            SizedBox(height: 24.h),
            _buildFilterSection(
              label: 'Child Age',
              options: _childAges,
              selected: _childAge,
              onSelected: (value) => setState(() => _childAge = value),
            ),
            SizedBox(height: 24.h),
            _buildFilterSection(
              label: 'Price',
              options: _prices,
              selected: _price,
              onSelected: (value) => setState(() => _price = value),
            ),
            SizedBox(height: 32.h),
            CustomElevatedButton(
              onPressed: _applyFilter,
              title: 'Apply Filter',
              color: AppColors.primaryLight,
              textColor: Colors.white,
            ),
            SizedBox(height: 12.h),
            CustomElevatedButton(
              onPressed: _clearAll,
              title: 'Clear all',
              color: AppColors.primaryLight.withValues(alpha: 0.1),
              textColor: AppColors.primaryLight,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection({
    required String label,
    required List<String> options,
    required String? selected,
    required ValueChanged<String> onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
        SizedBox(height: 12.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: options.map((option) {
              final isSelected = selected == option;
              return Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: FilterChipWidget(
                  label: option,
                  isSelected: isSelected,
                  onTap: () => onSelected(option),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
