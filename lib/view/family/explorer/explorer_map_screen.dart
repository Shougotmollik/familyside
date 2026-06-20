import 'dart:async';
import 'dart:math';

import 'package:familyside/core/router/router_path.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/provider/family/explorer_provider.dart';
import 'package:familyside/view/family/explorer/activity_details_screen.dart';
import 'package:familyside/view/family/explorer/models/explorer_data.dart';
import 'package:familyside/view/family/explorer/models/explorer_map_item.dart';
import 'package:familyside/view/family/explorer/widgets/explorer_category_chips.dart';
import 'package:familyside/view/family/explorer/widgets/explorer_header.dart';
import 'package:familyside/view/family/explorer/widgets/explorer_map_preview_card.dart';
import 'package:familyside/model/filter_result_model.dart';
import 'package:familyside/view/widgets/home_filter_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ExplorerMapScreen extends ConsumerStatefulWidget {
  const ExplorerMapScreen({super.key});

  @override
  ConsumerState<ExplorerMapScreen> createState() => _ExplorerMapScreenState();
}

class _ExplorerMapScreenState extends ConsumerState<ExplorerMapScreen> {
  final Completer<GoogleMapController> _mapControllerCompleter =
      Completer<GoogleMapController>();
  GoogleMapController? _mapController;
  late final PageController _pageController;
  String _selectedCategory = 'All';
  int _selectedIndex = 0;
  FilterResultModel? _currentFilters;
  bool _initialCameraSet = false;

  List<ExplorerMapItem> get _allItems {
    final state = ref.watch(explorerMapProviderProvider);
    return state.whenOrNull(
          data: (response) =>
              response.items.map(ExplorerMapItem.fromGiftApiItem).toList(),
        ) ??
        [];
  }

  List<ExplorerMapItem> get _filteredItems =>
      ExplorerData.filterByCategory(_allItems, _selectedCategory);

  /// Items that have valid geographical coordinates for markers
  List<ExplorerMapItem> get _itemsWithPosition => _filteredItems
      .where((item) =>
          item.position.latitude != 0.0 || item.position.longitude != 0.0)
      .toList();

  List<String> get _categories {
    final state = ref.watch(explorerMapProviderProvider);
    final categoryNames = state.whenOrNull(
          data: (response) =>
              response.categories.map((c) => c.name).toList(),
        ) ??
        [];
    return ['All', ...categoryNames];
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.88);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(explorerMapProviderProvider.notifier).fetchMapData();
    });
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
      setState(() {
        _currentFilters = result;
        _initialCameraSet = false;
      });
      ref.read(explorerMapProviderProvider.notifier).fetchMapData(
        filters: result,
      );
    }
  }

  bool get _hasAnyFilter {
    if (_currentFilters == null) return false;
    return _currentFilters!.location.isNotEmpty ||
        _currentFilters!.categories.isNotEmpty ||
        _currentFilters!.ages.isNotEmpty ||
        _currentFilters!.price != 'All';
  }

  int get _filterCount {
    if (_currentFilters == null) return 0;
    int count = 0;
    if (_currentFilters!.location.isNotEmpty) count++;
    if (_currentFilters!.categories.isNotEmpty) {
      count += _currentFilters!.categories.length;
    }
    if (_currentFilters!.ages.isNotEmpty) {
      count += _currentFilters!.ages.length;
    }
    if (_currentFilters!.price != 'All') count++;
    return count;
  }

  void _clearFilters() {
    setState(() {
      _currentFilters = null;
      _initialCameraSet = false;
    });
    ref.read(explorerMapProviderProvider.notifier).fetchMapData();
  }

  void _removeFilter(String filterKey, String filterValue) {
    if (_currentFilters == null) return;

    final updated = FilterResultModel(
      location:
          filterKey == 'location' ? '' : _currentFilters!.location,
      categories: filterKey == 'categories'
          ? _currentFilters!.categories
              .where((c) => c != filterValue)
              .toList()
          : _currentFilters!.categories,
      ages: filterKey == 'ages'
          ? _currentFilters!.ages
              .where((a) => a != filterValue)
              .toList()
          : _currentFilters!.ages,
      price: filterKey == 'price' ? 'All' : _currentFilters!.price,
    );

    final hasAnyFilter = updated.location.isNotEmpty ||
        updated.categories.isNotEmpty ||
        updated.ages.isNotEmpty ||
        updated.price != 'All';

    setState(() {
      _currentFilters = hasAnyFilter ? updated : null;
      _initialCameraSet = false;
    });
    ref.read(explorerMapProviderProvider.notifier).fetchMapData(
      filters: hasAnyFilter ? updated : null,
    );
  }

  Widget _buildActiveFilterChips() {
    final chips = <Widget>[];

    if (_currentFilters!.location.isNotEmpty) {
      chips.add(_filterChip(
        label: _currentFilters!.location,
        filterKey: 'location',
        filterValue: _currentFilters!.location,
      ));
    }
    for (final cat in _currentFilters!.categories) {
      chips.add(_filterChip(
        label: cat,
        filterKey: 'categories',
        filterValue: cat,
      ));
    }
    for (final age in _currentFilters!.ages) {
      chips.add(_filterChip(
        label: age,
        filterKey: 'ages',
        filterValue: age,
      ));
    }
    if (_currentFilters!.price != 'All') {
      chips.add(_filterChip(
        label: _currentFilters!.price,
        filterKey: 'price',
        filterValue: _currentFilters!.price,
      ));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...chips,
          GestureDetector(
            onTap: _clearFilters,
            child: Container(
              margin: EdgeInsets.only(right: 8.w),
              padding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: AppColors.lightText),
              ),
              child: Text(
                'Clear all',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.lightText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip({
    required String label,
    required String filterKey,
    required String filterValue,
  }) {
    return Container(
      margin: EdgeInsets.only(right: 8.w, bottom: 8.h),
      padding:
          EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.primaryLight.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryLight,
            ),
          ),
          SizedBox(width: 4.w),
          GestureDetector(
            onTap: () => _removeFilter(filterKey, filterValue),
            child: Icon(
              Icons.close,
              size: 14.sp,
              color: AppColors.primaryLight,
            ),
          ),
        ],
      ),
    );
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _selectedIndex = 0;
    });
    if (_pageController.hasClients) {
      _pageController.jumpToPage(0);
    }
    _fitCameraToAllMarkers();
  }

  void _onItemSelected(int index) {
    if (index == _selectedIndex || index >= _filteredItems.length) return;
    setState(() => _selectedIndex = index);
    _moveCameraToSelected();
  }

  /// Fit camera to show all markers with valid coordinates
  Future<void> _fitCameraToAllMarkers() async {
    if (!mounted) return;
    final controller = _mapController;
    if (controller == null) return;

    final items = _itemsWithPosition;
    if (items.isEmpty) return;

    setState(() => _initialCameraSet = true);

    if (!mounted) return;
    if (items.length == 1) {
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: items.first.position, zoom: 15),
        ),
      );
      return;
    }

    final bounds = _buildLatLngBounds(items);
    if (!mounted) return;
    await controller.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 60.w),
    );
  }

  /// Retry fitting all markers on next frame if map controller not ready yet
  void _fitWhenMapReady() {
    if (!mounted) return;
    if (_mapController != null) {
      _fitCameraToAllMarkers();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => _fitWhenMapReady());
    }
  }

  LatLngBounds _buildLatLngBounds(List<ExplorerMapItem> items) {
    double minLat = double.infinity;
    double maxLat = double.negativeInfinity;
    double minLng = double.infinity;
    double maxLng = double.negativeInfinity;

    for (final item in items) {
      minLat = min(minLat, item.position.latitude);
      maxLat = max(maxLat, item.position.latitude);
      minLng = min(minLng, item.position.longitude);
      maxLng = max(maxLng, item.position.longitude);
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  Future<void> _moveCameraToSelected() async {
    if (!mounted) return;
    final controller = _mapController;
    if (controller == null) return;

    final items = _itemsWithPosition;
    if (items.isEmpty) return;

    final selectedItem = _filteredItems[_selectedIndex];

    // Only move camera if the selected item has valid coordinates
    if (selectedItem.position.latitude == 0.0 &&
        selectedItem.position.longitude == 0.0) {
      return;
    }

    if (!mounted) return;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: selectedItem.position, zoom: 15),
      ),
    );
  }

  /// Distinct marker hues for each item — cycles through the list so every marker is a different color
  static const List<double> _markerHues = [
    BitmapDescriptor.hueRed,
    BitmapDescriptor.hueOrange,
    BitmapDescriptor.hueYellow,
    BitmapDescriptor.hueGreen,
    BitmapDescriptor.hueCyan,
    BitmapDescriptor.hueAzure,
    BitmapDescriptor.hueBlue,
    BitmapDescriptor.hueViolet,
    BitmapDescriptor.hueMagenta,
    BitmapDescriptor.hueRose,
  ];

  Set<Marker> _buildMarkers() {
    final items = _itemsWithPosition;

    return items.asMap().entries.map((entry) {
      final markerIndex = entry.key;
      final item = entry.value;
      final actualIndex = _filteredItems.indexOf(item);
      final isSelected = actualIndex == _selectedIndex;

      // Pick a distinct hue based on position in the list
      final hue = _markerHues[markerIndex % _markerHues.length];
      // For the selected marker, use a slightly different visual: invert the hue list
      final selectedHue =
          _markerHues[(_markerHues.length - 1 - markerIndex) % _markerHues.length];

      return Marker(
        markerId: MarkerId(item.id),
        position: item.position,
        icon: BitmapDescriptor.defaultMarkerWithHue(
          isSelected ? selectedHue : hue,
        ),
        // All markers always show info window with title
        infoWindow: InfoWindow(
          title: item.title,
          snippet: '${item.category} \$${item.price}',
        ),
        onTap: () async {
          setState(() => _selectedIndex = actualIndex);
          // Scroll carousel to the tapped item
          if (_pageController.hasClients) {
            await _pageController.animateToPage(
              actualIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
          // Move camera
          _moveCameraToSelected();
        },
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(explorerMapProviderProvider);

    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: mapState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.map_outlined,
                size: 64.sp,
                color: AppColors.grey,
              ),
              SizedBox(height: 16.h),
              Text(
                'Could not load map data',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.text,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                err.toString(),
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              ElevatedButton(
                onPressed: () {
                  setState(() => _initialCameraSet = false);
                  ref.read(explorerMapProviderProvider.notifier).fetchMapData();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryLight,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.w,
                    vertical: 12.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (_) {
          final items = _filteredItems;
          final itemsWithPos = _itemsWithPosition;
          final categories = _categories;

          // Fit camera to show all markers on first data load
          if (!_initialCameraSet && itemsWithPos.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && !_initialCameraSet) {
                _fitWhenMapReady();
              }
            });
          }

          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: itemsWithPos.isNotEmpty
                    ? CameraPosition(
                        target: itemsWithPos.first.position,
                        zoom: 13,
                      )
                    : const CameraPosition(
                        target: ExplorerData.mapCenter,
                        zoom: 13,
                      ),
                markers: _buildMarkers(),
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                onMapCreated: (controller) {
                  if (!_mapControllerCompleter.isCompleted) {
                    _mapControllerCompleter.complete(controller);
                    _mapController = controller;
                    // If we haven't fitted markers yet, do it now
                    if (!_initialCameraSet && mounted) {
                      _fitCameraToAllMarkers();
                    }
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
                        viewMode: ExplorerViewMode.map,
                        onViewModeChanged: (mode) {
                          if (mode == ExplorerViewMode.list) {
                            context.pop();
                          }
                        },
                        onFilterTap: _openFilterBottomSheet,
                        filterCount: _filterCount,
                        hasFilters: _hasAnyFilter,
                      ),
                    ),
                    ExplorerCategoryChips(
                      categories: categories,
                      selectedCategory: _selectedCategory,
                      onCategorySelected: _onCategorySelected,
                    ),
                    // Active filter chips
                    if (_hasAnyFilter)
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
                        child: _buildActiveFilterChips(),
                      ),
                    // Marker count indicator
                    if (itemsWithPos.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
                        child: Text(
                          '${itemsWithPos.length} location${itemsWithPos.length == 1 ? '' : 's'} on map',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
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
                              final item = items[index];
                              final hasPosition =
                                  item.position.latitude != 0.0 ||
                                      item.position.longitude != 0.0;
                              return Padding(
                                padding: EdgeInsets.only(
                                  left: index == 0 ? 16.w : 6.w,
                                  right: 6.w,
                                  bottom: 12.h,
                                ),
                                child: Stack(
                                  children: [
                                    ExplorerMapPreviewCard(
                                      item: item,
                                      onTap: () => context.push(
                                        RouterPath.familyActivityDetailsScreen,
                                        extra: ActivityDetailsConfig.fromMapItem(
                                          item,
                                        ),
                                      ),
                                    ),
                                    if (!hasPosition)
                                      Positioned(
                                        top: 8.h,
                                        right: 8.w,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 6.w,
                                            vertical: 2.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.orange.shade100,
                                            borderRadius:
                                                BorderRadius.circular(4.r),
                                          ),
                                          child: Text(
                                            'No location',
                                            style: TextStyle(
                                              fontSize: 9.sp,
                                              color: Colors.orange.shade800,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
