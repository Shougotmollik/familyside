import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:familyside/core/router/router_path.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/env.dart';
import 'package:familyside/model/gift_item_model.dart';
import 'package:familyside/view/family/explorer/models/explorer_map_item.dart';
import 'package:familyside/view/family/gift/gift_all_screen.dart';
import 'package:familyside/view/family/home/family_home_screen.dart';
import 'package:familyside/view/family/home/recomandation_screen.dart';
import 'package:familyside/view/widgets/event_card.dart';
import 'package:familyside/view/widgets/google_map.dart';

class ActivityDetailsConfig {
  final String imagePath;
  final String title;
  final String category;
  final String distance;
  final String price;
  final String ageRange;
  final String tag;

  const ActivityDetailsConfig({
    required this.imagePath,
    required this.title,
    required this.category,
    required this.distance,
    required this.price,
    required this.ageRange,
    required this.tag,
  });

  factory ActivityDetailsConfig.fromItem(RecommendedItemModel item) {
    return ActivityDetailsConfig(
      imagePath: item.imagePath,
      title: item.title,
      category: item.category,
      distance: item.distance,
      price: item.price,
      ageRange: item.ageRange,
      tag: item.tag,
    );
  }

  factory ActivityDetailsConfig.fromMapItem(ExplorerMapItem item) {
    return ActivityDetailsConfig(
      imagePath: item.imagePath,
      title: item.title,
      category: item.category,
      distance: item.distance,
      price: item.price,
      ageRange: item.ageRange,
      tag: item.tag,
    );
  }
}

class ActivityDetailsScreen extends StatefulWidget {
  const ActivityDetailsScreen({super.key, required this.config});

  final ActivityDetailsConfig config;

  @override
  State<ActivityDetailsScreen> createState() => _ActivityDetailsScreenState();
}

class _ActivityDetailsScreenState extends State<ActivityDetailsScreen> {
  bool _descExpanded = false;
  bool _isBookmarked = false;

  static const LatLng _demoLocation = LatLng(37.4219, -122.0840);

  static const String _description =
      'Welcome to Adventure Play Center, where children can explore, learn, and have fun in a safe and engaging environment. Our facility offers a wide range of activities designed to promote physical development, creativity, and social skills.';

  static const List<RecommendedItemModel> _events = [
    RecommendedItemModel(
      imagePath: 'assets/image/doctor.jpg',
      category: 'Health',
      date: '25 Jun',
      title: 'Little Stars Pediatric Clinic',
      price: '20',
      distance: '0.05 km',
      ageRange: 'Age: 0-20 years',
      tag: 'Recommended',
    ),
    RecommendedItemModel(
      imagePath: 'assets/image/doctor.jpg',
      category: 'Health',
      date: '25 Jun',
      title: 'Little Stars Pediatric Clinic',
      price: '20',
      distance: '0.05 km',
      ageRange: 'Age: 0-20 years',
      tag: 'Recommended',
    ),
  ];

  static const List<GiftItemModel> _gifts = [
    GiftItemModel(
      imagePath: 'assets/image/doctor.jpg',
      title: '1 month activity pass',
      price: '\$45',
      description: 'Gift a month of fun activities',
      location: 'Green meadows ark',
    ),
    GiftItemModel(
      imagePath: 'assets/image/doctor.jpg',
      title: '1 month activity pass',
      price: '\$45',
      description: 'Gift a month of fun activities',
      location: 'Green meadows ark',
    ),
  ];

  static const List<_ReviewModel> _reviews = [
    _ReviewModel(
      name: 'Shahid Hasan',
      tag: 'Recommended',
      text:
          'Amazing place! My kids absolutely loved it. The staff is friendly and attentive. We\'ll definitely be coming back!',
    ),
    _ReviewModel(
      name: 'Shahid Hasan',
      tag: 'Recommended',
      text:
          'Amazing place! My kids absolutely loved it. The staff is friendly and attentive. We\'ll definitely be coming back!',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final config = widget.config;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero image
                _buildHeroImage(config),

                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 0),
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
                      _buildDescription(),
                      SizedBox(height: 20.h),

                      // Action icons row
                      _buildActionIcons(),
                      SizedBox(height: 20.h),

                      // Mini map
                      _buildMiniMap(),
                      SizedBox(height: 8.h),

                      // Address + hours
                      _buildAddressRow(),
                      SizedBox(height: 24.h),

                      // Events section
                      _buildSectionHeader(
                        'Events',
                        onSeeAll: () => context.push(
                          RouterPath.familyRecommendationScreen,
                          extra: ListScreenConfig(
                            title: 'Events',
                            items: _events,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      ..._events.map(
                        (e) => EventCard(
                          imagePath: e.imagePath,
                          category: e.category,
                          date: e.date,
                          title: e.title,
                          price: e.price,
                          distance: e.distance,
                          ageRange: e.ageRange,
                          tag: e.tag,
                        ),
                      ),
                      SizedBox(height: 8.h),

                      // Gift ideas section
                      _buildSectionHeader(
                        'Gift ideas',
                        onSeeAll: () => context.push(
                          RouterPath.familyGiftAllScreen,
                          extra: GiftAllScreenConfig(
                            title: 'Gift ideas',
                            items: _gifts,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      SizedBox(
                        height: 160.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _gifts.length,
                          itemBuilder: (_, i) => _buildGiftChip(_gifts[i]),
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Reviews section
                      Text(
                        'Reviews',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      ..._reviews.map((r) => _buildReviewCard(r)),

                      // Bottom padding for FAB
                      SizedBox(height: 80.h),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 28.h),
              color: Colors.white,
              child: GestureDetector(
                onTap: () => context.push(RouterPath.familyWriteReviewScreen),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Center(
                    child: Text(
                      'Leave a review',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage(ActivityDetailsConfig config) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 260.h,
          child: Image.asset(
            config.imagePath,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey.shade300,
              child: Icon(
                Icons.image_outlined,
                size: 48.sp,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        // Dark gradient overlay
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.55),
                ],
              ),
            ),
          ),
        ),
        // Top bar
        SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _circleBtn(
                  Icons.arrow_back_ios_new_rounded,
                  () => context.pop(),
                ),
                Row(
                  children: [
                    _circleBtn(Icons.share_outlined, () {}),
                    SizedBox(width: 8.w),
                    _circleBtn(
                      _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      () => setState(() => _isBookmarked = !_isBookmarked),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Title + badge at bottom of image
        Positioned(
          bottom: 14.h,
          left: 16.w,
          right: 16.w,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      config.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryLight,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        config.tag,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: Colors.white,
                    size: 14.sp,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    config.distance,
                    style: TextStyle(color: Colors.white, fontSize: 12.sp),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18.sp, color: AppColors.text),
      ),
    );
  }

  Widget _buildDescription() {
    final maxLines = _descExpanded ? null : 3;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _description,
          maxLines: maxLines,
          overflow: _descExpanded
              ? TextOverflow.visible
              : TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.lightText,
            height: 1.6,
          ),
        ),
        GestureDetector(
          onTap: () => setState(() => _descExpanded = !_descExpanded),
          child: Text(
            _descExpanded ? 'Show less' : 'Read more',
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.primaryLight,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionIcons() {
    final actions = [
      _ActionItem('assets/icon/globe.svg', 'Website'),
      _ActionItem('assets/icon/instagram.svg', 'Instagram'),
      _ActionItem('assets/icon/whatsapp.svg', 'WhatsApp'),
      _ActionItem('assets/icon/call.svg', 'Call'),
      _ActionItem('assets/icon/mage_direction.svg', 'Direction'),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actions.map((a) {
        return Container(
          height: 70.h,
          width: 75.w,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SvgPicture.asset(a.iconPath, width: 24.w, height: 24.w),
              ),
              SizedBox(height: 6.h),
              Text(
                a.label,
                style: TextStyle(fontSize: 11.sp, color: AppColors.lightText),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMiniMap() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: SizedBox(
        height: 140.h,
        child: GoogleMapScreen(
          apiKey: EnvHandler.googleMapApiKey,
          initialPosition: _demoLocation,
          withScaffold: false,
          canSelectLocation: false,
        ),
      ),
    );
  }

  Widget _buildAddressRow() {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: AppColors.grey,
                size: 14.sp,
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  '321 Arts Boulevard, Creative District',
                  style: TextStyle(fontSize: 12.sp, color: AppColors.lightText),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        Row(
          children: [
            Icon(Icons.access_time, color: AppColors.grey, size: 14.sp),
            SizedBox(width: 4.w),
            Text(
              'Open time\n07:00 AM to 09:00PM',
              style: TextStyle(fontSize: 11.sp, color: AppColors.lightText),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {required VoidCallback onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.text,
          ),
        ),
        GestureDetector(
          onTap: onSeeAll,
          child: Text(
            'See All',
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.primaryLight,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // Gift chip

  Widget _buildGiftChip(GiftItemModel gift) {
    return Container(
      width: 140.w,
      margin: EdgeInsets.only(right: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                child: Image.asset(
                  gift.imagePath,
                  width: 140.w,
                  height: 90.h,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 140.w,
                    height: 90.h,
                    color: Colors.grey.shade200,
                  ),
                ),
              ),
              Positioned(
                top: 6.h,
                left: 6.w,
                child: Container(
                  padding: EdgeInsets.all(5.w),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.bookmark, color: Colors.white, size: 12.sp),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  gift.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  gift.price,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Review card

  Widget _buildReviewCard(_ReviewModel review) {
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
          Row(
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/image/demo_image.jpg',
                  width: 40.w,
                  height: 40.w,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 40.w,
                    height: 40.w,
                    color: AppColors.border,
                    child: Icon(
                      Icons.person,
                      color: AppColors.grey,
                      size: 20.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.name,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryLight.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        review.tag,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColors.secondaryLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'See more >',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.primaryLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            review.text,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.lightText,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

//Models
class _ActionItem {
  final String iconPath;
  final String label;
  const _ActionItem(this.iconPath, this.label);
}

class _ReviewModel {
  final String name;
  final String tag;
  final String text;
  const _ReviewModel({
    required this.name,
    required this.tag,
    required this.text,
  });
}
