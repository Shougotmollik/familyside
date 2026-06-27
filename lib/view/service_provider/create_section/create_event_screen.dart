import 'dart:io';

import 'package:familyside/core/localization/app_localizations.dart';
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

  bool _isFlyerLoading = false;

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

  Future<void> _autoFillFromFlyer() async {
    final loc = AppLocalizations.of(context);
    showImagePickerOptions(context, (source) async {
      File? file;
      if (source == ImageSource.camera) {
        file = await pickSingleImage(
          context: context,
          source: ImageSource.camera,
        );
      } else {
        final files = await pickImageFromGallery(context: context, limit: 1);
        if (files != null && files.isNotEmpty) {
          file = files.first;
        }
      }

      if (file == null) return;

      setState(() => _isFlyerLoading = true);

      final result = await ref
          .read(spCreateProvider.notifier)
          .parseFlyer(image: file);

      if (!mounted) return;
      setState(() => _isFlyerLoading = false);

      if (result == null) {
        AppSnackbar.show(
          message: loc.translate('flyerParseFailed'),
          type: SnackType.error,
        );
        return;
      }

      _applyFlyerData(result, file);
    });
  }

  void _applyFlyerData(Map<String, dynamic> data, File flyerImage) {
    final loc = AppLocalizations.of(context);
    if (data['name'] != null) {
      _nameController.text = data['name'].toString();
    }
    if (data['description'] != null) {
      _descriptionController.text = data['description'].toString();
    }
    if (data['location'] != null) {
      _locationController.text = data['location'].toString();
    }
    if (data['price'] != null) {
      _amountController.text = data['price'].toString();
    }
    if (data['date'] != null) {
      _dateController.text = data['date'].toString();
    }
    if (data['start_time'] != null) {
      _timeController.text = data['start_time'].toString();
    }

    final suggestedTags = data['suggested_tags'];
    if (suggestedTags is List) {
      for (final tag in suggestedTags) {
        final tagName = tag.toString();
        if (!_tags.contains(tagName)) {
          _tags.add(tagName);
        }
        if (!_selectedTags.contains(tagName)) {
          _selectedTags.add(tagName);
        }
      }
    }

    setState(() {
      _selectedPhotos.clear();
      _selectedPhotos.add(flyerImage);
    });

    AppSnackbar.show(
      message: loc.translate('flyerParsedSuccess'),
      type: SnackType.success,
    );
  }

  Future<void> _submit() async {
    final loc = AppLocalizations.of(context);
    if (_nameController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _amountController.text.isEmpty ||
        _selectedPhotos.isEmpty ||
        _selectedCategoryInterest == null) {
      AppSnackbar.show(
        message: loc.translate('pleaseFillAllRequired'),
        type: SnackType.warning,
      );
      return;
    }

    final success = await ref
        .read(spCreateProvider.notifier)
        .createEvent(
          name: _nameController.text,
          date: _dateController.text,
          location: _locationController.text,
          categoryId: _selectedCategoryInterest!.id,
          price: double.tryParse(_amountController.text)?.toInt() ?? 0,
          time: _timeController.text,
          image: _selectedPhotos.first,
          tags: _selectedTags,
          description: _descriptionController.text,
        );

    if (success && mounted) {
      Navigator.of(context).pop();
      AppSnackbar.show(
        message: loc.translate('eventCreatedSuccess'),
        type: SnackType.success,
      );
    } else if (mounted) {
      AppSnackbar.show(
        message: loc.translate('failedToCreateEvent'),
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
    final loc = AppLocalizations.of(context);
    final state = ref.watch(spCreateProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.h),
                      CustomAppBar(
                        title: loc.translate('addEvent'),
                        trailing: GestureDetector(
                          onTap: _isFlyerLoading ? null : _autoFillFromFlyer,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '\u2728',
                                  style: TextStyle(fontSize: 12.sp),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  loc.translate('autoFillFromFlyer'),
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: AppColors.onPrimaryLight,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10.sp,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        loc.translate('addNewEvent'),
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 22.sp,
                            ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        loc.translate('addEventSubtitle'),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.lightText,
                        ),
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

                        SpFormLabel(loc.translate('eventName')),
                        AuthTextFormField(
                          hintText: loc.translate('enterYourEventName'),
                          controller: _nameController,
                        ),

                        const SpFormLabel('Category'),
                        ref
                            .watch(categoriesProvider)
                            .when(
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
                                  _selectedCategoryInterest = categories
                                      .firstWhere((e) => e.name == v);
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
                                    hintText: loc.translate('searchOrAddTags'),
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
                                    suffixIcon:
                                        _tagSearchController.text.isNotEmpty
                                        ? GestureDetector(
                                            onTap: () {
                                              setState(
                                                () => _tagSearchController
                                                    .clear(),
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
                                child:
                                    _tagSearchController.text.trim().isNotEmpty
                                    ? _buildSearchResults()
                                    : _buildDefaultTags(),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),

                        SpFormLabel(loc.translate('enterAmount'), isRequired: true),
                        AuthTextFormField(
                          hintText: loc.translate('enterAmountHint'),
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SpFormLabel(loc.translate('date')),
                                  GestureDetector(
                                    onTap: _pickDate,
                                    child: AbsorbPointer(
                                      child: AuthTextFormField(
                                        hintText: loc.translate('enterDateHint'),
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
                                  SpFormLabel(loc.translate('time')),
                                  GestureDetector(
                                    onTap: _pickTime,
                                    child: AbsorbPointer(
                                      child: AuthTextFormField(
                                        hintText: loc.translate('enterTimeHint'),
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
                            text: loc.translate('addPhotos'),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: AppColors.text,
                                  fontWeight: FontWeight.w400,
                                ),
                            children: [
                              TextSpan(
                                text: loc.translate('optional'),
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

                        SpFormLabel(loc.translate('description')),
                        AuthTextFormField(
                          hintText: loc.translate('enterDescription'),
                          controller: _descriptionController,
                          maxLines: 5,
                          minLines: 4,
                        ),
                        SizedBox(height: 8.h),

                        SpFormButtons(
                          onCancel: () => Navigator.of(context).maybePop(),
                          onSubmit: _submit,
                          isLoading: state.isLoading,
                          submitLabel: loc.translate('submitEvent'),
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isFlyerLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.4),
              child: Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 40.w),
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 24.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 40.h,
                        width: 40.h,
                        child: const CircularProgressIndicator(
                          color: AppColors.primaryLight,
                          strokeWidth: 3,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        loc.translate('aiReadingFlyer'),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        loc.translate('aiMayTakeSeconds'),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.lightText,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDefaultTags() {
    final loc = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.translate('popularTags'),
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
    final loc = AppLocalizations.of(context);
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
          loc.translate('suggestions'),
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
