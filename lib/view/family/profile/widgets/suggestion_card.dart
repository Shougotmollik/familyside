import 'package:familyside/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum SuggestionStatus { approved, pending }

class SuggestionCard extends StatelessWidget {
  final String imagePath;
  final String category;
  final String title;
  final String description;
  final String location;
  final SuggestionStatus status;
  final VoidCallback? onTap;

  const SuggestionCard({
    super.key,
    required this.imagePath,
    required this.category,
    required this.title,
    required this.description,
    required this.location,
    required this.status,
    this.onTap,
  });

  static const Color _categoryText = Color(0xFFE57373);
  static const Color _approvedBackground = Color(0xFFE8F5E9);
  static const Color _approvedText = Color(0xFF4CAF50);
  static const Color _pendingBackground = Color(0xFFFFF3E0);
  static const Color _pendingText = Color(0xFFFF9800);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SuggestionImage(
                imagePath: imagePath,
                category: category,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 12.sp,
                        color: AppColors.lightText,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14.sp,
                          color: AppColors.mutedIcon,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 12.sp,
                              color: AppColors.lightText,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: _SuggestionStatusBadge(status: status),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuggestionImage extends StatelessWidget {
  final String imagePath;
  final String category;

  const _SuggestionImage({
    required this.imagePath,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      height: 100.h,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: _buildImage(),
          ),
          Positioned(
            top: 6.h,
            left: 6.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: SuggestionCard._categoryText,
                  width: 1,
                ),
              ),
              child: Text(
                category,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: SuggestionCard._categoryText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        width: 100.w,
        height: 100.h,
        fit: BoxFit.cover,
        errorBuilder: _errorPlaceholder,
      );
    }
    return Image.asset(
      imagePath,
      width: 100.w,
      height: 100.h,
      fit: BoxFit.cover,
      errorBuilder: _errorPlaceholder,
    );
  }

  Widget _errorPlaceholder(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return Container(
      width: 100.w,
      height: 100.h,
      color: AppColors.border,
      child: Icon(
        Icons.image_outlined,
        color: AppColors.mutedIcon,
        size: 28.sp,
      ),
    );
  }
}

class _SuggestionStatusBadge extends StatelessWidget {
  final SuggestionStatus status;

  const _SuggestionStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isApproved = status == SuggestionStatus.approved;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isApproved
            ? SuggestionCard._approvedBackground
            : SuggestionCard._pendingBackground,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        isApproved ? 'Approved' : 'Pending',
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: isApproved
              ? SuggestionCard._approvedText
              : SuggestionCard._pendingText,
        ),
      ),
    );
  }
}
