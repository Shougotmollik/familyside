import 'dart:io';

import 'package:familyside/core/theme/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:familyside/model/edit_item.dart';
import 'package:familyside/model/interest.dart';
import 'package:familyside/provider/service_provider/sp_create_provider.dart';
import 'package:familyside/provider/service_provider/sp_manage_provider.dart';
import 'package:familyside/utils/app_snackbar.dart';
import 'package:familyside/utils/image_picker.dart';
import 'package:familyside/view/service_provider/create_section/widgets/sp_category_dropdown.dart';
import 'package:familyside/view/service_provider/create_section/widgets/sp_form_buttons.dart';
import 'package:familyside/view/service_provider/create_section/widgets/sp_form_label.dart';
import 'package:familyside/view/service_provider/create_section/widgets/sp_location_bar.dart';
import 'package:familyside/view/service_provider/create_section/widgets/sp_photo_upload_box.dart';
import 'package:familyside/view/service_provider/create_section/widgets/sp_tag_selector.dart';
import 'package:familyside/view/widgets/auth_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

final _categoriesProvider = FutureProvider<List<Interest>>((ref) async {
  return ref.read(spCreateProvider.notifier).getCategories();
});

final _subCategoriesProvider = FutureProvider.family<List<Interest>, String>((
  ref,
  categoryId,
) async {
  return ref
      .read(spCreateProvider.notifier)
      .getSubCategories(categoryId: categoryId);
});

class SpEditBottomSheet extends ConsumerStatefulWidget {
  const SpEditBottomSheet({
    super.key,
    required this.id,
    required this.initialName,
    required this.type,
    this.onUpdated,
  });

  final int id;
  final String initialName;
  final String type;
  final VoidCallback? onUpdated;

  @override
  ConsumerState<SpEditBottomSheet> createState() => _SpEditBottomSheetState();
}

class _SpEditBottomSheetState extends ConsumerState<SpEditBottomSheet> {
  final _locationController = TextEditingController();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagSearchController = TextEditingController();

  // Activity specific
  final _websiteController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _emailController = TextEditingController();
  final _instagramController = TextEditingController();

  // Event specific
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

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
  bool _isLoading = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final rawData = await ref
        .read(spManageProviderProvider.notifier)
        .getItemDetails(id: widget.id);
    if (rawData != null && mounted) {
      final item = EditItem.fromJson(rawData);
      setState(() {
        _nameController.text = item.name;
        _locationController.text = item.location;
        _selectedCategoryInterest = Interest(
          id: item.categoryId,
          name: '',
        );
        _selectedTags.addAll(item.tags);
        _descriptionController.text = item.description;
        _priceController.text = item.price.toStringAsFixed(0);
        _websiteController.text = item.website ?? '';
        _whatsappController.text = item.whatsapp ?? '';
        _emailController.text = item.email ?? '';
        _instagramController.text = item.instagram ?? '';
        _dateController.text = item.date ?? '';
        _timeController.text = item.time ?? '';
        if (item.openingDays != null && item.openingDays!.isNotEmpty) {
          _selectedOpeningDays = item.openingDays!.split(',').map((e) => e.trim()).toList();
        }
        if (item.openingHours != null && item.openingHours!.isNotEmpty) {
          _parseOpeningHours(item.openingHours!);
        }
      });
      if (item.imageUrl.isNotEmpty) {
        await _loadExistingImage(item.imageUrl);
      }
      if (mounted) setState(() => _isLoading = false);
    } else if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _tagSearchController.dispose();
    _websiteController.dispose();
    _whatsappController.dispose();
    _emailController.dispose();
    _instagramController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _parseOpeningHours(String hours) {
    final parts = hours.split(' - ');
    if (parts.length == 2) {
      _openingStartTime = _parseTimeOfDay(parts[0].trim());
      _openingEndTime = _parseTimeOfDay(parts[1].trim());
    }
  }

  TimeOfDay? _parseTimeOfDay(String time) {
    try {
      final normalized = time.toUpperCase().replaceAll(' ', '');
      final isPm = normalized.contains('PM');
      final cleaned = normalized.replaceAll(RegExp(r'[AP]M'), '');
      final parts = cleaned.split(':');
      if (parts.length == 2) {
        int hour = int.parse(parts[0]);
        int minute = int.parse(parts[1]);
        if (isPm && hour != 12) hour += 12;
        if (!isPm && hour == 12) hour = 0;
        return TimeOfDay(hour: hour, minute: minute);
      }
    } catch (_) {}
    return null;
  }

  Future<void> _loadExistingImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final dir = await getTemporaryDirectory();
        final file = File(
          '${dir.path}/existing_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
        await file.writeAsBytes(response.bodyBytes);
        if (mounted) {
          setState(() => _selectedPhotos.add(file));
        }
      }
    } catch (e) {
      debugPrint('Failed to load existing image: $e');
    }
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

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
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
            if (widget.type == 'activity') {
              _selectedPhotos.add(file);
            } else {
              _selectedPhotos.clear();
              _selectedPhotos.add(file);
            }
          });
        }
      } else {
        final files = await pickImageFromGallery(context: context);
        if (files != null) {
          setState(() {
            if (widget.type == 'activity') {
              _selectedPhotos.addAll(files);
            } else {
              _selectedPhotos.clear();
              _selectedPhotos.addAll(files);
            }
          });
        }
      }
    });
  }

  Future<void> _submit() async {
    if (_nameController.text.isEmpty) {
      AppSnackbar.show(
        message: 'Please fill the name',
        type: SnackType.warning,
      );
      return;
    }
    if (_selectedCategoryInterest == null) {
      AppSnackbar.show(
        message: 'Please select a category',
        type: SnackType.warning,
      );
      return;
    }
    if (_priceController.text.isEmpty) {
      AppSnackbar.show(
        message: 'Please enter a price',
        type: SnackType.warning,
      );
      return;
    }
    if (widget.type == 'event' && _dateController.text.isEmpty) {
      AppSnackbar.show(
        message: 'Please select a date',
        type: SnackType.warning,
      );
      return;
    }

    setState(() => _isSubmitting = true);

    bool success = false;
    final notifier = ref.read(spManageProviderProvider.notifier);

    if (widget.type == 'activity') {
      success = await notifier.updateActivity(
        id: widget.id,
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
        image: _selectedPhotos.isNotEmpty ? _selectedPhotos.first : null,
      );
    } else if (widget.type == 'event') {
      success = await notifier.updateEvent(
        id: widget.id,
        name: _nameController.text,
        date: _dateController.text,
        location: _locationController.text,
        categoryId: _selectedCategoryInterest!.id,
        price: int.parse(_priceController.text),
        time: _timeController.text,
        image: _selectedPhotos.isNotEmpty ? _selectedPhotos.first : null,
        tags: _selectedTags,
        description: _descriptionController.text,
      );
    } else if (widget.type == 'gift') {
      success = await notifier.updateGift(
        id: widget.id,
        giftName: _nameController.text,
        categoryId: _selectedCategoryInterest!.id,
        tags: _selectedTags,
        price: int.parse(_priceController.text),
        description: _descriptionController.text,
        image: _selectedPhotos.isNotEmpty ? _selectedPhotos.first : null,
      );
    }

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (success) {
      widget.onUpdated?.call();
      if (mounted) Navigator.of(context).pop();
      AppSnackbar.show(
        message: '${widget.type} updated successfully',
        type: SnackType.success,
      );
    } else {
      AppSnackbar.show(
        message: 'Failed to update ${widget.type}',
        type: SnackType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        20.w,
        20.h,
        20.w,
        MediaQuery.of(context).viewInsets.bottom + 20.h,
      ),
      child: _isLoading
          ? SizedBox(
              height: 300.h,
              child: const Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Edit ${widget.type}',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  if (widget.type != 'gift') ...[
                    SpLocationBar(
                      controller: _locationController,
                      onLocationSelected: (loc) => {},
                    ),
                    SizedBox(height: 16.h),
                  ],

                  SpFormLabel(
                    widget.type == 'activity'
                        ? 'Activity Name'
                        : widget.type == 'event'
                            ? 'Event Name'
                            : 'Gift Name',
                  ),
                  AuthTextFormField(
                    hintText: 'Enter ${widget.type} name',
                    controller: _nameController,
                  ),

                  const SpFormLabel('Category'),
                  ref.watch(_categoriesProvider).when(
                    loading: () => const SizedBox(
                      height: 50,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (err, _) => Text('Error: $err'),
                    data: (categories) {
                      final selected = _selectedCategoryInterest != null
                          ? categories.firstWhere(
                              (e) => e.id == _selectedCategoryInterest!.id,
                            )
                          : null;
                      return SpCategoryDropdown(
                        value: selected?.name,
                        items: categories.map((e) => e.name).toList(),
                        onChanged: (v) => setState(() {
                          _selectedCategoryInterest = categories.firstWhere(
                            (e) => e.name == v,
                          );
                          _selectedSubCategories.clear();
                        }),
                      );
                    },
                  ),
                  SizedBox(height: 4.h),

                  if (widget.type == 'activity' &&
                      _selectedCategoryInterest != null) ...[
                    const SpFormLabel('Sub-category'),
                    SizedBox(height: 8.h),
                    ref
                        .watch(
                          _subCategoriesProvider(
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

                  const SpFormLabel('Tag'),
                  SizedBox(height: 8.h),
                  _buildTagSection(),
                  SizedBox(height: 16.h),

                  SpFormLabel(
                    widget.type == 'activity'
                        ? 'Activity Price'
                        : 'Enter amount',
                    isRequired: true,
                  ),
                  AuthTextFormField(
                    hintText: widget.type == 'activity' ? '500' : '\$00',
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                  ),

                  if (widget.type == 'activity') ...[
                    const SpFormLabel('Website'),
                    AuthTextFormField(
                      hintText: 'Enter website link',
                      controller: _websiteController,
                      keyboardType: TextInputType.url,
                    ),
                    const SpFormLabel("What's App Number"),
                    AuthTextFormField(
                      hintText: 'Enter phone number',
                      controller: _whatsappController,
                      keyboardType: TextInputType.phone,
                    ),
                    const SpFormLabel('Email'),
                    AuthTextFormField(
                      hintText: 'Enter your email address',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SpFormLabel('Instagram Link'),
                    AuthTextFormField(
                      hintText: 'Enter instagram link',
                      controller: _instagramController,
                    ),
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
                  ],

                  if (widget.type == 'event') ...[
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
                                    hintText: 'dd/mm/yyyy',
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
                    SizedBox(height: 16.h),
                  ],

                  _buildPhotosSection(),
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
                    onCancel: () => Navigator.of(context).pop(),
                    onSubmit: _submit,
                    isLoading: _isSubmitting,
                    submitLabel: 'Save changes',
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
    );
  }

  Widget _buildTagSection() {
    return Container(
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
              style: TextStyle(fontSize: 14.sp, color: AppColors.text),
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
                        onTap: () => setState(() => _tagSearchController.clear()),
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
                    color: AppColors.lightText.withValues(alpha: 0.3),
                    width: 1.w,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: AppColors.lightText.withValues(alpha: 0.3),
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
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            alignment: Alignment.topCenter,
            child: _tagSearchController.text.trim().isNotEmpty
                ? _buildSearchResults()
                : _buildDefaultTags(),
          ),
        ],
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
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
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

  Widget _buildPhotosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          previewFile:
              _selectedPhotos.isNotEmpty ? _selectedPhotos.first : null,
        ),
      ],
    );
  }
}
