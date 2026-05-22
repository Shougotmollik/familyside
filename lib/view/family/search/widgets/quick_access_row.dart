import 'package:familyside/model/search_data.dart';
import 'package:familyside/view/family/search/widgets/quick_access_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuickAccessRow extends StatelessWidget {
  const QuickAccessRow({
    super.key,
    required this.items,
    this.onItemTap,
  });

  final List<QuickAccessItem> items;
  final void Function(QuickAccessItem item)? onItemTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) SizedBox(width: 10.w),
          Expanded(
            child: QuickAccessCard(
              item: items[i],
              onTap: onItemTap != null ? () => onItemTap!(items[i]) : null,
            ),
          ),
        ],
      ],
    );
  }
}
