import 'dart:io';

import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/model/interest.dart';
import 'package:familyside/provider/service_provider/sp_create_provider.dart';
import 'package:familyside/utils/app_snackbar.dart';
import 'package:familyside/utils/image_picker.dart';
import 'package:familyside/view/service_provider/create_section/widgets/sp_category_dropdown.dart';
import 'package:familyside/view/service_provider/create_section/widgets/sp_form_buttons.dart';
import 'package:familyside/view/service_provider/create_section/widgets/sp_form_label.dart';
import 'package:familyside/view/service_provider/create_section/widgets/sp_location_bar.dart';
import 'package:familyside/view/service_provider/create_section/widgets/sp_photo_upload_box.dart';
import 'package:familyside/view/service_provider/create_section/widgets/sp_tag_selector.dart';
import 'package:familyside/view/widgets/auth_text_form_field.dart';
import 'package:familyside/view/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

final categoriesProvider = FutureProvider<List<Interest>>((ref) async {
  return ref.read(spCreateProvider.notifier).getCategories();
});

class CreateEventScreen extends ConsumerStatefulWidget {
  const CreateEventScreen({super.key});

  @override
  ConsumerState<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends ConsumerState<CreateEventScreen> {
  final _locationController = TextEditingController();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagSearchController = TextEditingController();

  Interest? _selectedCategoryInterest;
  final List<String> _selectedTags = [];

  final List<String> _tags = ['Toddler', 'Indoor', 'Ongoing', 'Free', 'Paid'];

  List<String> get _filteredTags {
    final query = _tagSearchController.text.trim().toLowerCase();
    if (query.isEmpty) return _tags;
    return _tags.where((t) => t.toLowerCase().contains(query)).toList();
  }

  final List<File> _selectedPhotos = [];

  @override
  void dispose() {
    _locationController.dispose();
    _nameController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _descriptionController.dispose();
    _tagSearchController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_nameController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _amountController.text.isEmpty ||
        _selectedPhotos.isEmpty ||
        _selectedCategoryInterest == null) {
      AppSnackbar.show(
        message: 'Please fill all required fields',
        type: SnackType.warning,
      );
      return;
    }

    final success = await ref.read(spCreateProvider.notifier).createEvent(
          name: _nameController.text,
          date: _dateController.text,
          location: _locationController.text,
          categoryId: _selectedCategoryInterest!.id,
          price: int.parse(_amountController.text),
          time: _timeController.text,
          image: _selectedPhotos.first,
          tags: _selectedTags,
          description: _descriptionController.text,
        );

    if (success && mounted) {
      Navigator.of(context).pop();
      AppSnackbar.show(
        message: 'Event created successfully',
        type: SnackType.success,
      );
    } else if (mounted) {
      AppSnackbar.show(
        message: 'Failed to create event',
        type: SnackType.error,
      );
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primaryLight,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: AppColors.text,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _dateController.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
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
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  void _pickPhotos() {
    showImagePickerOptions(context, (source) async {
      if (source == ImageSource.camera) {
        final file = await pickSingleImage(
          context: context,
          source: ImageSource.camera,
        );
        if (file != null) {
          setState(() {
            _selectedPhotos.clear();
            _selectedPhotos.add(file);
          });
        }
      } else {
        final files = await pickImageFromGallery(context: context);
        if (files != null) {
          setState(() {
            _selectedPhotos.clear();
            _selectedPhotos.addAll(files);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(spCreateProvider);

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
                  CustomAppBar(title: 'Add event'),
                  SizedBox(height: 20.h),
                  Text(
                    'Add New Event',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 22.sp,
                        ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Fill all the necessary details for adding a new event',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.lightText),
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
                    SpLocationBar(
                      controller: _locationController,
                      onLocationSelected: (loc) => {},
                    ),
                    SizedBox(height: 16.h),

                    const SpFormLabel('Event Name'),
                    AuthTextFormField(
                      hintText: 'Enter your event name',
                      controller: _nameController,
                    ),

                    const SpFormLabel('Category'),
                    ref.watch(categoriesProvider).when(
                          loading: () => const SizedBox(
                            height: 50,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          error: (err, _) => Text('Error: $err'),
                          data: (categories) => SpCategoryDropdown(
                            value: _selectedCategoryInterest?.name,
                            items: categories.map((e) => e.name).toList(),
                            onChanged: (v) => setState(() {
                              _selectedCategoryInterest =
                                  categories.firstWhere(
                                (e) => e.name == v,
                              );
                            }),
                          ),
                        ),
                    SizedBox(height: 16.h),

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
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),
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

                    SpFormLabel('Enter amount', isRequired: true),
                    AuthTextFormField(
                      hintText: '\$00',
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SpFormLabel('Date'),
                              GestureDetector(
                                onTap: _pickDate,
                                child: AbsorbPointer(
                                  child: AuthTextFormField(
                                    hintText: 'yyyy-mm-dd',
                                    controller: _dateController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SpFormLabel('Time'),
                              GestureDetector(
                                onTap: _pickTime,
                                child: AbsorbPointer(
                                  child: AuthTextFormField(
                                    hintText: 'hh:mm',
                                    controller: _timeController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

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
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
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
                      onSubmit: _submit,
                      isLoading: state.isLoading,
                      submitLabel: 'Submit event',
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
}
