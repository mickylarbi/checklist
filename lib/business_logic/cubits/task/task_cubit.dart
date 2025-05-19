import 'dart:developer';

import 'package:checklist/business_logic/models/task.dart';
import 'package:checklist/business_logic/services/db_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskLoaded([]));

  //CRUD

  addTask(Task task) async {
    try {
      emit(TaskAdding(state.tasks));

      String id = Uuid().v4();
      final newTask = task.copyWith(id: id, createdAt: DateTime.now());
      await DBService().insertItem(newTask.toMap());

      emit(TaskAdded([...state.tasks, newTask]));

      final items = await DBService().getItems();
      final tasks = items.map((item) => Task.fromMap(item)).toList();
      emit(TaskLoaded(tasks));
    } catch (e) {
      log('error: $e');
      emit(TaskAddError(state.tasks));
      emit(TaskLoaded(state.tasks));
    }
  }

  editTask(Task task) {
    emit(TaskEditing(state.tasks));

    try {
      if (task.id == null) throw Exception('No task id found');

      // tasks = tasks.map((e) => e.id == task.id ? task : e).toList();

      emit(TaskEdited(state.tasks));
      emit(TaskLoaded(state.tasks));
    } catch (e) {
      log('error: $e');
      emit(TaskEditError(state.tasks));
      emit(TaskLoaded(state.tasks));
    }
  }

  deleteTask(Task task) {
    try {
      emit(TaskDeleting(state.tasks));

      if (task.id == null) throw Exception('No task id found');

      // tasks.removeWhere((e) => e.id == task.id);

      emit(TaskDeleted(state.tasks));
      emit(TaskLoaded(state.tasks));
    } catch (e) {
      log('error: $e');
      emit(TaskDeleteError(state.tasks, errorMessage: 'Unable to delete task'));
      emit(TaskLoaded(state.tasks));
    }
  }
}
