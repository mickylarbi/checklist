
import 'package:checklist/business_logic/cubits/task/task_cubit.dart';
import 'package:checklist/ui/home/task_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskListView extends StatelessWidget {
  const TaskListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        return ListView.separated(
          itemCount: state.tasks.length,
          separatorBuilder: (BuildContext context, int index) {
            return Divider(height: 0);
          },
          itemBuilder: (BuildContext context, int index) {
            return TaskListTile(task: state.tasks[index]);
          },
        );
      },
    );
  }
}
