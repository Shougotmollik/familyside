import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/view/widgets/auth_text_form_field.dart';
import 'package:familyside/view/widgets/custom_app_bar.dart';
import 'package:familyside/view/widgets/google_map.dart';
import 'package:familyside/view/service_provider/create_section/widgets/sp_form_label.dart';
import 'package:familyside/view/service_provider/create_section/widgets/sp_tag_selector.dart';
import 'package:familyside/view/service_provider/create_section/widgets/sp_photo_upload_box.dart';
import 'package:familyside/view/service_provider/create_section/widgets/sp_category_dropdown.dart';
import 'package:familyside/view/service_provider/create_section/widgets/sp_form_buttons.dart';
import 'package:familyside/view/service_provider/create_section/widgets/sp_location_bar.dart';

class CreateActivityScreen extends StatefulWidget {
  const CreateActivityScreen({super.key});

  @override
  State<CreateActivityScreen> createState() => _CreateActivityScreenState();
}

class _CreateActivityScreenState extends State<CreateActivityScreen> {
  final _locationController = TextEditingController();
  GoogleMapLocation? _selectedLocation;
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _websiteController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _emailController = TextEditingController();
  final _instagramController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedCategory;
  List<String> _selectedSubCategories = [];
  List<String> _selectedTags = [];

  final List<String> _subCategories = [
    'AI',
    'Health',
    'Schools',
    'Events',
    'Outdoor',
    'Sports',
    'Arts',
  ];
  final List<String> _tags = ['Toddler', 'Indoor', 'Ongoing', 'Free', 'Paid'];

  String _openingDays = '10:00 AM to 09:00 PM';
  String _openingHours = '10:00 AM to 09:00 PM';

  @override
  void dispose() {
    _locationController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _websiteController.dispose();
    _whatsappController.dispose();
    _emailController.dispose();
    _instagramController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.h),
                  CustomAppBar(title: 'Add activity'),
                  SizedBox(height: 20.h),
                  Text(
                    'Add New Activity',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 22.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Fill all the necessary details for adding a new activity',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.lightText),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Location search bar
                    SpLocationBar(
                      controller: _locationController,
                      onLocationSelected: (loc) =>
                          setState(() => _selectedLocation = loc),
                    ),
                    SizedBox(height: 16.h),

                    // Activity Name
                    const SpFormLabel('Activity Name'),
                    AuthTextFormField(
                      hintText: 'Enter your activity name',
                      controller: _nameController,
                    ),

                    // Category
                    const SpFormLabel('Category'),
                    SpCategoryDropdown(
                      value: _selectedCategory,
                      onChanged: (v) => setState(() => _selectedCategory = v),
                    ),
                    SizedBox(height: 4.h),

                    // Sub-category
                    const SpFormLabel('Sub-category'),
                    SizedBox(height: 8.h),
                    SpTagSelector(
                      tags: _subCategories,
                      selectedTags: _selectedSubCategories,
                      onToggle: (tag) => setState(() {
                        _selectedSubCategories.contains(tag)
                            ? _selectedSubCategories.remove(tag)
                            : _selectedSubCategories.add(tag);
                      }),
                    ),
                    SizedBox(height: 16.h),

                    // Tag
                    const SpFormLabel('Tag'),
                    SizedBox(height: 8.h),
                    SpTagSelector(
                      tags: _tags,
                      selectedTags: _selectedTags,
                      onToggle: (tag) => setState(() {
                        _selectedTags.contains(tag)
                            ? _selectedTags.remove(tag)
                            : _selectedTags.add(tag);
                      }),
                    ),
                    SizedBox(height: 16.h),

                    // Activity Price
                    SpFormLabel('Activity Price', isRequired: true),
                    AuthTextFormField(
                      hintText: '500',
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                    ),

                    // Website
                    const SpFormLabel('Website'),
                    AuthTextFormField(
                      hintText: 'Enter website link',
                      controller: _websiteController,
                      keyboardType: TextInputType.url,
                    ),

                    // WhatsApp
                    const SpFormLabel("What's App Number"),
                    AuthTextFormField(
                      hintText: 'Enter phone number',
                      controller: _whatsappController,
                      keyboardType: TextInputType.phone,
                    ),

                    // Email
                    const SpFormLabel('Email'),
                    AuthTextFormField(
                      hintText: 'Enter phone number',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    // Instagram
                    const SpFormLabel('Instagram Link'),
                    AuthTextFormField(
                      hintText: 'Enter phone number',
                      controller: _instagramController,
                    ),

                    // Opening Days & Hours
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SpFormLabel('Opening Days'),
                              _buildTimeField(_openingDays, () {}),
                            ],
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SpFormLabel('Opening Hours'),
                              _buildTimeField(_openingHours, () {}),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // Photos
                    RichText(
                      text: TextSpan(
                        text: 'Add Photos ',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.text,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          TextSpan(
                            text: '(Optional)',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.lightText),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    const SpPhotoUploadBox(),
                    SizedBox(height: 16.h),

                    // Description
                    const SpFormLabel('Description'),
                    AuthTextFormField(
                      hintText: 'Enter Description...',
                      controller: _descriptionController,
                      maxLines: 5,
                      minLines: 4,
                    ),
                    SizedBox(height: 8.h),

                    SpFormButtons(
                      onCancel: () => Navigator.of(context).maybePop(),
                      onSubmit: () {},
                      submitLabel: 'Submit activity',
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeField(String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: AppColors.lightText.withValues(alpha: 0.3),
            width: 1.w,
          ),
        ),
        child: Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.lightText,
            fontSize: 11.sp,
          ),
        ),
      ),
    );
  }
}
