import 'package:checklist/business_logic/enums/task_status.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class StatusFilterBottomSheetItem extends StatelessWidget {
  const StatusFilterBottomSheetItem({
    super.key,
    required this.isSelected,
    required this.status,
    this.onPressed,
  });
  final bool isSelected;
  final TaskStatus status;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    String text = getTaskStatusName(status);
    IconData iconData = getTaskStatusIcon(status);
    Color color = getTaskStatusColor(status);

    return FilledButton.icon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        elevation: 0,
        backgroundColor: isSelected ? color.withAlpha(40) : Colors.transparent,
        foregroundColor: color,
        textStyle: GoogleFonts.montserratTextTheme().bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: isSelected ? null : BorderSide(color: color),
        padding: const EdgeInsets.all(12),
      ),
      icon: HugeIcon(icon: iconData, color: color),
      label: Text(text),
    );
  }
}
