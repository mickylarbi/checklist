import 'package:checklist/ui/home/filter/date_time_filter_section.dart';
import 'package:checklist/ui/home/filter/status_filter_section.dart';
import 'package:checklist/ui/shared/custom_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HugeIcon(
            icon: HugeIcons.strokeRoundedFilterHorizontal,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          SizedBox(width: 10),
          Text('Filter', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          StatusFilterSection(),
          Divider(height: 40),
          DateTimeFilterSection(),
        ],
      ),
    );
  }
}
