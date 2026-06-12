import 'package:familyside/model/interest.dart';
import 'package:familyside/provider/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/view/widgets/custom_app_bar.dart';
import 'package:familyside/view/widgets/custom_elevated_button.dart';
import 'package:familyside/view/family/auth/signup/widgets/interest_chip.dart';
import 'package:familyside/view/widgets/search_bar_widget.dart';

class InterestScreen extends ConsumerStatefulWidget {
  const InterestScreen({super.key});

  @override
  ConsumerState<InterestScreen> createState() => _InterestScreenState();
}

class _InterestScreenState extends ConsumerState<InterestScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<Interest> _allInterests = [];
  final Set<int> _selectedInterestIds = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInterests();
  }

  Future<void> _loadInterests() async {
    final interests = await ref.read(onboardingProvider.notifier).getInterests();
    if (mounted) {
      setState(() {
        _allInterests = interests;
        _isLoading = false;
      });
    }
  }

  List<Interest> get _filteredInterests {
    if (_searchQuery.isEmpty) {
      return _allInterests;
    }
    return _allInterests
        .where((interest) =>
            interest.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  void _onSearchClear() {
    setState(() {
      _searchQuery = '';
    });
  }

  void _toggleInterest(int id) {
    setState(() {
      if (_selectedInterestIds.contains(id)) {
        _selectedInterestIds.remove(id);
      } else {
        _selectedInterestIds.add(id);
      }
    });
  }

  Future<void> _onContinue() async {
    await ref.read(onboardingProvider.notifier).postInterests(
      interests: _selectedInterestIds.toList(),
    );
    if (mounted) {
      context.push('/familyLocationInfoScreen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight, 
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              const CustomAppBar(title: 'Interests'),
              SizedBox(height: 30.h),
              Text(
                'What activities does your\nchild enjoy?',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                  height: 1.3,
                  fontSize: 22.sp,
                ),
              ),
              SizedBox(height: 24.h),
              SearchBarWidget(
                controller: _searchController,
                hintText: 'Enter your interest',
                onChanged: _onSearchChanged,
                onClear: _onSearchClear,
              ),
              SizedBox(height: 24.h),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredInterests.isEmpty
                        ? Center(
                            child: Text(
                              _searchQuery.isEmpty ? 'No interests available' : 'No results found',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.lightText,
                              ),
                            ),
                          )
                        : SingleChildScrollView(
                            child: Wrap(
                              spacing: 12.w,
                              runSpacing: 12.h,
                              children: _filteredInterests.map((interest) {
                                return InterestChip(
                                  label: interest.name,
                                  isSelected: _selectedInterestIds.contains(interest.id),
                                  onTap: () => _toggleInterest(interest.id),
                                );
                              }).toList(),
                            ),
                          ),
              ),
              CustomElevatedButton(
                onPressed: _onContinue,
                title: 'Continue',
                color: AppColors.primaryLight,
                textColor: Colors.white,
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
