import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/model/gift_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GiftDetailsScreen extends StatefulWidget {
  final GiftItemModel item;

  const GiftDetailsScreen({super.key, required this.item});

  @override
  State<GiftDetailsScreen> createState() => _GiftDetailsScreenState();
}

class _GiftDetailsScreenState extends State<GiftDetailsScreen> {
  bool _isBookmarked = false;
  bool _isDescriptionExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Dynamic/fallback values based on the specific item if it matches the screenshot
    final isMassageWorkshop = widget.item.title.toLowerCase().contains('message') || 
                              widget.item.title.toLowerCase().contains('massage') ||
                              widget.item.title.toLowerCase().contains('workshop');

    final titleText = isMassageWorkshop ? 'Baby Message Workshop' : widget.item.title;
    final priceText = widget.item.price.startsWith('\$') ? widget.item.price : '\$${widget.item.price}';
    
    // Description text matching the mockup if applicable
    final descriptionText = isMassageWorkshop 
        ? 'Welcome to Adventure Play Center, where children can explore, learn, and have fun in a safe and engaging environment. Our facility offers a wide range of activities designed to promote physical development, creativity, and social skills.'
        : widget.item.description.isNotEmpty 
            ? widget.item.description 
            : 'Welcome to our specialized workshop, designed to offer children a safe, engaging, and enriching environment where they can learn and grow.';

    // Inclusions list from mockup
    final includesList = isMassageWorkshop
        ? [
            '1 class',
            'Materials for the message',
            'Duration: 2 Hours',
          ]
        : [
            'Access to all activities',
            'All materials provided',
            'Duration: 1.5 Hours',
          ];

    // Age tags from mockup
    final ageTags = isMassageWorkshop
        ? [
            'Toddlers (3-5)',
            'Kids (6-10)',
            'Pre-teens (10-15)',
          ]
        : [
            'Toddlers (3-5)',
            'Kids (6-12)',
          ];

    final locationText = widget.item.location.toLowerCase().contains('green') 
        ? '1.7 km' 
        : widget.item.location;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Header Image & Overlay Information
                _buildHeroHeader(titleText, locationText),
                
                // Bottom Rounded Details Container
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
                        // Description Title & Paragraph
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

                        // Offered by section
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
                          'IPSUM',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                            color: const Color(0xFF1D1B20),
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // Includes section
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

          // Top Header Floating Navigation Controls
          _buildFloatingTopBar(),

          // Bottom Action Button
          _buildBottomActionButton(),
        ],
      ),
    );
  }

  Widget _buildHeroHeader(String titleText, String locationText) {
    return Stack(
      children: [
        // Background Hero Image
        SizedBox(
          height: 380.h,
          width: double.infinity,
          child: Image.asset(
            widget.item.imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey.shade200,
                child: Icon(
                  Icons.image_outlined,
                  size: 64.sp,
                  color: Colors.grey,
                ),
              );
            },
          ),
        ),

        // Dark/Gradient overlay for readability
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

        // Title and badge overlays at the bottom of the image container
        Positioned(
          bottom: 44.h, // Offset slightly to account for the overlapping curved sheet
          left: 20.w,
          right: 20.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title row with "Gift idea" on the right
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      titleText,
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

              // Bottom Badges: "Gift" chip and Location info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00B074), // Vibrant emerald green from screenshot
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
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                        size: 16.sp,
                      ),
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
              // Back Button
              _circleActionButton(
                icon: Icons.arrow_back,
                onTap: () => Navigator.of(context).pop(),
              ),
              
              // Action Buttons: Share & Bookmark
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
                      setState(() {
                        _isBookmarked = !_isBookmarked;
                      });
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
        child: Icon(
          icon,
          color: iconColor,
          size: 20.sp,
        ),
      ),
    );
  }

  Widget _buildDescriptionWidget(String text) {
    // Basic read more/less logic
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
                    onTap: () {
                      setState(() {
                        _isDescriptionExpanded = !_isDescriptionExpanded;
                      });
                    },
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
              // Custom styled check icon
              Icon(
                Icons.check_circle_rounded,
                color: const Color(0xFF9DC183), // Green checkmark matching secondaryLight
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
            color: const Color(0xFFFFF0F2), // Light pink background
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
