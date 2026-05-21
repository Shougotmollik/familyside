import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/view/family/profile/widgets/suggestion_card.dart';
import 'package:familyside/view/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SuggestionScreen extends StatelessWidget {
  const SuggestionScreen({super.key});

  static const String _demoImage = 'assets/image/doctor.jpg';

  static const List<_SuggestionItem> _suggestions = [
    _SuggestionItem(
      category: 'Health',
      title: 'Little Stars Pediatric Clinic',
      description:
          "Amazing place! My kids absolutely loved it. The staff is friendly and attentive. We'll definitely come back.",
      location: 'Dhaka, Bangladesh',
      status: SuggestionStatus.approved,
    ),
    _SuggestionItem(
      category: 'Health',
      title: 'Little Stars Pediatric Clinic',
      description:
          "Amazing place! My kids absolutely loved it. The staff is friendly and attentive. We'll definitely come back.",
      location: 'Dhaka, Bangladesh',
      status: SuggestionStatus.pending,
    ),
    _SuggestionItem(
      category: 'Health',
      title: 'Little Stars Pediatric Clinic',
      description:
          "Amazing place! My kids absolutely loved it. The staff is friendly and attentive. We'll definitely come back.",
      location: 'Dhaka, Bangladesh',
      status: SuggestionStatus.approved,
    ),
    _SuggestionItem(
      category: 'Health',
      title: 'Little Stars Pediatric Clinic',
      description:
          "Amazing place! My kids absolutely loved it. The staff is friendly and attentive. We'll definitely come back.",
      location: 'Dhaka, Bangladesh',
      status: SuggestionStatus.pending,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.border,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
              child: const CustomAppBar(title: 'Suggested'),
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 24.h),
                itemCount: _suggestions.length,
                separatorBuilder: (_, _) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final item = _suggestions[index];
                  return SuggestionCard(
                    imagePath: _demoImage,
                    category: item.category,
                    title: item.title,
                    description: item.description,
                    location: item.location,
                    status: item.status,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuggestionItem {
  final String category;
  final String title;
  final String description;
  final String location;
  final SuggestionStatus status;

  const _SuggestionItem({
    required this.category,
    required this.title,
    required this.description,
    required this.location,
    required this.status,
  });
}
