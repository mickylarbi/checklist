import 'package:checklist/ui/home/filter/filter_bottom_sheet.dart';
import 'package:checklist/ui/shared/custom_chip.dart';
import 'package:checklist/ui/shared/dialogs.dart';
import 'package:checklist/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class FilterRow extends StatelessWidget {
  const FilterRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          SizedBox(width: 24),
          CustomChip(),
          Spacer(),
          IconButton.filled(
            onPressed: () {
              showCustomBottomSheet(
                context: context,
                builder: (context) => FilterBottomSheet(),
              );
            },
            style: IconButton.styleFrom(
              backgroundColor: secondaryColor.withAlpha(40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedFilterHorizontal,
              color: secondaryColor,
            ),
          ),
          SizedBox(width: 24),
        ],
      ),
    );
  }
}
