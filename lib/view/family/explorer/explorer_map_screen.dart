import 'dart:async';

import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/view/family/explorer/models/explorer_data.dart';
import 'package:familyside/view/family/explorer/models/explorer_map_item.dart';
import 'package:familyside/view/family/explorer/models/explorer_map_screen_config.dart';
import 'package:familyside/view/family/explorer/widgets/explorer_category_chips.dart';
import 'package:familyside/view/family/explorer/widgets/explorer_header.dart';
import 'package:familyside/view/family/explorer/widgets/explorer_map_preview_card.dart';
import 'package:familyside/view/widgets/home_filter_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ExplorerMapScreen extends StatefulWidget {
  final ExplorerMapScreenConfig? config;

  const ExplorerMapScreen({super.key, this.config});

  @override
  State<ExplorerMapScreen> createState() => _ExplorerMapScreenState();
}

class _ExplorerMapScreenState extends State<ExplorerMapScreen> {
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  late final PageController _pageController;
  late String _selectedCategory;
  int _selectedIndex = 0;
  FilterResultModel? _currentFilters;

  ExplorerMapScreenConfig get _config =>
      widget.config ?? ExplorerMapScreenConfig.defaults();

  List<ExplorerMapItem> get _allItems => _config.items;

  List<ExplorerMapItem> get _filteredItems =>
      ExplorerData.filterByCategory(_allItems, _selectedCategory);

  @override
  void initState() {
    super.initState();
    _selectedCategory = _config.initialCategory;
    _pageController = PageController(viewportFraction: 0.88);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _openFilterBottomSheet() async {
    final result = await showModalBottomSheet<FilterResultModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          HomeFilterBottomSheet(initialFilters: _currentFilters),
    );

    if (result != null && mounted) {
      setState(() => _currentFilters = result);
    }
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _selectedIndex = 0;
    });
    if (_pageController.hasClients) {
      _pageController.jumpToPage(0);
    }
    _moveCameraToSelected();
  }

  void _onItemSelected(int index) {
    if (index == _selectedIndex || index >= _filteredItems.length) return;
    setState(() => _selectedIndex = index);
    _moveCameraToSelected();
  }

  Future<void> _moveCameraToSelected() async {
    if (_filteredItems.isEmpty || !_mapController.isCompleted) return;
    final controller = await _mapController.future;
    final item = _filteredItems[_selectedIndex];
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: item.position, zoom: 14),
      ),
    );
  }

  Set<Marker> _buildMarkers() {
    return _filteredItems.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final isSelected = index == _selectedIndex;
      return Marker(
        markerId: MarkerId(item.id),
        position: item.position,
        icon: BitmapDescriptor.defaultMarkerWithHue(
          isSelected
              ? BitmapDescriptor.hueRose
              : BitmapDescriptor.hueRed,
        ),
        onTap: () {
          setState(() => _selectedIndex = index);
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredItems;
    final categories = _config.categories;

    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: ExplorerData.mapCenter,
              zoom: 13,
            ),
            markers: _buildMarkers(),
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (controller) {
              if (!_mapController.isCompleted) {
                _mapController.complete(controller);
              }
            },
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
                  child: ExplorerHeader(
                    locationActive: true,
                    onListTap: () => context.pop(),
                    onFilterTap: _openFilterBottomSheet,
                  ),
                ),
                ExplorerCategoryChips(
                  categories: categories,
                  selectedCategory: _selectedCategory,
                  onCategorySelected: _onCategorySelected,
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: SizedBox(
                height: 150.h,
                child: items.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            'No places found in this category',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.grey,
                            ),
                          ),
                        ),
                      )
                    : PageView.builder(
                        controller: _pageController,
                        itemCount: items.length,
                        onPageChanged: _onItemSelected,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                              left: index == 0 ? 16.w : 6.w,
                              right: 6.w,
                              bottom: 12.h,
                            ),
                            child: ExplorerMapPreviewCard(
                              item: items[index],
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
