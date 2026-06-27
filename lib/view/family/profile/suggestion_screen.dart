import 'package:familyside/core/localization/app_localizations.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/model/suggestion_item.dart';
import 'package:familyside/provider/family/family_profile_provider.dart';
import 'package:familyside/view/family/profile/widgets/suggestion_card.dart';
import 'package:familyside/view/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SuggestionScreen extends ConsumerStatefulWidget {
  const SuggestionScreen({super.key});

  @override
  ConsumerState<SuggestionScreen> createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends ConsumerState<SuggestionScreen> {
  List<SuggestionItem> _suggestions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchSuggestions());
  }

  Future<void> _fetchSuggestions() async {
    final items = await ref.read(familyProfileProvider.notifier).getSuggestions();
    if (!mounted) return;
    setState(() {
      _suggestions = items;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.border,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
              child: CustomAppBar(title: loc.translate('suggested')),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _suggestions.isEmpty
                      ? _buildEmptyState()
                      : ListView.separated(
                          padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 24.h),
                          itemCount: _suggestions.length,
                          separatorBuilder: (_, _) => SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                            final item = _suggestions[index];
                            return SuggestionCard(
                              imagePath: 'assets/image/doctor.jpg',
                              category: item.category,
                              title: item.name,
                              description: item.description,
                              location: item.location,
                              status: item.suggestionStatus,
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final loc = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lightbulb_outline,
            size: 48.sp,
            color: AppColors.lightText,
          ),
          SizedBox(height: 16.h),
          Text(
            loc.translate('noSuggestionsYet'),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.text,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            loc.translate('suggestionsAppearHere'),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.lightText,
            ),
          ),
        ],
      ),
    );
  }
}
