import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/view/widgets/auth_text_form_field.dart';
import 'package:familyside/view/service_provider/create_section/widgets/sp_tag_selector.dart';
import 'package:familyside/view/service_provider/create_section/widgets/sp_photo_upload_box.dart';
import 'package:familyside/view/service_provider/create_section/widgets/sp_category_dropdown.dart';

class SpEditBottomSheet extends StatefulWidget {
  const SpEditBottomSheet({
    super.key,
    required this.initialName,
    required this.type, // 'Activity' | 'Event' | 'Gift'
  });

  final String initialName;
  final String type;

  @override
  State<SpEditBottomSheet> createState() => _SpEditBottomSheetState();
}

class _SpEditBottomSheetState extends State<SpEditBottomSheet> {
  // Shared
  late final TextEditingController _nameController;
  String? _selectedCategory;
  final List<String> _selectedTags = [];
  final List<String> _tags = ['Toddler', 'Indoor', 'Ongoing', 'Free', 'Paid'];

  // Activity-only
  final List<String> _subCategories = [
    'Health',
    'Schools',
    'Events',
    'Outdoor',
    'Sports',
    'Arts',
  ];
  final List<String> _selectedSubCategories = [];
  final _priceController = TextEditingController();
  final _websiteController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _emailController = TextEditingController();
  final _instagramController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<String> _allDays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
  final List<String> _selectedOpeningDays = [];
  TimeOfDay? _openingStartTime;
  TimeOfDay? _openingEndTime;

  // Event-only
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  // Gift-only
  final _giftAmountController = TextEditingController();
  final _giftDescController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _websiteController.dispose();
    _whatsappController.dispose();
    _emailController.dispose();
    _instagramController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _giftAmountController.dispose();
    _giftDescController.dispose();
    super.dispose();
  }

  // ── Pickers ────────────────────────────────────────────────────────────────

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
    if (picked != null && mounted) {
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
    if (picked != null && mounted) {
      setState(() => _timeController.text = picked.format(context));
    }
  }

  Future<void> _pickOpeningDays() async {
    List<String> temp = List.from(_selectedOpeningDays);
    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          title: const Text('Select Opening Days'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _allDays.map((day) {
                return CheckboxListTile(
                  title: Text(day),
                  value: temp.contains(day),
                  onChanged: (v) => setD(() {
                    v == true ? temp.add(day) : temp.remove(day);
                  }),
                  controlAffinity: ListTileControlAffinity.leading,
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedOpeningDays
                    ..clear()
                    ..addAll(temp);
                });
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
    if (start == null || !mounted) return;
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

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 20.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
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
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 20.sp,
              ),
            ),
            SizedBox(height: 20.h),

            // ── Fields per type ──────────────────────────────────────────────
            if (widget.type == 'Activity') ..._buildActivityFields(),
            if (widget.type == 'Event') ..._buildEventFields(),
            if (widget.type == 'Gift') ..._buildGiftFields(),

            SizedBox(height: 24.h),
            _buildButtons(),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  // ── Activity fields ────────────────────────────────────────────────────────

  List<Widget> _buildActivityFields() => [
    _label('Activity Name'),
    AuthTextFormField(
      hintText: widget.initialName,
      controller: _nameController,
    ),

    _labelWithSub('Category', '(multi-select)'),
    SizedBox(height: 8.h),
    SpTagSelector(
      tags: _subCategories,
      selectedTags: _selectedSubCategories,
      onToggle: (t) => setState(() {
        _selectedSubCategories.contains(t)
            ? _selectedSubCategories.remove(t)
            : _selectedSubCategories.add(t);
      }),
    ),
    SizedBox(height: 16.h),

    _label('Tag'),
    SizedBox(height: 8.h),
    SpTagSelector(
      tags: _tags,
      selectedTags: _selectedTags,
      onToggle: (t) => setState(() {
        _selectedTags.contains(t)
            ? _selectedTags.remove(t)
            : _selectedTags.add(t);
      }),
    ),
    SizedBox(height: 16.h),

    _label('Activity Price'),
    AuthTextFormField(
      hintText: '500',
      controller: _priceController,
      keyboardType: TextInputType.number,
    ),

    _label('Website'),
    AuthTextFormField(
      hintText: 'Enter website link',
      controller: _websiteController,
      keyboardType: TextInputType.url,
    ),

    _label("What's App Number"),
    AuthTextFormField(
      hintText: 'Enter phone number',
      controller: _whatsappController,
      keyboardType: TextInputType.phone,
    ),

    _label('Email'),
    AuthTextFormField(
      hintText: 'Enter email address',
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
    ),

    _label('Instagram Link'),
    AuthTextFormField(
      hintText: 'Enter instagram link',
      controller: _instagramController,
    ),

    Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_label('Opening Days'), _buildOpeningDaysField()],
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('Opening Hours'),
              _buildTapField(
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

    _photosLabel(),
    SizedBox(height: 8.h),
    const SpPhotoUploadBox(),
    SizedBox(height: 16.h),

    _label('Description'),
    AuthTextFormField(
      hintText: 'Enter Description...',
      controller: _descriptionController,
      maxLines: 4,
      minLines: 3,
    ),
  ];

  // ── Event fields ───────────────────────────────────────────────────────────

  List<Widget> _buildEventFields() => [
    _label('Event Name'),
    AuthTextFormField(
      hintText: widget.initialName,
      controller: _nameController,
    ),

    _label('Category'),
    SpCategoryDropdown(
      value: _selectedCategory,
      onChanged: (v) => setState(() => _selectedCategory = v),
    ),
    SizedBox(height: 4.h),

    _label('Tag'),
    SizedBox(height: 8.h),
    SpTagSelector(
      tags: _tags,
      selectedTags: _selectedTags,
      onToggle: (t) => setState(() {
        _selectedTags.contains(t)
            ? _selectedTags.remove(t)
            : _selectedTags.add(t);
      }),
    ),
    SizedBox(height: 16.h),

    _label('Enter amount'),
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
              _label('Date'),
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
              _label('Time'),
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

    _photosLabel(),
    SizedBox(height: 8.h),
    const SpPhotoUploadBox(),
    SizedBox(height: 16.h),

    _label('Description'),
    AuthTextFormField(
      hintText: 'Enter Description...',
      controller: _descriptionController,
      maxLines: 4,
      minLines: 3,
    ),
  ];

  // ── Gift fields ────────────────────────────────────────────────────────────

  List<Widget> _buildGiftFields() => [
    _label('Gift Name'),
    AuthTextFormField(
      hintText: widget.initialName,
      controller: _nameController,
    ),

    _label('Category'),
    SpCategoryDropdown(
      value: _selectedCategory,
      onChanged: (v) => setState(() => _selectedCategory = v),
    ),
    SizedBox(height: 4.h),

    _label('Tag'),
    SizedBox(height: 8.h),
    SpTagSelector(
      tags: _tags,
      selectedTags: _selectedTags,
      onToggle: (t) => setState(() {
        _selectedTags.contains(t)
            ? _selectedTags.remove(t)
            : _selectedTags.add(t);
      }),
    ),
    SizedBox(height: 16.h),

    _label('Enter amount'),
    AuthTextFormField(
      hintText: '\$00',
      controller: _giftAmountController,
      keyboardType: TextInputType.number,
    ),

    _label('Description'),
    AuthTextFormField(
      hintText: 'Enter Description...',
      controller: _giftDescController,
      maxLines: 4,
      minLines: 3,
    ),
    SizedBox(height: 16.h),

    _photosLabel(),
    SizedBox(height: 8.h),
    const SpPhotoUploadBox(),
  ];

  // ── Shared helpers ─────────────────────────────────────────────────────────

  Widget _buildButtons() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppColors.primaryLight,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _label(String text) => Padding(
    padding: EdgeInsets.only(bottom: 6.h),
    child: Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: AppColors.text,
        fontWeight: FontWeight.w500,
      ),
    ),
  );

  Widget _labelWithSub(String text, String sub) => Padding(
    padding: EdgeInsets.only(bottom: 6.h),
    child: RichText(
      text: TextSpan(
        text: '$text ',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.text,
          fontWeight: FontWeight.w500,
        ),
        children: [
          TextSpan(
            text: sub,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.lightText),
          ),
        ],
      ),
    ),
  );

  Widget _photosLabel() => RichText(
    text: TextSpan(
      text: 'Add Photos ',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: AppColors.text,
        fontWeight: FontWeight.w400,
      ),
      children: [
        TextSpan(
          text: '(Optional)',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.lightText),
        ),
      ],
    ),
  );

  Widget _buildTapField(String value, VoidCallback onTap) => GestureDetector(
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

  Widget _buildOpeningDaysField() => GestureDetector(
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
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryLight
                        : AppColors.primaryLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    day,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isSelected ? Colors.white : AppColors.primaryLight,
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
