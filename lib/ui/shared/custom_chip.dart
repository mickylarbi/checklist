import 'package:checklist/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class CustomChip extends StatelessWidget {
  const CustomChip({super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {},
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(horizontal: 10),
        foregroundColor: secondaryColor,
        backgroundColor: secondaryColor.withAlpha(40),
      ),
      child: Row(
        children: [
          Text('Today'),
          SizedBox(width: 10),
          InkWell(
            onTap: () {},
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedCancelSquare,
              color: secondaryColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
