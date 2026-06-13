import 'package:familyside/utils/app_snackbar.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/model/interest.dart';
import 'package:familyside/provider/service_provider/sp_create_provider.dart';
import 'package:familyside/utils/image_picker.dart';
import 'package:familyside/view/widgets/auth_text_form_field.dart';
import 'package:familyside/view/widgets/custom_app_bar.dart';
import 'package:familyside/view/service_provider/create_section/widgets/sp_form_label.dart';
import 'package:familyside/view/service_provider/create_section/widgets/sp_tag_selector.dart';
import 'package:familyside/view/service_provider/create_section/widgets/sp_photo_upload_box.dart';
import 'package:familyside/view/service_provider/create_section/widgets/sp_category_dropdown.dart';
import 'package:familyside/view/service_provider/create_section/widgets/sp_form_buttons.dart';
import 'package:familyside/view/service_provider/create_section/widgets/sp_location_bar.dart';

final categoriesProvider = FutureProvider<List<Interest>>((ref) async {
  return ref.read(spCreateProvider.notifier).getCategories();
});

final subCategoriesProvider = FutureProvider.family<List<Interest>, String>((
  ref,
  categoryId,
) async {
  return ref
      .read(spCreateProvider.notifier)
      .getSubCategories(categoryId: categoryId);
});

class CreateActivityScreen extends ConsumerStatefulWidget {
  const CreateActivityScreen({super.key});

  @override
  ConsumerState<CreateActivityScreen> createState() =>
      _CreateActivityScreenState();
}

class _CreateActivityScreenState extends ConsumerState<CreateActivityScreen> {
  final _locationController = TextEditingController();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _websiteController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _emailController = TextEditingController();
  final _instagramController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagSearchController = TextEditingController();

  Interest? _selectedCategoryInterest;
  final List<String> _selectedSubCategories = [];
  final List<String> _selectedTags = [];

  final List<String> _tags = ['Toddler', 'Indoor', 'Ongoing', 'Free', 'Paid'];

  List<String> get _filteredTags {
    final query = _tagSearchController.text.trim().toLowerCase();
    if (query.isEmpty) return _tags;
    return _tags.where((t) => t.toLowerCase().contains(query)).toList();
  }

  final List<String> _allDays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
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
    _tagSearchController.dispose();
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
                      onLocationSelected: (loc) => {},
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
                    ref
                        .watch(categoriesProvider)
                        .when(
                          loading: () => const SizedBox(
                            height: 50,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          error: (err, _) => Text('Error: $err'),
                          data: (categories) => SpCategoryDropdown(
                            value: _selectedCategoryInterest?.name,
                            items: categories.map((e) => e.name).toList(),
                            onChanged: (v) => setState(() {
                              _selectedCategoryInterest = categories.firstWhere(
                                (e) => e.name == v,
                              );
                              _selectedSubCategories.clear();
                            }),
                          ),
                        ),
                    SizedBox(height: 4.h),

                    // Sub-category
                    if (_selectedCategoryInterest != null) ...[
                      const SpFormLabel('Sub-category'),
                      SizedBox(height: 8.h),
                      ref
                          .watch(
                            subCategoriesProvider(
                              _selectedCategoryInterest!.id.toString(),
                            ),
                          )
                          .when(
                            loading: () => const SizedBox(
                              height: 50,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                            error: (err, _) => Text('Error: $err'),
                            data: (subCategories) => SpTagSelector(
                              tags: subCategories.map((e) => e.name).toList(),
                              selectedTags: _selectedSubCategories,
                              onToggle: (tag) => setState(() {
                                _selectedSubCategories.contains(tag)
                                    ? _selectedSubCategories.remove(tag)
                                    : _selectedSubCategories.add(tag);
                              }),
                            ),
                          ),
                      SizedBox(height: 16.h),
                    ],

                    // Tag
                    const SpFormLabel('Tag'),
                    SizedBox(height: 8.h),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: AppColors.border),
                      ),
                      padding: EdgeInsets.all(12.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Search bar
                          SizedBox(
                            height: 40.h,
                            child: TextField(
                              controller: _tagSearchController,
                              onChanged: (_) => setState(() {}),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.text,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search or add tags...',
                                hintStyle: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.lightText,
                                ),
                                filled: true,
                                fillColor: AppColors.surface,
                                prefixIcon: Icon(
                                  Icons.search,
                                  size: 20.sp,
                                  color: AppColors.lightText,
                                ),
                                suffixIcon: _tagSearchController.text.isNotEmpty
                                    ? GestureDetector(
                                        onTap: () {
                                          setState(
                                            () => _tagSearchController.clear(),
                                          );
                                        },
                                        child: Icon(
                                          Icons.close,
                                          size: 18.sp,
                                          color: AppColors.lightText,
                                        ),
                                      )
                                    : null,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 10.h,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: BorderSide(
                                    color: AppColors.lightText.withValues(
                                      alpha: 0.3,
                                    ),
                                    width: 1.w,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: BorderSide(
                                    color: AppColors.lightText.withValues(
                                      alpha: 0.3,
                                    ),
                                    width: 1.w,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: BorderSide(
                                    color: AppColors.primaryLight,
                                    width: 1.w,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),

                          // Content area
                          AnimatedSize(
                            duration: const Duration(milliseconds: 250),
                            alignment: Alignment.topCenter,
                            child: _tagSearchController.text.trim().isNotEmpty
                                ? _buildSearchResults()
                                : _buildDefaultTags(),
                          ),
                        ],
                      ),
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
                              SizedBox(
                                height: 44.h,
                                child: _buildOpeningDaysField(),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SpFormLabel('Opening Hours'),
                              SizedBox(
                                height: 44.h,
                                child: _buildTimeField(
                                  _openingStartTime == null
                                      ? 'Select hours'
                                      : '${_openingStartTime!.format(context)} - ${_openingEndTime!.format(context)}',
                                  _pickOpeningHours,
                                ),
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
                      previewFile: _selectedPhotos.isNotEmpty
                          ? _selectedPhotos.first
                          : null,
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
                      onSubmit: () async {
                        if (_selectedCategoryInterest == null) {
                          AppSnackbar.show(
                            message: 'Please select a category',
                            type: SnackType.warning,
                          );
                          return;
                        }

                        final success = await ref
                            .read(spCreateProvider.notifier)
                            .createActivity(
                              name: _nameController.text,
                              location: _locationController.text,
                              categoryId: _selectedCategoryInterest!.id,
                              price: _priceController.text,
                              websiteLink: _websiteController.text,
                              whatsappNumber: _whatsappController.text,
                              emailAddress: _emailController.text,
                              instagramLink: _instagramController.text,
                              openingDays: _selectedOpeningDays.join(','),
                              openingHours:
                                  '${_openingStartTime?.format(context) ?? ''} - ${_openingEndTime?.format(context) ?? ''}',
                              description: _descriptionController.text,
                              subCategories: _selectedSubCategories,
                              tags: _selectedTags,
                              image: _selectedPhotos.isNotEmpty
                                  ? _selectedPhotos.first
                                  : null,
                            );

                        if (success && mounted) {
                          AppSnackbar.show(
                            message: 'Activity created successfully',
                            type: SnackType.success,
                          );
                          Navigator.of(context).pop();
                        } else if (mounted) {
                          AppSnackbar.show(
                            message: 'Failed to create activity',
                            type: SnackType.error,
                          );
                        }
                      },
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

  Widget _buildDefaultTags() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Popular predefined tags
        Text(
          'Popular tags',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.lightText,
          ),
        ),
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
        // Selected tags section
        if (_selectedTags.isNotEmpty) ...[
          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(
                Icons.check_circle,
                size: 14.sp,
                color: AppColors.primaryLight,
              ),
              SizedBox(width: 4.w),
              Text(
                '${_selectedTags.length} selected',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryLight,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildSearchResults() {
    final query = _tagSearchController.text.trim();
    if (_filteredTags.isEmpty) {
      return GestureDetector(
        onTap: () {
          if (query.isNotEmpty && !_tags.contains(query)) {
            setState(() {
              _tags.add(query);
              _selectedTags.add(query);
              _tagSearchController.clear();
            });
          }
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColors.primaryLight.withValues(alpha: 0.2),
              width: 1.w,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Icon(Icons.add, size: 14.sp, color: Colors.white),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 13.sp, color: AppColors.text),
                    children: [
                      TextSpan(
                        text: 'Create "',
                        style: TextStyle(color: AppColors.lightText),
                      ),
                      TextSpan(
                        text: query,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryLight,
                        ),
                      ),
                      TextSpan(
                        text: '"',
                        style: TextStyle(color: AppColors.lightText),
                      ),
                    ],
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 14.sp,
                color: AppColors.lightText,
              ),
            ],
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Suggestions',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.lightText,
          ),
        ),
        SizedBox(height: 8.h),
        SpTagSelector(
          tags: _filteredTags,
          selectedTags: _selectedTags,
          onToggle: (tag) => setState(() {
            _selectedTags.contains(tag)
                ? _selectedTags.remove(tag)
                : _selectedTags.add(tag);
          }),
        ),
      ],
    );
  }

  Widget _buildOpeningDaysField() {
    return GestureDetector(
      onTap: _pickOpeningDays,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: AppColors.lightText.withValues(alpha: 0.3),
            width: 1.w,
          ),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: _selectedOpeningDays.isEmpty
              ? Text(
                  'Select days',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.lightText,
                    fontSize: 11.sp,
                  ),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
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
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.primaryLight,
                                fontWeight: FontWeight.w500,
                                fontSize: 11.sp,
                              ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildTimeField(String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: AppColors.lightText.withValues(alpha: 0.3),
            width: 1.w,
          ),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.lightText,
              fontSize: 11.sp,
            ),
          ),
        ),
      ),
    );
  }
}
