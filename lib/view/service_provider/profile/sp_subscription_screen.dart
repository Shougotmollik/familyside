import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/core/router/router_path.dart';

// ── Data ──────────────────────────────────────────────────────────────────────

class _Plan {
  final String tab;
  final String name;
  final String price;
  final String subtitle;
  final Color cardColor;
  final Color buttonColor;
  final String buttonLabel;
  final List<String> mainFeatures;
  final _CommunitySection? communitySection;
  final _BenefitsSection? benefitsSection;

  const _Plan({
    required this.tab,
    required this.name,
    required this.price,
    required this.subtitle,
    required this.cardColor,
    required this.buttonColor,
    required this.buttonLabel,
    required this.mainFeatures,
    this.communitySection,
    this.benefitsSection,
  });
}

class _CommunitySection {
  final String title;
  final String subtitle;
  final List<String> items;
  const _CommunitySection({
    required this.title,
    required this.subtitle,
    required this.items,
  });
}

class _BenefitsSection {
  final String title;
  final List<String> items;
  const _BenefitsSection({required this.title, required this.items});
}

// ── Screen ────────────────────────────────────────────────────────────────────

class SpSubscriptionScreen extends StatefulWidget {
  const SpSubscriptionScreen({super.key});

  @override
  State<SpSubscriptionScreen> createState() => _SpSubscriptionScreenState();
}

class _SpSubscriptionScreenState extends State<SpSubscriptionScreen> {
  int _selected = 0;

  static final List<_Plan> _plans = [
    _Plan(
      tab: 'Free',
      name: 'Free',
      price: '\$0',
      subtitle: 'Start Simple',
      cardColor: Colors.white,
      buttonColor: AppColors.primaryLight,
      buttonLabel: 'Start For Free',
      mainFeatures: [
        'Create your business profile',
        'Basic info and photos',
        'Basic Visibility',
      ],
    ),
    _Plan(
      tab: 'Smart',
      name: 'Smart',
      price: '\$29',
      subtitle: 'Grow Through Your Community',
      cardColor: const Color(0xFFFFF8EE),
      buttonColor: const Color(0xFFE8A838),
      buttonLabel: 'Go Premium',
      mainFeatures: [
        'All premium features',
        'Maximum visibility',
        'Events & Gifts',
        'Direct contact',
      ],
      communitySection: const _CommunitySection(
        title: 'Join By Contributing To The Community',
        subtitle: 'By Offering Benefits to Top Contributors',
        items: [
          'They discover your business',
          'They recommend it',
          'They bring new customers',
        ],
      ),
      benefitsSection: const _BenefitsSection(
        title: 'Benefits For Them, Growth For You',
        items: [
          'Free Coffee Or Drink',
          'Free Dessert',
          'Free Trial',
          'Special Discount (10% - 20%)',
          'Small Gift for kids',
          'Family Offers',
          'Early Access',
        ],
      ),
    ),
    _Plan(
      tab: 'Premium',
      name: 'Premium',
      price: '\$39',
      subtitle: 'Start Simple',
      cardColor: Colors.white,
      buttonColor: AppColors.primaryLight,
      buttonLabel: 'Go Premium',
      mainFeatures: [
        'All features included',
        'Maximum visibility',
        'Events & Gifts',
        'Direct contact',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final plan = _plans[_selected];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 32.h),
          child: Column(
            children: [
              // Logo + brand
              SvgPicture.asset(
                'assets/logo/app_logo.svg',
                height: 56.h,
                colorFilter: const ColorFilter.mode(
                  AppColors.primaryLight,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Familyside',
                style: TextStyle(
                  fontFamily: 'Quando',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.text,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Grow With Your Local\nFamily Community',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                  height: 1.3,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Be discovered . Be recommended . Grow Faster',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13.sp, color: AppColors.lightText),
              ),
              SizedBox(height: 24.h),

              // Tab pill selector
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Row(
                  children: List.generate(_plans.length, (i) {
                    final isActive = _selected == i;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selected = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.primaryLight
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(26.r),
                          ),
                          child: Center(
                            child: Text(
                              _plans[i].tab,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: isActive
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isActive
                                    ? Colors.white
                                    : AppColors.lightText,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 20.h),

              // Plan card
              _PlanCard(
                plan: plan,
                onSubscribe: () => context.push(
                  RouterPath.spPaymentScreen,
                  extra: {'plan': plan.name, 'price': plan.price},
                ),
              ),
              SizedBox(height: 16.h),

              Text(
                'You can change your plan anytime',
                style: TextStyle(fontSize: 13.sp, color: AppColors.lightText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Plan card ─────────────────────────────────────────────────────────────────

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.plan, required this.onSubscribe});
  final _Plan plan;
  final VoidCallback onSubscribe;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: plan.cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            plan.name,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.lightText,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            plan.price,
            style: TextStyle(
              fontSize: 44.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.text,
            ),
          ),
          Text(
            plan.subtitle,
            style: TextStyle(fontSize: 13.sp, color: AppColors.lightText),
          ),
          SizedBox(height: 16.h),
          Divider(color: AppColors.divider, height: 1),
          SizedBox(height: 16.h),

          // Main features
          ..._featureList(context, plan.mainFeatures),

          // Community section (Smart only)
          if (plan.communitySection != null) ...[
            SizedBox(height: 16.h),
            _SectionBlock(
              title: plan.communitySection!.title,
              subtitle: plan.communitySection!.subtitle,
              items: plan.communitySection!.items,
              bgColor: const Color(0xFFFFF3DC),
            ),
          ],

          // Benefits section (Smart only)
          if (plan.benefitsSection != null) ...[
            SizedBox(height: 12.h),
            _SectionBlock(
              title: plan.benefitsSection!.title,
              items: plan.benefitsSection!.items,
              bgColor: Colors.transparent,
            ),
          ],

          SizedBox(height: 20.h),

          // CTA button
          GestureDetector(
            onTap: onSubscribe,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                color: plan.buttonColor,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Center(
                child: Text(
                  plan.buttonLabel,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _featureList(BuildContext context, List<String> features) {
    return features
        .map(
          (f) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Row(
              children: [
                Container(
                  width: 22.w,
                  height: 22.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check, color: Colors.white, size: 14.sp),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    f,
                    style: TextStyle(fontSize: 14.sp, color: AppColors.text),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }
}

class _SectionBlock extends StatelessWidget {
  const _SectionBlock({
    required this.title,
    this.subtitle,
    required this.items,
    required this.bgColor,
  });

  final String title;
  final String? subtitle;
  final List<String> items;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: bgColor == Colors.transparent
          ? EdgeInsets.zero
          : EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 4.h),
            Text(
              subtitle!,
              style: TextStyle(fontSize: 12.sp, color: AppColors.lightText),
            ),
          ],
          SizedBox(height: 12.h),
          ...items.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                children: [
                  Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4CAF50),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check, color: Colors.white, size: 12.sp),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(fontSize: 13.sp, color: AppColors.text),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
