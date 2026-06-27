import 'package:familyside/provider/service_provider/sp_analytics_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:familyside/core/localization/app_localizations.dart';
import 'package:familyside/core/theme/app_colors.dart';

class SpAnalyticsScreen extends ConsumerStatefulWidget {
  const SpAnalyticsScreen({super.key});

  @override
  ConsumerState<SpAnalyticsScreen> createState() => _SpAnalyticsScreenState();
}

class _SpAnalyticsScreenState extends ConsumerState<SpAnalyticsScreen> {
  int _selectedCategoryIndex = 0;
  String _selectedYear = DateTime.now().year.toString();

  final List<Map<String, String>> _categories = [
    {'name': 'profileViews', 'slug': 'profile_view'},
    {'name': 'userEngagement', 'slug': 'item_view'},
    {'name': 'totalActivities', 'slug': 'item_view'},
    {'name': 'platformReach', 'slug': 'platform_reach'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  void _fetchData() {
    ref.read(spAnalyticsProvider.notifier).fetchAnalyticsData(
          year: _selectedYear,
          category: _categories[_selectedCategoryIndex]['slug']!,
        );
  }

  @override
  Widget build(BuildContext context) {
    final analyticsState = ref.watch(spAnalyticsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              _buildHeader(),
              SizedBox(height: 24.h),
              _buildCategoriesSection(),
              SizedBox(height: 16.h),
              analyticsState.when(
                data: (data) => _buildChart(data),
                error: (err, stack) {
                  debugPrint('Error fetching analytics data: $err');
                  return const SizedBox.shrink();
                },
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
              SizedBox(height: 28.h),
              analyticsState.when(
                data: (data) => _buildSuggestionsSection(data),
                error: (err, stack) {
                  debugPrint('Error fetching suggestions: $err');
                  return const SizedBox.shrink();
                },
                loading: () => const SizedBox.shrink(),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final loc = AppLocalizations.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          loc.translate('analytics'),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 28.sp,
                color: AppColors.text,
              ),
        ),
        _buildYearDropdown(),
      ],
    );
  }

  List<String> _getYearList() {
    final currentYear = DateTime.now().year;
    return List.generate(5, (i) => (currentYear - 4 + i).toString());
  }

  Widget _buildYearDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedYear,
          isDense: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18.sp,
            color: AppColors.text,
          ),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.text,
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
              ),
          items: _getYearList().map((y) {
            return DropdownMenuItem(value: y, child: Text(y));
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              setState(() => _selectedYear = val);
              _fetchData();
            }
          },
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    final loc = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.translate('categories'),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
        ),
        SizedBox(height: 12.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(_categories.length, (i) {
              final isSelected = _selectedCategoryIndex == i;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedCategoryIndex = i);
                  _fetchData();
                },
                child: Container(
                  margin: EdgeInsets.only(right: 10.w),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryLight
                        : AppColors.primaryLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    loc.translate(_categories[i]['name']!),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? Colors.white
                              : AppColors.primaryLight,
                          fontWeight: FontWeight.w500,
                          fontSize: 13.sp,
                        ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildChart(List<dynamic> analyticsList) {
    if (analyticsList.isEmpty) return const SizedBox.shrink();

    final data = analyticsList.first.chartData ?? [];

    final spots = List.generate(
      data.length,
      (i) => FlSpot(i.toDouble(), (data[i].value ?? 0).toDouble()),
    );

    return Container(
      height: 240.h,
      padding: EdgeInsets.only(right: 16.w, top: 12.h, bottom: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 100,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 20,
            getDrawingHorizontalLine: (_) => FlLine(
              color: AppColors.border,
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 20,
                reservedSize: 36.w,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.lightText,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx < 0 || idx >= data.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: EdgeInsets.only(top: 6.h),
                    child: Text(
                      data[idx].label ?? '',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.lightText,
                      ),
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: false,
              color: const Color(0xFF1565C0),
              barWidth: 2,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, bar, index) =>
                    FlDotCirclePainter(
                  radius: 4,
                  color: const Color(0xFF1565C0),
                  strokeWidth: 0,
                ),
              ),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionsSection(List<dynamic> analyticsList) {
    if (analyticsList.isEmpty) return const SizedBox.shrink();
    final loc = AppLocalizations.of(context);
    final suggestion = analyticsList.first.suggestionText ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.translate('suggestionsForYou'),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
        ),
        SizedBox(height: 12.h),
        _buildSuggestionCard(suggestion),
      ],
    );
  }

  Widget _buildSuggestionCard(String text) {
    final loc = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/logo/app_logo.svg',
                height: 22.h,
                colorFilter: const ColorFilter.mode(
                  AppColors.primaryLight,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                loc.translate('brandName'),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primaryLight,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Quando',
                    ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.text,
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }
}
