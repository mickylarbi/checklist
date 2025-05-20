import 'package:checklist/business_logic/cubits/task/task_cubit.dart';
import 'package:checklist/business_logic/enums/task_status.dart';
import 'package:checklist/business_logic/models/task.dart';
import 'package:checklist/ui/home/task_details/task_details_screen.dart';
import 'package:checklist/ui/shared/text_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

class TaskListTile extends StatelessWidget {
  const TaskListTile({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => BlocProvider.value(
                  value: context.read<TaskCubit>(),
                  child: TaskDetailsScreen(task: task),
                ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.title, style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 10),
            if (task.description != null)
              Text(
                task.description!,
                style: bodySmall(context).copyWith(color: Colors.grey),
              ),
            if (task.description != null) SizedBox(height: 10),
            Row(
              children: [
                Text(
                  '${DateFormat.MMMEd().format(task.dateTime)} at ${DateFormat.jm().format(task.dateTime)}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                HugeIcon(
                  icon: getTaskStatusIcon(task.status),
                  color: getTaskStatusColor(task.status),
                  size: 16,
                ),
                SizedBox(width: 10),
                Text(
                  getTaskStatusName(task.status),
                  style: TextStyle(
                    color: getTaskStatusColor(task.status),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
