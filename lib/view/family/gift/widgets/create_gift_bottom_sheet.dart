import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/model/gift_item_model.dart';
import 'package:familyside/view/family/gift/widgets/create_gift_card_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateGiftCardData {
  final String senderName;
  final String? personalMessage;
  final GiftItemModel giftItem;

  const CreateGiftCardData({
    required this.senderName,
    this.personalMessage,
    required this.giftItem,
  });
}

class CreateGiftBottomSheet extends StatefulWidget {
  final GiftItemModel giftItem;
  final String? initialSenderName;
  final String? initialMessage;
  final void Function(GiftItemModel item)? onSharePressed;

  const CreateGiftBottomSheet({
    super.key,
    required this.giftItem,
    this.initialSenderName,
    this.initialMessage,
    this.onSharePressed,
  });

  @override
  State<CreateGiftBottomSheet> createState() => _CreateGiftBottomSheetState();
}

class _CreateGiftBottomSheetState extends State<CreateGiftBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialSenderName);
    _messageController = TextEditingController(text: widget.initialMessage);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  CreateGiftCardData _buildResult() {
    return CreateGiftCardData(
      senderName: _nameController.text.trim(),
      personalMessage: _messageController.text.trim().isEmpty
          ? null
          : _messageController.text.trim(),
      giftItem: widget.giftItem,
    );
  }

  void _onDownload() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(context, _buildResult());
  }

  void _onShare() {
    if (!_formKey.currentState!.validate()) return;
    final data = _buildResult();
    final shareCallback = widget.onSharePressed;
    Navigator.pop(context, data);
    if (shareCallback != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        shareCallback(widget.giftItem);
      });
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('🎁', style: TextStyle(fontSize: 20.sp)),
                      SizedBox(width: 8.w),
                      Text(
                        'Create Gift Card',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                    ],
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
              _LabeledTextField(
                label: 'Your name',
                hintText: 'Enter Your name',
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              _LabeledTextField(
                label: 'Personal message (optional)',
                hintText: 'write message here....',
                controller: _messageController,
                maxLines: 4,
                minLines: 3,
              ),
              SizedBox(height: 20.h),
              CreateGiftCardPreview(
                imagePath: widget.giftItem.imagePath,
                title: widget.giftItem.title,
                price: widget.giftItem.price,
                description: widget.giftItem.description,
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      label: 'Download',
                      backgroundColor: AppColors.primaryLight,
                      textColor: Colors.white,
                      onTap: _onDownload,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _ActionButton(
                      label: 'Share',
                      backgroundColor:
                          AppColors.primaryLight.withValues(alpha: 0.1),
                      textColor: AppColors.primaryLight,
                      onTap: _onShare,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LabeledTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final int maxLines;
  final int? minLines;

  const _LabeledTextField({
    required this.label,
    required this.hintText,
    required this.controller,
    this.validator,
    this.maxLines = 1,
    this.minLines,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          minLines: minLines,
          style: TextStyle(fontSize: 14.sp, color: AppColors.text),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 14.sp,
              color: AppColors.lightText,
            ),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 14.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: AppColors.lightText.withValues(alpha: 0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: AppColors.lightText.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: AppColors.primaryLight),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            errorStyle: TextStyle(fontSize: 11.sp, color: AppColors.error),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
