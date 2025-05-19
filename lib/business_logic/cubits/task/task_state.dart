part of 'task_cubit.dart';

@immutable
sealed class TaskState extends Equatable {
  final List<Task> tasks;
  final String? errorMessage;

  const TaskState(this.tasks, {this.errorMessage});

  @override
  List<Object> get props => [tasks, errorMessage ?? ''];
}

final class TaskLoading extends TaskState {
  const TaskLoading(super.tasks);
}

final class TaskLoaded extends TaskState {
  const TaskLoaded(super.tasks);
}

final class TaskLoadError extends TaskState {
  const TaskLoadError(
    super.tasks, {
    super.errorMessage = 'Unable to load tasks',
  });
}

final class TaskAdding extends TaskState {
  const TaskAdding(super.tasks);
}

final class TaskAdded extends TaskState {
  const TaskAdded(super.tasks);
}

final class TaskAddError extends TaskState {
  const TaskAddError(super.tasks, {super.errorMessage = 'Unable to add task'});
}

final class TaskEditing extends TaskState {
  const TaskEditing(super.tasks);
}

final class TaskEdited extends TaskState {
  const TaskEdited(super.tasks);
}

final class TaskEditError extends TaskState {
  const TaskEditError(
    super.tasks, {
    super.errorMessage = 'Unable to edit task',
  });
}

final class TaskDeleting extends TaskState {
  const TaskDeleting(super.tasks);
}

final class TaskDeleted extends TaskState {
  const TaskDeleted(super.tasks);
}

final class TaskDeleteError extends TaskState {
  const TaskDeleteError(
    super.tasks, {
    super.errorMessage = 'Unable to delete task',
  });
}
