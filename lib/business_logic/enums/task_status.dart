import 'package:checklist/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

enum TaskStatus { toDo, inProgress, done }

getTaskStatusIcon(TaskStatus status) {
  switch (status) {
    case TaskStatus.toDo:
      return HugeIcons.strokeRoundedTask01;
    case TaskStatus.inProgress:
      return HugeIcons.strokeRoundedTimeHalfPass;
    case TaskStatus.done:
      return HugeIcons.strokeRoundedCheckmarkSquare03;
  }
}

getTaskStatusColor(TaskStatus status) {
  switch (status) {
    case TaskStatus.toDo:
      return Colors.grey;
    case TaskStatus.inProgress:
      return secondaryColor;
    case TaskStatus.done:
      return primaryColor;
  }
}

getTaskStatusName(TaskStatus status) {
  switch (status) {
    case TaskStatus.toDo:
      return 'To Do';

    case TaskStatus.inProgress:
      return 'In Progress';

    case TaskStatus.done:
      return 'Done';
  }
}
