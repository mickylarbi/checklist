import 'package:checklist/ui/shared/text_themes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DateTimeFilterSection extends StatelessWidget {
  const DateTimeFilterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      physics: const NeverScrollableScrollPhysics(),
      primary: false,
      shrinkWrap: true,
      children: [
        Text(
          'Date and time',
          style: labelMedium(
            context,
          ).copyWith(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        ...DateTimeFilterValue.values.map(
          (value) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10),
              DateTimeFilterBottomSheetItem(isSelected: false, status: value),
            ],
          ),
        ),
      ],
    );
  }
}

class DateTimeFilterBottomSheetItem extends StatelessWidget {
  const DateTimeFilterBottomSheetItem({
    super.key,
    required this.isSelected,
    required this.status,
  });
  final bool isSelected;
  final DateTimeFilterValue status;

  @override
  Widget build(BuildContext context) {
    String text;

    switch (status) {
      case DateTimeFilterValue.overdue:
        text = 'Overdue';
      case DateTimeFilterValue.upcoming:
        text = 'Upcoming';
      case DateTimeFilterValue.today:
        text = 'Today';
      case DateTimeFilterValue.tomorrow:
        text = 'Tomorrow';
      case DateTimeFilterValue.thisWeek:
        text = 'This Week';
      case DateTimeFilterValue.nextWeek:
        text = 'Next Week';
    }

    return FilledButton(
      onPressed: () {},
      style: FilledButton.styleFrom(
        elevation: 0,
        backgroundColor:
            isSelected ? Colors.grey.withAlpha(40) : Colors.transparent,
        foregroundColor: Colors.grey,
        textStyle: GoogleFonts.montserratTextTheme().bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: isSelected ? null : BorderSide(color: Colors.grey),
        padding: const EdgeInsets.all(20),
      ),
      child: Text(text),
    );
  }
}

enum DateTimeFilterValue {
  overdue,
  upcoming,
  today,
  tomorrow,
  thisWeek,
  nextWeek,
}
