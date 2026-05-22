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

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _locationController = TextEditingController();
  GoogleMapLocation? _selectedLocation;
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedCategory;
  List<String> _selectedTags = [];

  final List<String> _tags = ['Toddler', 'Indoor', 'Ongoing', 'Free', 'Paid'];

  @override
  void dispose() {
    _locationController.dispose();
    _nameController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
                    // Location
                    SpLocationBar(
                      controller: _locationController,
                      onLocationSelected: (loc) =>
                          setState(() => _selectedLocation = loc),
                    ),
                    SizedBox(height: 16.h),

                    // Event Name
                    const SpFormLabel('Event Name'),
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

                    // Amount
                    SpFormLabel('Enter amount', isRequired: true),
                    AuthTextFormField(
                      hintText: '\$00',
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                    ),

                    // Date & Time
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
}
