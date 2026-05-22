import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/model/search_data.dart';
import 'package:familyside/view/family/search/widgets/browse_category_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BrowseCategorySection extends StatelessWidget {
  const BrowseCategorySection({
    super.key,
    this.title = 'Browse by Category',
    required this.categories,
    this.onCategoryTap,
  });

  final String title;
  final List<BrowseCategoryItem> categories;
  final void Function(BrowseCategoryItem item)? onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
        SizedBox(height: 12.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12.h,
            crossAxisSpacing: 12.w,
            childAspectRatio: 2.6,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final item = categories[index];
            return BrowseCategoryCard(
              item: item,
              onTap: onCategoryTap != null ? () => onCategoryTap!(item) : null,
            );
          },
        ),
      ],
    );
  }
}
