import 'package:cached_network_image/cached_network_image.dart';
import 'package:familyside/core/localization/app_localizations.dart';
import 'package:familyside/core/router/router_path.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/env.dart';
import 'package:familyside/model/activity_details.dart';
import 'package:familyside/model/gift_api_item.dart';
import 'package:familyside/provider/family/explorer_provider.dart';
import 'package:familyside/provider/family/home_provider.dart';
import 'package:familyside/view/family/home/family_home_screen.dart';
import 'package:familyside/view/family/home/recomandation_screen.dart';
import 'package:familyside/view/widgets/event_card.dart';
import 'package:familyside/view/widgets/google_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ActivityDetailsScreen extends ConsumerStatefulWidget {
  final int itemId;

  const ActivityDetailsScreen({super.key, required this.itemId});

  @override
  ConsumerState<ActivityDetailsScreen> createState() =>
      _ActivityDetailsScreenState();
}

class _ActivityDetailsScreenState
    extends ConsumerState<ActivityDetailsScreen> {
  bool _descExpanded = false;
  bool _isSaved = false;
  bool _saveInProgress = false;

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
    final loc = AppLocalizations.of(context);
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
                child: Text(loc.translate('retry')),
              ),
            ],
          ),
        ),
        data: (details) {
          // Initialize saved state from API response on first load
          if (!_saveInProgress && _isSaved != details.isSaved && mounted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() => _isSaved = details.isSaved);
            });
          }
          return _buildDetailsContent(details, loc);
        },
      ),
    );
  }

  Widget _buildDetailsContent(ActivityDetails details, AppLocalizations loc) {
    final hasLocation = details.lat != 0.0 || details.lng != 0.0;
    final position = LatLng(details.lat, details.lng);

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () => ref
              .read(activityDetailsProviderProvider.notifier)
              .fetchDetails(widget.itemId),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroImage(details),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (details.description.isNotEmpty) ...[
                        Text(loc.translate('description'),
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.text)),
                        SizedBox(height: 8.h),
                        _buildDescription(details.description, loc),
                        SizedBox(height: 20.h),
                      ],
                      _buildActionIcons(details),
                      SizedBox(height: 20.h),
                      if (hasLocation) ...[
                        _buildMiniMap(position),
                        SizedBox(height: 8.h),
                      ],
                      _buildAddressRow(details),
                      SizedBox(height: 24.h),
                      if (details.relatedEvents.isNotEmpty) ...[
                        _buildSectionHeader(loc.translate('events'),
                            onSeeAll: details.relatedEvents.length > 2
                                ? () => context.push(
                                    RouterPath.familyRecommendationScreen,
                                    extra: ListScreenConfig(
                                        title: loc.translate('events'),
                                        items: details.relatedEvents
                                            .map(_apiItemToRecommended)
                                            .toList()))
                                : null,
                            loc: loc),
                        SizedBox(height: 12.h),
                        ...details.relatedEvents.take(2).map((item) => EventCard(
                            imagePath: item.imageUrl ?? '',
                            category: item.categoryName ?? '',
                            date: item.dateLabel ?? '',
                            title: item.name,
                            price: item.price.toStringAsFixed(0),
                            distance: item.distanceKm != null
                                ? '${item.distanceKm!.toStringAsFixed(2)} km'
                                : 'N/A',
                            ageRange: item.ageRange ?? '',
                            tag: item.isRecommended
                                ? 'Recommended'
                                : item.itemType)),
                        SizedBox(height: 8.h),
                      ],
                      if (details.giftIdeas.isNotEmpty) ...[
                        _buildSectionHeader(loc.translate('giftIdeas'),
                            onSeeAll: details.giftIdeas.length > 3
                                ? () => context.push(
                                    RouterPath.familyRecommendationScreen,
                                    extra: ListScreenConfig(
                                        title: loc.translate('giftIdeas'),
                                        items: details.giftIdeas
                                            .map(_apiItemToRecommended)
                                            .toList()))
                                : null,
                            loc: loc),
                        SizedBox(height: 12.h),
                        SizedBox(
                          height: 160.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: details.giftIdeas.length,
                            itemBuilder: (_, i) =>
                                _buildGiftChip(details.giftIdeas[i]),
                          ),
                        ),
                        SizedBox(height: 24.h),
                      ],
                      if (details.reviews.isNotEmpty) ...[
                        Row(children: [
                          Text(loc.translate('reviews'),
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
                        ...details.reviews.map((r) => _buildReviewCard(r)),
                      ],
                      SizedBox(height: 80.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 28.h),
            color: Colors.white,
            child: GestureDetector(
              onTap: () async {
                final reviewed = await context.push<bool>(
                  RouterPath.familyWriteReviewScreen,
                  extra: widget.itemId,
                );
                if (reviewed == true && mounted) {
                  ref
                      .read(activityDetailsProviderProvider.notifier)
                      .fetchDetails(widget.itemId);
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Center(
                  child: Text(loc.translate('leaveReview'),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroImage(ActivityDetails details) {
    final hasImage = details.imageUrl != null && details.imageUrl!.isNotEmpty;
    return Stack(children: [
      SizedBox(
        width: double.infinity,
        height: 260.h,
        child: hasImage
            ? CachedNetworkImage(
                imageUrl: details.imageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                    color: Colors.grey.shade300,
                    child: Icon(Icons.image_outlined,
                        size: 48.sp, color: Colors.grey)),
                errorWidget: (context, url, error) => _imagePlaceholder())
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
      SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _circleBtn(Icons.arrow_back_ios_new_rounded, () => context.pop()),
              Row(children: [
                _circleBtn(Icons.share_outlined, () {}),
                SizedBox(width: 8.w),
                _buildSaveButton(),
              ]),
            ],
          ),
        ),
      ),
      Positioned(
        bottom: 14.h,
        left: 16.w,
        right: 16.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(details.name,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700)),
            SizedBox(height: 4.h),
            Row(children: [
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                    color: AppColors.secondaryLight,
                    borderRadius: BorderRadius.circular(20.r)),
                child: Text(details.categoryName,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500)),
              ),
              const Spacer(),
              if (details.address.isNotEmpty) ...[
                Icon(Icons.location_on_outlined,
                    color: Colors.white, size: 14.sp),
                SizedBox(width: 3.w),
                Flexible(
                  child: Text(details.address,
                      style:
                          TextStyle(color: Colors.white, fontSize: 12.sp),
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ]),
          ],
        ),
      ),
    ]);
  }

  Widget _imagePlaceholder() {
    return Container(
      color: Colors.grey.shade300,
      child: Icon(Icons.image_outlined, size: 48.sp, color: Colors.grey),
    );
  }

  Future<void> _toggleSave() async {
    if (_saveInProgress) return;
    setState(() => _saveInProgress = true);

    final result = await ref
        .read(savedItemsProviderProvider.notifier)
        .toggleSaveItem(itemId: widget.itemId);

    if (!mounted) return;
    setState(() {
      _saveInProgress = false;
      if (result != null) {
        _isSaved = result;
      }
    });
    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result ? 'Saved!' : 'Removed from saved'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

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

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: _saveInProgress ? null : _toggleSave,
      child: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            final spring = CurvedAnimation(
              parent: animation,
              curve: const Cubic(0.175, 0.885, 0.32, 1.275),
            );
            return ScaleTransition(
              scale: spring,
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: Icon(
            _isSaved ? Icons.bookmark : Icons.bookmark_border,
            key: ValueKey(_isSaved),
            size: 18.sp,
            color: _isSaved ? AppColors.primaryLight : AppColors.text,
          ),
        ),
      ),
    );
  }

  Widget _buildDescription(String description, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(description,
            maxLines: _descExpanded ? null : 3,
            overflow: _descExpanded
                ? TextOverflow.visible
                : TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.lightText,
                height: 1.6)),
        if (description.length > 150)
          GestureDetector(
            onTap: () => setState(() => _descExpanded = !_descExpanded),
            child: Text(_descExpanded ? loc.translate('showLess') : loc.translate('readMore'),
                style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.primaryLight,
                    fontWeight: FontWeight.w600)),
          ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Failed to launch URL: $url — $e');
    }
  }

  void _openWebsite(String website) {
    if (!website.startsWith('http://') && !website.startsWith('https://')) {
      _launchUrl('https://$website');
    } else {
      _launchUrl(website);
    }
  }

  void _openInstagram(String instagram) {
    // Strip @ prefix if present
    final username = instagram.replaceFirst('@', '').trim();
    // Try Instagram app first, fallback to web
    _launchUrl('https://instagram.com/$username');
  }

  void _openWhatsApp(String phone) {
    // Remove any non-digit characters
    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
    _launchUrl('https://wa.me/$cleanPhone');
  }

  void _openDirections(double lat, double lng) {
    _launchUrl('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');
  }

  Widget _buildActionIcons(ActivityDetails details) {
    final actions = <_ActionItem>[];
    if (details.website != null && details.website!.isNotEmpty) {
      actions.add(_ActionItem(
        'assets/icon/globe.svg',
        'Website',
        () => _openWebsite(details.website!),
      ));
    }
    if (details.instagram != null && details.instagram!.isNotEmpty) {
      actions.add(_ActionItem(
        'assets/icon/instagram.svg',
        'Instagram',
        () => _openInstagram(details.instagram!),
      ));
    }
    if (details.whatsapp != null && details.whatsapp!.isNotEmpty) {
      actions.add(_ActionItem(
        'assets/icon/whatsapp.svg',
        'WhatsApp',
        () => _openWhatsApp(details.whatsapp!),
      ));
    }
    // actions.add(_ActionItem('assets/icon/call.svg', 'Call'));
    actions.add(_ActionItem(
      'assets/icon/mage_direction.svg',
      'Direction',
      () => _openDirections(details.lat, details.lng),
    ));

    if (actions.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actions.map((a) {
        return GestureDetector(
          onTap: a.onTap,
          child: Container(
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
                    child: SvgPicture.asset(a.iconPath,
                        width: 24.w, height: 24.w)),
                SizedBox(height: 6.h),
                Text(a.label,
                    style: TextStyle(
                        fontSize: 11.sp, color: AppColors.lightText)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMiniMap(LatLng position) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: SizedBox(
        height: 140.h,
        child: GoogleMapScreen(
          apiKey: EnvHandler.googleMapApiKey,
          initialPosition: position,
          withScaffold: false,
          canSelectLocation: false,
        ),
      ),
    );
  }

  Widget _buildAddressRow(ActivityDetails details) {
    return Row(children: [
      if (details.address.isNotEmpty)
        Expanded(
          child: Row(children: [
            Icon(Icons.location_on_outlined,
                color: AppColors.grey, size: 14.sp),
            SizedBox(width: 4.w),
            Expanded(
              child: Text(details.address,
                  style:
                      TextStyle(fontSize: 12.sp, color: AppColors.lightText)),
            ),
          ]),
        ),
      if (details.address.isNotEmpty && details.openingHours.isNotEmpty)
        SizedBox(width: 12.w),
      if (details.openingHours.isNotEmpty)
        Row(children: [
          Icon(Icons.access_time, color: AppColors.grey, size: 14.sp),
          SizedBox(width: 4.w),
          Text(details.openingHours,
              style: TextStyle(fontSize: 11.sp, color: AppColors.lightText)),
        ]),
    ]);
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onSeeAll, AppLocalizations? loc}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.text)),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: Text(loc?.translate('seeAll') ?? 'See All',
                style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.primaryLight,
                    fontWeight: FontWeight.w600)),
          ),
      ],
    );
  }

  Widget _buildGiftChip(GiftApiItem gift) {
    final hasImage = gift.imageUrl != null && gift.imageUrl!.isNotEmpty;
    return GestureDetector(
      onTap: () =>
          context.push(RouterPath.familyGiftDetailsScreen, extra: gift.id),
      child: Container(
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
            Stack(children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(12.r)),
                child: hasImage
                    ? CachedNetworkImage(
                        imageUrl: gift.imageUrl!,
                        width: 140.w,
                        height: 90.h,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Container(
                            width: 140.w,
                            height: 90.h,
                            color: Colors.grey.shade200))
                    : Container(
                        width: 140.w,
                        height: 90.h,
                        color: Colors.grey.shade200,
                        child:
                            Icon(Icons.card_giftcard, color: Colors.grey)),
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
                  child: Icon(Icons.bookmark,
                      color: Colors.white, size: 12.sp),
                ),
              ),
            ]),
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(gift.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text)),
                  SizedBox(height: 2.h),
                  Text('\$${gift.price.toStringAsFixed(0)}',
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryLight)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(ActivityDetailsReview review) {
    final hasImage =
        review.userImage != null && review.userImage!.isNotEmpty;
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
                      errorWidget: (context, url, error) =>
                          _personPlaceholder())
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
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(
                          color: AppColors.secondaryLight
                              .withValues(alpha: 0.2),
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
              Text(review.date,
                  style:
                      TextStyle(fontSize: 11.sp, color: AppColors.grey)),
          ]),
          SizedBox(height: 10.h),
          Text(review.comment,
              style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.lightText,
                  height: 1.5)),
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

  RecommendedItemModel _apiItemToRecommended(GiftApiItem item) {
    final formattedDate = item.dateLabel ?? '';
    return RecommendedItemModel(
      imagePath: item.imageUrl ?? '',
      category: item.categoryName ?? '',
      date: formattedDate.contains(',')
          ? formattedDate.split(',').first.trim()
          : formattedDate,
      title: item.name,
      price: item.price.toStringAsFixed(0),
      distance: item.distanceKm != null
          ? '${item.distanceKm!.toStringAsFixed(2)} km'
          : 'N/A',
      ageRange: item.ageRange ?? '',
      tag: item.isRecommended ? 'Recommended' : item.itemType,
    );
  }
}

class _ActionItem {
  final String iconPath;
  final String label;
  final VoidCallback? onTap;
  const _ActionItem(this.iconPath, this.label, [this.onTap]);
}
