import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:familyside/core/theme/app_colors.dart';

class SpAnalyticsScreen extends StatefulWidget {
  const SpAnalyticsScreen({super.key});

  @override
  State<SpAnalyticsScreen> createState() => _SpAnalyticsScreenState();
}

class _SpAnalyticsScreenState extends State<SpAnalyticsScreen> {
  int _selectedCategoryIndex = 0;
  String _selectedYear = '2025';

  final List<String> _categories = [
    'Profile Views',
    'User engagement',
    'Total Activities',
    'Platform Reach',
  ];

  // Data sets per category (Jan–Jun)
  final List<List<double>> _chartData = [
    [-65, -25, -65, 55, -15, 20, -65],   // Profile Views
    [-40, 10, -30, 40, -5, 30, -50],      // User engagement
    [-50, -10, -50, 70, -20, 15, -55],    // Total Activities
    [-30, 20, -40, 60, -10, 25, -45],     // Platform Reach
  ];

  final List<String> _months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mai', 'Jun'];

  @override
  Widget build(BuildContext context) {
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
              _buildChart(),
              SizedBox(height: 28.h),
              _buildSuggestionsSection(),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Analytics',
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
          items: ['2023', '2024', '2025'].map((y) {
            return DropdownMenuItem(value: y, child: Text(y));
          }).toList(),
          onChanged: (val) {
            if (val != null) setState(() => _selectedYear = val);
          },
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
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
                onTap: () => setState(() => _selectedCategoryIndex = i),
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
                    _categories[i],
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

  Widget _buildChart() {
    final data = _chartData[_selectedCategoryIndex];

    final spots = List.generate(
      data.length,
      (i) => FlSpot(i.toDouble(), data[i]),
    );

    return Container(
      height: 240.h,
      padding: EdgeInsets.only(right: 16.w, top: 12.h, bottom: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: LineChart(
        LineChartData(
          minY: -100,
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
                interval: 40,
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
                  if (idx < 0 || idx >= _months.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: EdgeInsets.only(top: 6.h),
                    child: Text(
                      _months[idx],
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

  Widget _buildSuggestionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Suggestions For You',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
        ),
        SizedBox(height: 12.h),
        _buildSuggestionCard(),
      ],
    );
  }

  Widget _buildSuggestionCard() {
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
                'Familyside',
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
            'Consectetur adipiscing elit. Vehicula massa in enim luctus. Rutrum arcu, aliquam nulla tincidunt gravida. Cursus convallis dolor semper pretium ornare.',
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
