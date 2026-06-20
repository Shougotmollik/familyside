import 'package:cached_network_image/cached_network_image.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/model/activity_details.dart';
import 'package:familyside/provider/family/explorer_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class GiftDetailScreen extends ConsumerStatefulWidget {
  final int itemId;

  const GiftDetailScreen({super.key, required this.itemId});

  @override
  ConsumerState<GiftDetailScreen> createState() => _GiftDetailScreenState();
}

class _GiftDetailScreenState extends ConsumerState<GiftDetailScreen> {
  bool _isBookmarked = false;
  bool _isDescriptionExpanded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(activityDetailsProviderProvider.notifier)
          .fetchDetails(widget.itemId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final detailsState = ref.watch(activityDetailsProviderProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: detailsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $err', textAlign: TextAlign.center),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () => ref
                    .read(activityDetailsProviderProvider.notifier)
                    .fetchDetails(widget.itemId),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (details) => _buildDetailsContent(details),
      ),
    );
  }

  Widget _buildDetailsContent(ActivityDetails details) {
    final priceText = '\$${details.id == 0 ? '0' : details.relatedEvents.isNotEmpty ? details.relatedEvents.first.price.toStringAsFixed(0) : '0'}';
    final descriptionText = details.description.isNotEmpty
        ? details.description
        : 'Welcome to our specialized gift, designed to offer children a safe, engaging, and enriching experience.';
    final includesList = [
      'Access to all activities',
      'All materials provided',
      'Duration: 1.5 Hours',
    ];
    final ageTags = [
      'Toddlers (3-5)',
      'Kids (6-12)',
    ];
    final locationText = details.address.isNotEmpty ? details.address : 'N/A';

    return Stack(
      children: [
        SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroHeader(details, priceText, locationText),
              Transform.translate(
                offset: const Offset(0, -28),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28.r),
                      topRight: Radius.circular(28.r),
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 100.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      _buildDescriptionWidget(descriptionText),
                      SizedBox(height: 24.h),

                      // Reviews section
                      if (details.reviews.isNotEmpty) ...[
                        Row(children: [
                          Text('Reviews',
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.text)),
                          if (details.averageRatingLabel.isNotEmpty) ...[
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 3.h),
                              decoration: BoxDecoration(
                                  color: AppColors.secondaryLight
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12.r)),
                              child: Text(details.averageRatingLabel,
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.secondaryLight,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ]),
                        SizedBox(height: 12.h),
                        ...details.reviews.take(2).map((r) => _buildReviewCard(r)),
                        SizedBox(height: 24.h),
                      ],

                      // Offered by
                      Text(
                        'Offered by',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        details.categoryName.isNotEmpty ? details.categoryName.toUpperCase() : 'PROVIDER',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                          color: const Color(0xFF1D1B20),
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Includes
                      Text(
                        'Includes',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _buildIncludesList(includesList),
                      SizedBox(height: 24.h),

                      // Age range tags
                      _buildAgeTagsRow(ageTags),
                      SizedBox(height: 28.h),

                      // Price
                      Text(
                        priceText,
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        _buildFloatingTopBar(),
        _buildBottomActionButton(),
      ],
    );
  }

  Widget _buildHeroHeader(ActivityDetails details, String priceText, String locationText) {
    final hasImage = details.imageUrl != null && details.imageUrl!.isNotEmpty;
    return Stack(
      children: [
        SizedBox(
          height: 380.h,
          width: double.infinity,
          child: hasImage
              ? CachedNetworkImage(
                  imageUrl: details.imageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                      color: Colors.grey.shade200,
                      child: Icon(Icons.image_outlined, size: 64.sp, color: Colors.grey)),
                  errorWidget: (context, url, error) => _imagePlaceholder())
              : _imagePlaceholder(),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.4),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.65),
                ],
                stops: const [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 44.h,
          left: 20.w,
          right: 20.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      details.name.isNotEmpty ? details.name : 'Gift',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      'Gift idea',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00B074),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      'Gift',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: Colors.white, size: 16.sp),
                      SizedBox(width: 4.w),
                      Text(
                        locationText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: Icon(Icons.image_outlined, size: 64.sp, color: Colors.grey),
    );
  }

  Widget _buildFloatingTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _circleActionButton(
                icon: Icons.arrow_back,
                onTap: () => context.pop(),
              ),
              Row(
                children: [
                  _circleActionButton(
                    icon: Icons.share_outlined,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Link copied to clipboard!')),
                      );
                    },
                  ),
                  SizedBox(width: 10.w),
                  _circleActionButton(
                    icon: _isBookmarked ? Icons.bookmark : Icons.bookmark_border_rounded,
                    iconColor: _isBookmarked ? AppColors.primaryLight : Colors.white,
                    onTap: () {
                      setState(() => _isBookmarked = !_isBookmarked);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _isBookmarked ? 'Added to bookmarks!' : 'Removed from bookmarks.',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circleActionButton({
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38.w,
        width: 38.w,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.35),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: iconColor, size: 20.sp),
      ),
    );
  }

  Widget _buildDescriptionWidget(String text) {
    final isLongText = text.length > 150;
    final showExpanded = !isLongText || _isDescriptionExpanded;
    final displayText = showExpanded ? text : '${text.substring(0, 140)}...';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 13.5.sp,
              color: AppColors.lightText,
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
            children: [
              TextSpan(text: displayText),
              if (isLongText)
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () => setState(() => _isDescriptionExpanded = !_isDescriptionExpanded),
                    child: Text(
                      _isDescriptionExpanded ? ' Show less' : ' Read more',
                      style: TextStyle(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryLight,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIncludesList(List<String> items) {
    return Column(
      children: items.map((item) {
        return Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: const Color(0xFF9DC183),
                size: 20.sp,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.text,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAgeTagsRow(List<String> tags) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: tags.map((tag) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF0F2),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            tag,
            style: TextStyle(
              color: AppColors.primaryLight,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildReviewCard(ActivityDetailsReview review) {
    final hasImage = review.userImage != null && review.userImage!.isNotEmpty;
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            ClipOval(
              child: hasImage
                  ? CachedNetworkImage(
                      imageUrl: review.userImage!,
                      width: 40.w,
                      height: 40.w,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => _personPlaceholder())
                  : _personPlaceholder(),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(review.userName,
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text)),
                  if (review.recommendationLevel.isNotEmpty) ...[
                    SizedBox(height: 3.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(
                          color: AppColors.secondaryLight.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20.r)),
                      child: Text(review.recommendationLevel,
                          style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.secondaryLight,
                              fontWeight: FontWeight.w500)),
                    ),
                  ],
                ],
              ),
            ),
            if (review.date.isNotEmpty)
              Text(review.date, style: TextStyle(fontSize: 11.sp, color: AppColors.grey)),
          ]),
          SizedBox(height: 10.h),
          Text(review.comment,
              style: TextStyle(fontSize: 13.sp, color: AppColors.lightText, height: 1.5)),
        ],
      ),
    );
  }

  Widget _personPlaceholder() {
    return Container(
      width: 40.w,
      height: 40.w,
      color: AppColors.border,
      child: Icon(Icons.person, color: AppColors.grey, size: 20.sp),
    );
  }

  Widget _buildBottomActionButton() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
        child: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                title: const Text('Claim Voucher'),
                content: const Text(
                  'Your voucher has been claimed and added to your wallet successfully!',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'OK',
                      style: TextStyle(color: AppColors.primaryLight),
                    ),
                  ),
                ],
              ),
            );
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 14.h),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryLight.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              'Get voucher',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
