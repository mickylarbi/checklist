import 'package:checklist/business_logic/models/task.dart';
import 'package:checklist/ui/shared/text_themes.dart';
import 'package:checklist/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

class TaskListTile extends StatelessWidget {
  const TaskListTile({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Buy groceries', style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(height: 10),
          Text(
            'Pick up milk, eggs, bread, fruit and snacks',
            style: bodySmall(context).copyWith(color: Colors.grey),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(
                '${DateFormat.MMMEd().format(DateTime.now())} at ${DateFormat.jm().format(DateTime.now())}',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              HugeIcon(
                icon: HugeIcons.strokeRoundedTimeHalfPass,
                color: secondaryColor,
                size: 16,
              ),
              SizedBox(width: 10),
              Text(
                'In Progress',
                style: TextStyle(
                  color: secondaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
