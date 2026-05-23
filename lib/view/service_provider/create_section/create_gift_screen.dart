import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/utils/image_picker.dart';
import 'package:familyside/view/widgets/auth_text_form_field.dart';
import 'package:familyside/view/widgets/custom_app_bar.dart';
import 'package:familyside/view/service_provider/create_section/widgets/sp_form_label.dart';
import 'package:familyside/view/service_provider/create_section/widgets/sp_tag_selector.dart';
import 'package:familyside/view/service_provider/create_section/widgets/sp_photo_upload_box.dart';
import 'package:familyside/view/service_provider/create_section/widgets/sp_category_dropdown.dart';
import 'package:familyside/view/service_provider/create_section/widgets/sp_form_buttons.dart';

class CreateGiftScreen extends StatefulWidget {
  const CreateGiftScreen({super.key});

  @override
  State<CreateGiftScreen> createState() => _CreateGiftScreenState();
}

class _CreateGiftScreenState extends State<CreateGiftScreen> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedCategory;
  List<String> _selectedTags = [];

  final List<String> _tags = ['Toddler', 'Indoor', 'Ongoing', 'Free', 'Paid'];

  final List<File> _selectedPhotos = [];

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
                  CustomAppBar(title: 'Add gift'),
                  SizedBox(height: 20.h),
                  Text(
                    'Add New Gift',
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
                    // Gift Name
                    const SpFormLabel('Gift Name'),
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

                    // Description
                    const SpFormLabel('Description'),
                    AuthTextFormField(
                      hintText: 'Enter Description...',
                      controller: _descriptionController,
                      maxLines: 5,
                      minLines: 4,
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

                    SpFormButtons(
                      onCancel: () => Navigator.of(context).maybePop(),
                      onSubmit: () {},
                      submitLabel: 'Submit gift',
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
