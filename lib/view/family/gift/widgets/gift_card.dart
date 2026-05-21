import 'package:familyside/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class GiftCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String price;
  final String description;
  final String location;
  final bool isBookmarked;
  final VoidCallback? onTap;
  final VoidCallback? onAddToGiftList;
  final VoidCallback? onShareTap;
  final VoidCallback? onBookmarkTap;

  const GiftCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.price,
    required this.description,
    required this.location,
    this.isBookmarked = false,
    this.onTap,
    this.onAddToGiftList,
    this.onShareTap,
    this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFF2F2F2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _GiftImage(
              imagePath: imagePath,
              isBookmarked: isBookmarked,
              onBookmarkTap: onBookmarkTap,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _GiftCardContent(
                title: title,
                price: price,
                description: description,
                location: location,
                onAddToGiftList: onAddToGiftList,
                onShareTap: onShareTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GiftImage extends StatelessWidget {
  final String imagePath;
  final bool isBookmarked;
  final VoidCallback? onBookmarkTap;

  const _GiftImage({
    required this.imagePath,
    required this.isBookmarked,
    this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Image.asset(
            imagePath,
            width: 120.w,
            height: 130.h,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 120.w,
                height: 130.h,
                color: Colors.grey.shade200,
                child: Icon(
                  Icons.broken_image,
                  color: Colors.grey,
                  size: 30.sp,
                ),
              );
            },
          ),
        ),
        Positioned(
          top: 8.h,
          left: 8.w,
          child: GestureDetector(
            onTap: onBookmarkTap,
            child: Container(
              height: 28.w,
              width: 28.w,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: AppColors.primaryLight,
                size: 16.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GiftCardContent extends StatelessWidget {
  final String title;
  final String price;
  final String description;
  final String location;
  final VoidCallback? onAddToGiftList;
  final VoidCallback? onShareTap;

  const _GiftCardContent({
    required this.title,
    required this.price,
    required this.description,
    required this.location,
    this.onAddToGiftList,
    this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              price.startsWith('\$') ? price : '\$$price',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryLight,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        Text(
          description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.lightText,
            height: 1.35,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppColors.secondaryLight.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Text(
            location,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6C7278),
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onAddToGiftList,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 14.sp),
                      SizedBox(width: 4.w),
                      Text(
                        'Gift list',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: onShareTap,
              child: Container(
                height: 34.h,
                width: 34.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.layers_outlined,
                  color: AppColors.primaryLight,
                  size: 20.sp,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
