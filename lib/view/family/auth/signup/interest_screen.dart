import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/view/widgets/custom_app_bar.dart';
import 'package:familyside/view/widgets/custom_elevated_button.dart';
import 'package:familyside/view/family/auth/signup/widgets/interest_chip.dart';
import 'package:familyside/view/widgets/search_bar_widget.dart';

class InterestScreen extends StatefulWidget {
  const InterestScreen({super.key});

  @override
  State<InterestScreen> createState() => _InterestScreenState();
}

class _InterestScreenState extends State<InterestScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> _allInterests = [
    'Education',
    'Music',
    'Sports',
    'Dance',
    'Outdoor Play',
    'Coding',
    'Others'
  ];

  final Set<String> _selectedInterests = {'Education'};

  List<String> get _filteredInterests {
    if (_searchQuery.isEmpty) {
      return _allInterests;
    }
    return _allInterests
        .where((interest) =>
            interest.toLowerCase().contains(_searchQuery.toLowerCase()))
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

  void _toggleInterest(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        _selectedInterests.add(interest);
      }
    });
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
                child: _filteredInterests.isEmpty
                    ? Center(
                        child: Text(
                          'No results found',
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
                              label: interest,
                              isSelected: _selectedInterests.contains(interest),
                              onTap: () => _toggleInterest(interest),
                            );
                          }).toList(),
                        ),
                      ),
              ),
              CustomElevatedButton(
                onPressed: () {
                  context.push('/familyLocationInfoScreen');  
                },
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
