import 'package:cached_network_image/cached_network_image.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/model/sp_item_details.dart';
import 'package:familyside/provider/service_provider/sp_manage_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SpItemDetailsScreen extends ConsumerStatefulWidget {
  final int itemId;

  const SpItemDetailsScreen({super.key, required this.itemId});

  @override
  ConsumerState<SpItemDetailsScreen> createState() =>
      _SpItemDetailsScreenState();
}

class _SpItemDetailsScreenState extends ConsumerState<SpItemDetailsScreen> {
  bool _descExpanded = false;
  SpItemDetails? _details;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadDetails());
  }

  Future<void> _loadDetails() async {
    final details = await ref
        .read(spManageProviderProvider.notifier)
        .fetchItemDetails(itemId: widget.itemId);
    if (mounted) {
      setState(() {
        _details = details;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _details == null
          ? _buildError()
          : _buildContent(_details!),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 48.sp),
          SizedBox(height: 16.h),
          Text(
            'Failed to load details',
            style: TextStyle(fontSize: 16.sp, color: AppColors.text),
          ),
          SizedBox(height: 12.h),
          ElevatedButton(
            onPressed: () {
              setState(() => _isLoading = true);
              _loadDetails();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(SpItemDetails details) {
    final isActivity = details.itemType == 'activity';
    final isEvent = details.itemType == 'event';

    Color typeBadgeColor;
    if (isActivity) {
      typeBadgeColor = AppColors.secondaryLight;
    } else if (isEvent) {
      typeBadgeColor = const Color(0xFF9C27B0);
    } else {
      typeBadgeColor = AppColors.primaryLight;
    }

    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroImage(details, typeBadgeColor),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (details.price > 0) ...[
                      Text(
                        '\$${details.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryLight,
                        ),
                      ),
                      SizedBox(height: 12.h),
                    ],

                    // Status badge
                    if (details.status.isNotEmpty) ...[
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: details.status == 'active'
                              ? Colors.green.withValues(alpha: 0.1)
                              : Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          details.status.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: details.status == 'active'
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                    ],

                    if (details.description.isNotEmpty) ...[
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      _buildDescription(details.description),
                      SizedBox(height: 20.h),
                    ],

                    _buildActionIcons(details),
                    SizedBox(height: 20.h),

                    _buildAddressRow(details),
                    SizedBox(height: 24.h),

                    if (isActivity && details.openingDays != null) ...[
                      _buildSectionHeader('Opening Days'),
                      SizedBox(height: 12.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(14.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          details.openingDays!,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.lightText,
                            height: 1.5,
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                    ],

                    if (isEvent && details.date != null) ...[
                      _buildSectionHeader('Date & Time'),
                      SizedBox(height: 12.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(14.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.event_outlined,
                              color: AppColors.grey,
                              size: 16.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              details.date!,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: AppColors.lightText,
                              ),
                            ),
                            if (details.time != null) ...[
                              SizedBox(width: 16.w),
                              Icon(
                                Icons.access_time,
                                color: AppColors.grey,
                                size: 16.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                details.time!,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: AppColors.lightText,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),
                    ],

                    // Sub-categories
                    if (details.subCategories.isNotEmpty) ...[
                      _buildSectionHeader('Sub-categories'),
                      SizedBox(height: 12.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: details.subCategories.map((cat) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              cat,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.primaryLight,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 24.h),
                    ],

                    // Tags
                    if (details.tags.isNotEmpty) ...[
                      _buildSectionHeader('Tags'),
                      SizedBox(height: 12.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: details.tags.map((tag) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.border.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.lightText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 80.h),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),

        // Sticky bottom button — exactly like family's "Leave a review"
        // Positioned(
        //   bottom: 0,
        //   left: 0,
        //   right: 0,
        //   child: Container(
        //     padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 28.h),
        //     color: Colors.white,
        //     child: GestureDetector(
        //       onTap: () => context.pop(),
        //       child: Container(
        //         padding: EdgeInsets.symmetric(vertical: 16.h),
        //         decoration: BoxDecoration(
        //           color: AppColors.primaryLight,
        //           borderRadius: BorderRadius.circular(30.r),
        //         ),
        //         child: Center(
        //           child: Text(
        //             'Back to List',
        //             style: TextStyle(
        //               color: Colors.white,
        //               fontSize: 15.sp,
        //               fontWeight: FontWeight.w600,
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  // EXACTLY same as family _circleBtn
  Widget _circleBtn(IconData icon, VoidCallback? onTap, {Color? iconColor}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18.sp, color: iconColor ?? AppColors.text),
      ),
    );
  }

  // EXACTLY same hero structure as family — buttons INSIDE the hero stack
  Widget _buildHeroImage(SpItemDetails details, Color typeBadgeColor) {
    final hasImage = details.imageUrl != null && details.imageUrl!.isNotEmpty;
    final isEvent = details.itemType == 'event';

    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 260.h,
          child: hasImage
              ? CachedNetworkImage(
                  imageUrl: details.imageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey.shade300,
                    child: Icon(
                      Icons.image_outlined,
                      size: 48.sp,
                      color: Colors.grey,
                    ),
                  ),
                  errorWidget: (context, url, error) => _imagePlaceholder(),
                )
              : _imagePlaceholder(),
        ),
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

        // Back + share buttons INSIDE hero stack — exactly like family
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
                _circleBtn(Icons.share_outlined, () {}),
              ],
            ),
          ),
        ),

        // Title overlay at bottom — exactly like family
        Positioned(
          bottom: 14.h,
          left: 16.w,
          right: 16.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                details.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: typeBadgeColor,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      details.itemType.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (isEvent && details.date != null) ...[
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_month_outlined,
                            color: Colors.white,
                            size: 10.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            details.date!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const Spacer(),
                  if (details.location.isNotEmpty) ...[
                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.white,
                      size: 14.sp,
                    ),
                    SizedBox(width: 3.w),
                    Flexible(
                      child: Text(
                        details.location,
                        style: TextStyle(color: Colors.white, fontSize: 12.sp),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
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
      color: Colors.grey.shade300,
      child: Icon(Icons.image_outlined, size: 48.sp, color: Colors.grey),
    );
  }

  // EXACTLY same as family
  Widget _buildDescription(String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          description,
          maxLines: _descExpanded ? null : 3,
          overflow: _descExpanded
              ? TextOverflow.visible
              : TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.lightText,
            height: 1.6,
          ),
        ),
        if (description.length > 150)
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

  // EXACTLY same as family
  Widget _buildActionIcons(SpItemDetails details) {
    final actions = <_ActionIcon>[];
    if (details.website != null && details.website!.isNotEmpty) {
      actions.add(_ActionIcon('assets/icon/globe.svg', 'Website'));
    }
    if (details.instagram != null && details.instagram!.isNotEmpty) {
      actions.add(_ActionIcon('assets/icon/instagram.svg', 'Instagram'));
    }
    if (details.whatsapp != null && details.whatsapp!.isNotEmpty) {
      actions.add(_ActionIcon('assets/icon/whatsapp.svg', 'WhatsApp'));
    }
    if (details.email != null && details.email!.isNotEmpty) {
      actions.add(_ActionIcon('email', 'Email'));
    }

    if (actions.isEmpty) return const SizedBox.shrink();

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
                child: a.iconPath == 'email'
                    ? Icon(
                        Icons.email_outlined,
                        size: 22.sp,
                        color: AppColors.text.withValues(alpha: 0.7),
                      )
                    : SvgPicture.asset(a.iconPath, width: 24.w, height: 24.w),
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

  // EXACTLY same as family
  Widget _buildAddressRow(SpItemDetails details) {
    return Row(
      children: [
        if (details.location.isNotEmpty)
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
                    details.location,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.lightText,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        if (details.location.isNotEmpty &&
            details.openingHours != null &&
            details.openingHours!.isNotEmpty)
          SizedBox(width: 12.w),
        if (details.openingHours != null && details.openingHours!.isNotEmpty)
          Row(
            children: [
              Icon(Icons.access_time, color: AppColors.grey, size: 14.sp),
              SizedBox(width: 4.w),
              Text(
                details.openingHours!,
                style: TextStyle(fontSize: 11.sp, color: AppColors.lightText),
              ),
            ],
          ),
      ],
    );
  }

  // EXACTLY same as family
  Widget _buildSectionHeader(String title, {VoidCallback? onSeeAll}) {
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
        if (onSeeAll != null)
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
}

class _ActionIcon {
  final String iconPath;
  final String label;
  const _ActionIcon(this.iconPath, this.label);
}
