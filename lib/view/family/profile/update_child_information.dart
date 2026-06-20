import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/provider/child_info_provider.dart';
import 'package:familyside/provider/family/family_profile_provider.dart';
import 'package:familyside/utils/app_snackbar.dart';
import 'package:familyside/view/family/auth/signup/widgets/custom_dropdown.dart';
import 'package:familyside/view/family/auth/signup/widgets/type_toggle_widget.dart';
import 'package:familyside/view/widgets/auth_text_form_field.dart';
import 'package:familyside/view/widgets/custom_app_bar.dart';
import 'package:familyside/view/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class UpdateChildInformationScreen extends ConsumerStatefulWidget {
  const UpdateChildInformationScreen({super.key});

  @override
  ConsumerState<UpdateChildInformationScreen> createState() =>
      _UpdateChildInformationScreenState();
}

class _UpdateChildInformationScreenState
    extends ConsumerState<UpdateChildInformationScreen> {
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _childNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String? _selectedGender;
  DateTime? _pickedDOB;
  bool _dueDateSynced = false;
  bool _isLoading = false;
  bool _isFetchingData = true;
  String _locationName = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchChildInfo());
  }

  Future<void> _fetchChildInfo() async {
    final data = await ref.read(familyProfileProvider.notifier).getChildInfo();
    if (!mounted) return;

    final notifier = ref.read(childInfoProvider.notifier);

    // Reset local state before populating from API (prevents duplicates on re-entry)
    notifier.reset();
    _clearForm();

    if (data != null) {
      // Store location name to send back on save
      _locationName = data.locationName;

      // Set expecting status
      notifier.setIsExpecting(data.isExpecting);

      // Set due date if expecting
      if (data.expectedDueDate != null && data.expectedDueDate!.isNotEmpty) {
        final date = DateTime.tryParse(data.expectedDueDate!);
        if (date != null) {
          notifier.setDueDate(date);
          _dueDateController.text = _formatDate(date);
          _dueDateSynced = true;
        }
      }

      // Add kids from API
      for (final kid in data.kids) {
        DateTime? dob;
        if (kid.dob != null && kid.dob!.isNotEmpty) {
          dob = _parseApiDate(kid.dob!);
        }
        notifier.saveKid(name: kid.name, dob: dob, gender: kid.gender);
      }
    }

    setState(() => _isFetchingData = false);
  }

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

  /// Parses a date string in dd/MM/yyyy format from the API
  DateTime? _parseApiDate(String dateStr) {
    final parts = dateStr.split('/');
    if (parts.length == 3) {
      final day = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);
      if (day != null && month != null && year != null) {
        return DateTime(year, month, day);
      }
    }
    // Fallback to ISO 8601 parse
    return DateTime.tryParse(dateStr);
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(childInfoProvider);

    if (!_dueDateSynced && state.selectedDueDate != null) {
      _dueDateController.text = _formatDate(state.selectedDueDate!);
      _dueDateSynced = true;
    }

    if (_isFetchingData) {
      return Scaffold(
        body: SafeArea(child: const Center(child: CircularProgressIndicator())),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const CustomAppBar(title: 'Child Information'),
                    SizedBox(height: 20.h),
                    TypeToggleWidget(
                      isExpecting: state.isExpecting,
                      onChanged: (value) {
                        ref
                            .read(childInfoProvider.notifier)
                            .setIsExpecting(value);
                        _clearForm();
                      },
                    ),
                    SizedBox(height: 24.h),
                    state.isExpecting
                        ? _buildExpectingForm()
                        : _buildKidsForm(state),
                  ],
                ),
              ),
            ),
            if (!state.isExpecting) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: _buildBottomButtons(state),
              ),
              SizedBox(height: 16.h),
            ],
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
              child: CustomElevatedButton(
                onPressed: _isLoading ? () {} : () => _handleSave(state),
                title: 'Save',
                color: AppColors.primaryLight,
                textColor: AppColors.onPrimaryLight,
                isLoading: _isLoading,
              ),
            ),
          ],
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
            'Add your children to update your profile',
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
                    items: const ['boy', 'girl', 'other'],
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
      return GestureDetector(
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
                  'Save child',
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
    ref
        .read(childInfoProvider.notifier)
        .saveKid(
          name: _childNameController.text,
          dob: _pickedDOB,
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

  Future<void> _handleSave(ChildInfoState childState) async {
    if (childState.isExpecting) {
      if (childState.selectedDueDate == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please select due date')));
        return;
      }
    }

    if (childState.showForm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please save or cancel the current form')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final childrenJson = childState.kids.map((k) => k.toJson()).toList();

    // Format due date as yyyy-MM-dd to match the API's expected format
    final dueDateStr = childState.selectedDueDate != null
        ? '${childState.selectedDueDate!.year.toString().padLeft(4, '0')}-${childState.selectedDueDate!.month.toString().padLeft(2, '0')}-${childState.selectedDueDate!.day.toString().padLeft(2, '0')}'
        : null;

    final success = await ref
        .read(familyProfileProvider.notifier)
        .updateChildInfo(
          locationName: _locationName,
          isExpecting: childState.isExpecting,
          expectedDueDate: dueDateStr,
          children: childrenJson,
        );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      AppSnackbar.show(
        message: 'Child information updated successfully',
        type: SnackType.success,
      );
      if (context.mounted) context.pop();
    } else {
      AppSnackbar.show(
        message: 'Failed to update child information',
        type: SnackType.error,
      );
    }
  }
}
