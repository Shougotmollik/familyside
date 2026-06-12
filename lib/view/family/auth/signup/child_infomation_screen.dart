import 'package:familyside/model/child_info.dart' as model;
import 'package:familyside/provider/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:familyside/core/router/router_path.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/view/widgets/custom_app_bar.dart';
import 'package:familyside/view/widgets/auth_text_form_field.dart';
import 'package:familyside/view/widgets/custom_elevated_button.dart';
import 'package:familyside/view/family/auth/signup/widgets/custom_dropdown.dart';
import 'package:familyside/view/family/auth/signup/widgets/type_toggle_widget.dart';
import 'package:familyside/provider/child_info_provider.dart';
import 'package:go_router/go_router.dart';

class ChildInfomationScreen extends ConsumerStatefulWidget {
  const ChildInfomationScreen({super.key});

  @override
  ConsumerState<ChildInfomationScreen> createState() =>
      _ChildInfomationScreenState();
}

class _ChildInfomationScreenState extends ConsumerState<ChildInfomationScreen> {
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _childNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String? _selectedGender;
  DateTime? _pickedDOB;

  @override
  void dispose() {
    _dueDateController.dispose();
    _childNameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _childNameController.clear();
    _dobController.clear();
    _selectedGender = null;
    _pickedDOB = null;
  }

  void _loadKidData(int index) {
    final state = ref.read(childInfoProvider);
    if (index >= 0 && index < state.kids.length) {
      final kid = state.kids[index];
      _childNameController.text = kid.name;
      _selectedGender = kid.gender;
      if (kid.dob != null) {
        _pickedDOB = kid.dob;
        _dobController.text = _formatDate(kid.dob!);
      } else {
        _pickedDOB = null;
        _dobController.clear();
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(childInfoProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              CustomAppBar(title: 'Tell us about your Child'),
              SizedBox(height: 20.h),
              TypeToggleWidget(
                isExpecting: state.isExpecting,
                onChanged: (value) {
                  ref.read(childInfoProvider.notifier).setIsExpecting(value);
                  _clearForm();
                },
              ),
              SizedBox(height: 24.h),
              Expanded(
                child: SingleChildScrollView(
                  child: state.isExpecting
                      ? _buildExpectingForm()
                      : _buildKidsForm(state),
                ),
              ),
              if (!state.isExpecting) ...[
                _buildBottomButtons(state),
                SizedBox(height: 16.h),
              ],
              CustomElevatedButton(
                onPressed: () => _handleContinue(state),
                title: 'Continue',
                color: AppColors.primaryLight,
                textColor: Colors.white,
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpectingForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Expected Due Date',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: _selectDueDate,
          child: AbsorbPointer(
            child: AuthTextFormField(
              hintText: 'dd/mm/yyyy',
              controller: _dueDateController,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKidsForm(ChildInfoState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.kids.isNotEmpty) ...[
          _buildKidsList(state),
          SizedBox(height: 16.h),
        ],
        if (state.showForm) _buildKidForm(state),
        if (state.kids.isEmpty && !state.showForm) _buildEmptyState(),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.lightText.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.child_care_outlined,
              size: 32.sp,
              color: AppColors.primaryLight,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'No kids added yet',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.text,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Add your children to continue',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.lightText),
          ),
          SizedBox(height: 20.h),
          GestureDetector(
            onTap: () {
              _clearForm();
              ref.read(childInfoProvider.notifier).openAddForm();
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: AppColors.primaryLight, size: 18.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Add Child',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primaryLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKidsList(ChildInfoState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Added Kids (${state.kids.length})',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        ...List.generate(
          state.kids.length,
          (index) => _buildKidCard(index, state.kids[index]),
        ),
      ],
    );
  }

  Widget _buildKidCard(int index, ChildModel kid) {
    final state = ref.read(childInfoProvider);
    final isEditing = state.editingKidIndex == index;

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isEditing
            ? AppColors.primaryLight.withOpacity(0.1)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isEditing
              ? AppColors.primaryLight
              : AppColors.lightText.withOpacity(0.3),
          width: isEditing ? 1.5.w : 1.w,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                kid.name.isNotEmpty ? kid.name[0].toUpperCase() : '?',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.primaryLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kid.name.isNotEmpty ? kid.name : 'Child ${index + 1}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.text,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  kid.dob != null
                      ? 'DOB: ${_formatDate(kid.dob!)}'
                      : 'No DOB set',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.lightText),
                ),
                if (kid.gender != null)
                  Text(
                    'Gender: ${kid.gender}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.lightText),
                  ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              if (state.showForm) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please save or cancel first')),
                );
                return;
              }
              _loadKidData(index);
              ref.read(childInfoProvider.notifier).openEditForm(index);
            },
            child: Text(
              'Edit',
              style: TextStyle(color: AppColors.primaryLight, fontSize: 12.sp),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: AppColors.error, size: 20.sp),
            onPressed: () => _showDeleteDialog(index),
          ),
        ],
      ),
    );
  }

  Widget _buildKidForm(ChildInfoState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Child\'s Name',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 8.h),
        AuthTextFormField(
          hintText: 'Enter child\'s name',
          controller: _childNameController,
        ),
        SizedBox(height: 8.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date Of Birth',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.text,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  GestureDetector(
                    onTap: _selectKidDOB,
                    child: AbsorbPointer(
                      child: AuthTextFormField(
                        hintText: 'dd/mm/yyyy',
                        controller: _dobController,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gender',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.text,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  CustomDropdown(
                    hintText: 'boy',
                    value: _selectedGender,
                    items: const ['boy', 'girl'],
                    onChanged: (value) {
                      setState(() => _selectedGender = value);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomButtons(ChildInfoState state) {
    if (!state.showForm) {
      return Row(
        children: [
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                _clearForm();
                ref.read(childInfoProvider.notifier).openAddForm();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: AppColors.primaryLight, size: 20.sp),
                    SizedBox(width: 8.w),
                    Text(
                      'Add more kids',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.primaryLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () => context.push(RouterPath.familyInterestScreen),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.lightText.withOpacity(0.3),
                    width: 1.w,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Skip',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.text,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: _saveKid,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Text(
                  'Save',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              _clearForm();
              ref.read(childInfoProvider.notifier).closeForm();
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.lightText.withOpacity(0.3),
                  width: 1.w,
                ),
              ),
              child: Center(
                child: Text(
                  'Cancel',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.text,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDueDate() async {
    final state = ref.read(childInfoProvider);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          state.selectedDueDate ??
          DateTime.now().add(const Duration(days: 180)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
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
      ref.read(childInfoProvider.notifier).setDueDate(picked);
      _dueDateController.text = _formatDate(picked);
    }
  }

  Future<void> _selectKidDOB() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _pickedDOB ?? DateTime.now().subtract(const Duration(days: 365)),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
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
        _pickedDOB = picked;
        _dobController.text = _formatDate(picked);
      });
    }
  }

  void _saveKid() {
    DateTime? dob = _pickedDOB;

    ref
        .read(childInfoProvider.notifier)
        .saveKid(
          name: _childNameController.text,
          dob: dob,
          gender: _selectedGender,
        );

    _clearForm();
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Child'),
        content: const Text('Are you sure you want to remove this child?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(childInfoProvider.notifier).removeKid(index);
              if (index == ref.read(childInfoProvider).editingKidIndex) {
                _clearForm();
              }
            },
            child: Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  Future<void> _handleContinue(ChildInfoState state) async {
    if (state.isExpecting) {
      if (state.selectedDueDate != null) {
        await ref.read(onboardingProvider.notifier).childInfo(
          model.ChildInfo(
            isExpecting: true,
            children: [],
            expectedDueDate: state.selectedDueDate!.toIso8601String(),
          ),
        );
        if (mounted) context.push(RouterPath.familyInterestScreen);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please select due date')));
      }
    } else {
      if (state.showForm) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please save or cancel the current form'),
          ),
        );
      } else {
        final children = state.kids
            .map((k) => model.Child(
                  name: k.name,
                  dob: k.dob?.toIso8601String() ?? '',
                  gender: k.gender ?? '',
                ))
            .toList();
        await ref.read(onboardingProvider.notifier).childInfo(
          model.ChildInfo(
            isExpecting: false,
            children: children,
          ),
        );
        if (mounted) context.push(RouterPath.familyInterestScreen);
      }
    }
  }
}
