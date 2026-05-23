import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/view/widgets/custom_app_bar.dart';

class SpPrivacyPolicyScreen extends StatelessWidget {
  const SpPrivacyPolicyScreen({super.key});

  static const List<_PolicySection> _sections = [
    _PolicySection(
      title: '1. Information We Collect',
      body:
          'We collect information you provide directly to us, such as when you create an account, update your profile, or contact us for support. This includes name, email address, phone number, and business details.',
    ),
    _PolicySection(
      title: '2. How We Use Your Information',
      body:
          'We use the information we collect to provide, maintain, and improve our services, process transactions, send you technical notices and support messages, and respond to your comments and questions.',
    ),
    _PolicySection(
      title: '3. Information Sharing',
      body:
          'We do not share your personal information with third parties except as described in this policy. We may share your information with vendors and service providers that perform services on our behalf.',
    ),
    _PolicySection(
      title: '4. Data Security',
      body:
          'We take reasonable measures to help protect information about you from loss, theft, misuse, unauthorized access, disclosure, alteration, and destruction.',
    ),
    _PolicySection(
      title: '5. Your Choices',
      body:
          'You may update or correct information about yourself by logging into your account or contacting us. You may opt out of receiving promotional communications from us by following the instructions in those messages.',
    ),
    _PolicySection(
      title: '6. Contact Us',
      body:
          'If you have any questions about this Privacy Policy, please contact us at support@familyside.com.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.h),
                  const CustomAppBar(title: 'Privacy Policy'),
                  SizedBox(height: 8.h),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Last updated: January 1, 2025',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.lightText,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    ..._sections.map((s) => _SectionWidget(section: s)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionWidget extends StatelessWidget {
  const _SectionWidget({required this.section});
  final _PolicySection section;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            section.body,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.lightText,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _PolicySection {
  final String title;
  final String body;
  const _PolicySection({required this.title, required this.body});
}
