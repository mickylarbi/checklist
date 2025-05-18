import 'package:checklist/business_logic/enums/status.dart';
import 'package:checklist/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class StatusFilterBottomSheetItem extends StatelessWidget {
  const StatusFilterBottomSheetItem({
    super.key,
    required this.isSelected,
    required this.status,
  });
  final bool isSelected;
  final TaskStatus status;

  @override
  Widget build(BuildContext context) {
    String text;
    IconData iconData;
    Color color;

    switch (status) {
      case TaskStatus.toDo:
        text = 'To Do';
        iconData = HugeIcons.strokeRoundedTask01;
        color = Colors.grey;
      case TaskStatus.inProgress:
        text = 'In Progress';
        iconData = HugeIcons.strokeRoundedTimeHalfPass;
        color = secondaryColor;
      case TaskStatus.done:
        text = 'Done';
        iconData = HugeIcons.strokeRoundedCheckmarkSquare03;
        color = primaryColor;
    }

    return FilledButton.icon(
      onPressed: () {},
      style: FilledButton.styleFrom(
        elevation: 0,
        backgroundColor: isSelected ? color.withAlpha(40) : Colors.transparent,
        foregroundColor: color,
        textStyle: GoogleFonts.montserratTextTheme().bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: isSelected ? null : BorderSide(color: color),
        padding: const EdgeInsets.all(20),
      ),
      icon: HugeIcon(icon: iconData, color: color),
      label: Text(text),
    );
  }
}
