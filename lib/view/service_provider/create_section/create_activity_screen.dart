import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/utils/image_picker.dart';
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

  final List<String> _allDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  List<String> _selectedOpeningDays = [];
  TimeOfDay? _openingStartTime;
  TimeOfDay? _openingEndTime;
  final List<File> _selectedPhotos = [];

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

  Future<void> _pickOpeningDays() async {
    List<String> tempSelected = List.from(_selectedOpeningDays);
    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Select Opening Days'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _allDays.map((day) {
                return CheckboxListTile(
                  title: Text(day),
                  value: tempSelected.contains(day),
                  onChanged: (checked) {
                    setDialogState(() {
                      checked == true
                          ? tempSelected.add(day)
                          : tempSelected.remove(day);
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (!mounted) return;
                setState(() => _selectedOpeningDays = List.from(tempSelected));
                Navigator.of(ctx).pop();
              },
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickOpeningHours() async {
    final start = await showTimePicker(
      context: context,
      initialTime: _openingStartTime ?? const TimeOfDay(hour: 9, minute: 0),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primaryLight,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (start == null) return;
    if (!mounted) return;
    final end = await showTimePicker(
      context: context,
      initialTime: _openingEndTime ?? const TimeOfDay(hour: 17, minute: 0),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primaryLight,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (end == null) return;
    setState(() {
      _openingStartTime = start;
      _openingEndTime = end;
    });
  }

  void _pickPhotos() {
    showImagePickerOptions(context, (source) async {
      if (source == ImageSource.camera) {
        final file = await pickSingleImage(
          context: context,
          source: ImageSource.camera,
        );
        if (file != null) {
          setState(() => _selectedPhotos.add(file));
        }
      } else {
        final files = await pickImageFromGallery(context: context);
        if (files != null) {
          setState(() => _selectedPhotos.addAll(files));
        }
      }
    });
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
                      hintText: 'Enter your email address',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    // Instagram
                    const SpFormLabel('Instagram Link'),
                    AuthTextFormField(
                      hintText: 'Enter instagram link',
                      controller: _instagramController,
                    ),

                    // Opening Days & Hours
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SpFormLabel('Opening Days'),
                              _buildOpeningDaysField(),
                            ],
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SpFormLabel('Opening Hours'),
                              _buildTimeField(
                                _openingStartTime == null
                                    ? 'Select hours'
                                    : '${_openingStartTime!.format(context)} - ${_openingEndTime!.format(context)}',
                                _pickOpeningHours,
                              ),
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
                    SpPhotoUploadBox(
                      onTap: _pickPhotos,
                      previewFile:
                          _selectedPhotos.isNotEmpty ? _selectedPhotos.first : null,
                    ),
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

  Widget _buildOpeningDaysField() {
    return GestureDetector(
      onTap: _pickOpeningDays,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: AppColors.lightText.withValues(alpha: 0.3),
            width: 1.w,
          ),
        ),
        child: _selectedOpeningDays.isEmpty
            ? Text(
                'Select days',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.lightText,
                  fontSize: 11.sp,
                ),
              )
            : Wrap(
                spacing: 4.w,
                runSpacing: 4.h,
                children: _allDays.map((day) {
                  final isSelected = _selectedOpeningDays.contains(day);
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryLight
                          : AppColors.primaryLight.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      day,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color:
                            isSelected ? Colors.white : AppColors.primaryLight,
                        fontWeight: FontWeight.w500,
                        fontSize: 11.sp,
                      ),
                    ),
                  );
                }).toList(),
              ),
      ),
    );
  }
}
