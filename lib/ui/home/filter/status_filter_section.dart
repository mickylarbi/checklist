import 'package:checklist/business_logic/enums/status.dart';
import 'package:checklist/ui/home/filter/status_filter_bottom_sheet_item.dart';
import 'package:checklist/ui/shared/text_themes.dart';
import 'package:flutter/material.dart';

class StatusFilterSection extends StatelessWidget {
  const StatusFilterSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      physics: const NeverScrollableScrollPhysics(),
      primary: false,
      shrinkWrap: true,
      children: [
        Text(
          'Status',
          style: labelMedium(
            context,
          ).copyWith(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        SizedBox(height: 10),
        StatusFilterBottomSheetItem(
          isSelected: false,
          status: TaskStatus.toDo,
        ),
        SizedBox(height: 10),
        StatusFilterBottomSheetItem(
          isSelected: false,
          status: TaskStatus.inProgress,
        ),
        SizedBox(height: 10),
        StatusFilterBottomSheetItem(
          isSelected: false,
          status: TaskStatus.done,
        ),
      ],
    );
  }
}
