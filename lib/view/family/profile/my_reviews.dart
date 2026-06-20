import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/model/family_review.dart';
import 'package:familyside/provider/family/family_profile_provider.dart';
import 'package:familyside/view/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyReviewsScreen extends ConsumerStatefulWidget {
  const MyReviewsScreen({super.key});

  @override
  ConsumerState<MyReviewsScreen> createState() => _MyReviewsScreenState();
}

class _MyReviewsScreenState extends ConsumerState<MyReviewsScreen> {
  List<FamilyReview> _reviews = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchReviews());
  }

  Future<void> _fetchReviews() async {
    final items = await ref.read(familyProfileProvider.notifier).getReviews();
    if (!mounted) return;
    setState(() {
      _reviews = items;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.border,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
              child: const CustomAppBar(title: 'My Reviews'),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _reviews.isEmpty
                      ? _buildEmptyState(theme)
                      : RefreshIndicator(
                          onRefresh: _fetchReviews,
                          child: ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 24.h),
                            itemCount: _reviews.length,
                            separatorBuilder: (_, _) => SizedBox(height: 12.h),
                            itemBuilder: (context, index) =>
                                _ReviewCard(review: _reviews[index]),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.rate_review_outlined,
            size: 48.sp,
            color: AppColors.lightText,
          ),
          SizedBox(height: 16.h),
          Text(
            'No reviews yet',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.text,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Your reviews will appear here once you write some',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.lightText,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final FamilyReview review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Place name and recommendation badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  review.placeName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.thumb_up_alt,
                      size: 12.sp,
                      color: const Color(0xFF4CAF50),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      review.recommendationLabel,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF4CAF50),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          // Date row
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 14.sp,
                color: AppColors.mutedIcon,
              ),
              SizedBox(width: 6.w),
              Text(
                review.date,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 12.sp,
                  color: AppColors.lightText,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Comment
          Text(
            review.comment,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 13.sp,
              color: AppColors.text,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
