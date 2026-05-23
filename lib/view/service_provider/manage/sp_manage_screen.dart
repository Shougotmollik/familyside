import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/view/family/explorer/widgets/explorer_tab_bar.dart';
import 'package:familyside/view/service_provider/manage/widgets/sp_manage_card.dart';
import 'package:familyside/view/service_provider/manage/widgets/sp_edit_bottom_sheet.dart';
import 'package:familyside/view/service_provider/manage/widgets/sp_delete_confirm_sheet.dart';

class _ActivityItem {
  final String imagePath;
  final String category;
  final String title;
  final String price;
  final String distance;
  final String ageRange;

  const _ActivityItem({
    required this.imagePath,
    required this.category,
    required this.title,
    required this.price,
    required this.distance,
    required this.ageRange,
  });
}

class _GiftItem {
  final String imagePath;
  final String title;
  final String price;
  final String description;
  final String location;

  const _GiftItem({
    required this.imagePath,
    required this.title,
    required this.price,
    required this.description,
    required this.location,
  });
}

class SpManageScreen extends StatefulWidget {
  const SpManageScreen({super.key});

  @override
  State<SpManageScreen> createState() => _SpManageScreenState();
}

class _SpManageScreenState extends State<SpManageScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<_ActivityItem> _activities = [
    const _ActivityItem(
      imagePath: 'assets/image/doctor.jpg',
      category: 'Health',
      title: 'Little Stars Pediatric Clinic',
      price: '20',
      distance: '0.05 km',
      ageRange: 'Age: 0-20 years',
    ),
    const _ActivityItem(
      imagePath: 'assets/image/doctor.jpg',
      category: 'Health',
      title: 'Little Stars Pediatric Clinic',
      price: '20',
      distance: '0.05 km',
      ageRange: 'Age: 0-20 years',
    ),
    const _ActivityItem(
      imagePath: 'assets/image/doctor.jpg',
      category: 'Health',
      title: 'Little Stars Pediatric Clinic',
      price: '20',
      distance: '0.05 km',
      ageRange: 'Age: 0-20 years',
    ),
    const _ActivityItem(
      imagePath: 'assets/image/doctor.jpg',
      category: 'Health',
      title: 'Little Stars Pediatric Clinic',
      price: '20',
      distance: '0.05 km',
      ageRange: 'Age: 0-20 years',
    ),
  ];

  final List<_ActivityItem> _events = [
    const _ActivityItem(
      imagePath: 'assets/image/doctor.jpg',
      category: 'Health',
      title: 'Little Stars Pediatric Clinic',
      price: '20',
      distance: '0.05 km',
      ageRange: 'Age: 0-20 years',
    ),
    const _ActivityItem(
      imagePath: 'assets/image/doctor.jpg',
      category: 'Health',
      title: 'Little Stars Pediatric Clinic',
      price: '20',
      distance: '0.05 km',
      ageRange: 'Age: 0-20 years',
    ),
    const _ActivityItem(
      imagePath: 'assets/image/doctor.jpg',
      category: 'Health',
      title: 'Little Stars Pediatric Clinic',
      price: '20',
      distance: '0.05 km',
      ageRange: 'Age: 0-20 years',
    ),
    const _ActivityItem(
      imagePath: 'assets/image/doctor.jpg',
      category: 'Health',
      title: 'Little Stars Pediatric Clinic',
      price: '20',
      distance: '0.05 km',
      ageRange: 'Age: 0-20 years',
    ),
  ];

  final List<_GiftItem> _gifts = [
    const _GiftItem(
      imagePath: 'assets/image/doctor.jpg',
      title: '1 Month Activity Pass',
      price: '45',
      description: 'Gift a month of fun activities at Green Meadows...',
      location: 'Green meadows ark',
    ),
    const _GiftItem(
      imagePath: 'assets/image/doctor.jpg',
      title: '1 Month Activity Pass',
      price: '45',
      description: 'Gift a month of fun activities at Green Meadows...',
      location: 'Green meadows ark',
    ),
    const _GiftItem(
      imagePath: 'assets/image/doctor.jpg',
      title: '1 Month Activity Pass',
      price: '45',
      description: 'Gift a month of fun activities at Green Meadows...',
      location: 'Green meadows ark',
    ),
    const _GiftItem(
      imagePath: 'assets/image/doctor.jpg',
      title: '1 Month Activity Pass',
      price: '45',
      description: 'Gift a month of fun activities at Green Meadows...',
      location: 'Green meadows ark',
    ),
  ];

  static const List<String> _tabLabels = ['Activity', 'Events', 'Gifts'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String get _currentTitle => _tabLabels[_tabController.index];

  int get _currentCount {
    switch (_tabController.index) {
      case 0:
        return _activities.length;
      case 1:
        return _events.length;
      default:
        return _gifts.length;
    }
  }

  void _openEdit(String name, String type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SpEditBottomSheet(initialName: name, type: type),
    );
  }

  void _openDelete(VoidCallback onConfirm) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => SpDeleteConfirmSheet(onDelete: onConfirm),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _currentTitle,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      '$_currentCount $_currentTitle',
                      style: TextStyle(
                        color: AppColors.primaryLight,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),

            // Tab bar
            ExplorerTabBar(controller: _tabController),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildActivityList(),
                  _buildEventList(),
                  _buildGiftList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityList() {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      itemCount: _activities.length,
      itemBuilder: (_, i) {
        final item = _activities[i];
        return SpManageCard(
          imagePath: item.imagePath,
          category: item.category,
          title: item.title,
          price: item.price,
          distance: item.distance,
          ageRange: item.ageRange,
          onEdit: () => _openEdit(item.title, 'Activity'),
          onDelete: () => _openDelete(() {
            setState(() => _activities.removeAt(i));
          }),
        );
      },
    );
  }

  Widget _buildEventList() {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      itemCount: _events.length,
      itemBuilder: (_, i) {
        final item = _events[i];
        return SpManageCard(
          imagePath: item.imagePath,
          category: item.category,
          title: item.title,
          price: item.price,
          distance: item.distance,
          ageRange: item.ageRange,
          onEdit: () => _openEdit(item.title, 'Event'),
          onDelete: () => _openDelete(() {
            setState(() => _events.removeAt(i));
          }),
        );
      },
    );
  }

  Widget _buildGiftList() {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      itemCount: _gifts.length,
      itemBuilder: (_, i) {
        final item = _gifts[i];
        return SpManageCard(
          imagePath: item.imagePath,
          category: 'Gift',
          title: item.title,
          price: item.price,
          distance: '',
          ageRange: '',
          description: item.description,
          location: item.location,
          isGift: true,
          onEdit: () => _openEdit(item.title, 'Gift'),
          onDelete: () => _openDelete(() {
            setState(() => _gifts.removeAt(i));
          }),
        );
      },
    );
  }
}
