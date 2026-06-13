import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class SpHomeSkeleton extends StatelessWidget {
  const SpHomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          children: [
            _buildHeaderSkeleton(),
            SizedBox(height: 24.h),
            _buildSectionTitleSkeleton(),
            SizedBox(height: 12.h),
            ...List.generate(2, (_) => _buildCardSkeleton()),
            SizedBox(height: 8.h),
            _buildSectionTitleSkeleton(),
            SizedBox(height: 12.h),
            ...List.generate(2, (_) => _buildCardSkeleton()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSkeleton() {
    return Row(
      children: [
        Container(width: 52.w, height: 52.w, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: 180.w, height: 18.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4.r))),
              SizedBox(height: 8.h),
              Container(width: 120.w, height: 14.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4.r))),
            ],
          ),
        ),
        Container(width: 40.w, height: 40.w, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
      ],
    );
  }

  Widget _buildSectionTitleSkeleton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(width: 140.w, height: 20.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4.r))),
        Container(width: 60.w, height: 16.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4.r))),
      ],
    );
  }

  Widget _buildCardSkeleton() {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(10.w),
      height: 130.h,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14.r)),
      child: Row(
        children: [
          Container(width: 110.w, height: 110.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r))),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: double.infinity, height: 16.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4.r))),
                SizedBox(height: 8.h),
                Container(width: 100.w, height: 14.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4.r))),
                const Spacer(),
                Container(width: double.infinity, height: 14.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4.r))),
              ],
            ),
          )
        ],
      ),
    );
  }
}
