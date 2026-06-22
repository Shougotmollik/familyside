import 'dart:io';

import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/provider/family/gift_provider.dart';
import 'package:familyside/utils/app_snackbar.dart';
import 'package:familyside/utils/image_picker.dart';
import 'package:familyside/view/family/gift/widgets/gift_list_model.dart';
import 'package:familyside/view/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateNewListBottomSheet extends ConsumerStatefulWidget {
  final String title;
  final String submitLabel;
  final String? initialName;
  final String? initialOccasion;
  final String? initialImagePath;

  const CreateNewListBottomSheet({
    super.key,
    this.title = 'Create new list',
    this.submitLabel = 'Submit',
    this.initialName,
    this.initialOccasion,
    this.initialImagePath,
  });

  @override
  ConsumerState<CreateNewListBottomSheet> createState() =>
      _CreateNewListBottomSheetState();
}

class _CreateNewListBottomSheetState
    extends ConsumerState<CreateNewListBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late String _selectedOccasion;
  File? _imageFile;
  bool _isLoading = false;

  static const _occasions = [
    'Birthday',
    'Christmas',
    'Special',
    'General',
    'Anniversary',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _selectedOccasion = widget.initialOccasion ?? 'Birthday';
    if (widget.initialImagePath != null) {
      _imageFile = File(widget.initialImagePath!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    showImagePickerOptions(
      context,
      (source) async {
        final file = await pickSingleImage(
          context: context,
          source: source,
        );
        if (file != null && mounted) {
          setState(() => _imageFile = file);
        }
      },
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final result = await ref
          .read(giftProviderProvider.notifier)
          .createGiftList(
            name: _nameController.text.trim(),
            occasion: _selectedOccasion,
            photoFile: _imageFile,
          );

      if (!mounted) return;

      if (result != null) {
        final folderId = result['id']?.toString() ?? '';
        Navigator.pop(
          context,
          CreateNewListResult(
            id: folderId,
            name: _nameController.text.trim(),
            occasion: _selectedOccasion,
            imagePath: _imageFile?.path,
          ),
        );
      } else {
        setState(() => _isLoading = false);
        AppSnackbar.show(
          message: 'Failed to create list. Please try again.',
          type: SnackType.error,
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      AppSnackbar.show(
        message: 'Error: $e',
        type: SnackType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28.r),
          topRight: Radius.circular(28.r),
        ),
      ),
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 24.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                      size: 24.sp,
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Divider(height: 1.h, color: AppColors.divider),
              SizedBox(height: 20.h),

              // Image upload area
              _buildImageUploader(),
              SizedBox(height: 20.h),

              // Name field
              TextFormField(
                controller: _nameController,
                enabled: !_isLoading,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a list name';
                  }
                  return null;
                },
                style: TextStyle(fontSize: 14.sp, color: AppColors.text),
                decoration: InputDecoration(
                  hintText: 'Name of the list',
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.lightText,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF3F3F3),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide:
                        const BorderSide(color: AppColors.primaryLight),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: const BorderSide(color: AppColors.error),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: const BorderSide(color: AppColors.error),
                  ),
                  errorStyle:
                      TextStyle(fontSize: 11.sp, color: AppColors.error),
                ),
              ),
              SizedBox(height: 24.h),

              // Occasion selector
              Text(
                'For the occassion',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              SizedBox(height: 12.h),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: _occasions.map((occasion) {
                    final isSelected = _selectedOccasion == occasion;
                    return Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: GestureDetector(
                        onTap: _isLoading
                            ? null
                            : () =>
                                setState(() => _selectedOccasion = occasion),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryLight
                                : AppColors.primaryLight
                                    .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            occasion,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.primaryLight,
                              fontSize: 14.sp,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 32.h),
              CustomElevatedButton(
                onPressed: _submit,
                title: _isLoading ? 'Creating...' : widget.submitLabel,
                isLoading: _isLoading,
                color: AppColors.primaryLight,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageUploader() {
    return GestureDetector(
      onTap: _isLoading ? null : _pickImage,
      child: Container(
        width: double.infinity,
        height: 140.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F3),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.lightText.withValues(alpha: 0.3),
            width: 1.5,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _imageFile != null
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(
                        _imageFile!,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.4),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8.h,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                color: Colors.white,
                                size: 16.sp,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                'Tap to change',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 36.sp,
                        color: AppColors.lightText,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Upload list cover image',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.text,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'PNG, JPG',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.lightText,
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
