import 'dart:convert';
import 'dart:developer';

import 'package:checklist/business_logic/cubits/task/task_cubit.dart';
import 'package:checklist/business_logic/enums/task_status.dart';
import 'package:checklist/business_logic/models/task.dart';
import 'package:checklist/business_logic/services/db_service.dart';
import 'package:checklist/ui/home/task_details/a_i_button.dart';
import 'package:checklist/ui/home/task_details/date_and_time_section.dart';
import 'package:checklist/ui/home/task_details/status_drop_down_form_field.dart';
import 'package:checklist/ui/shared/custom_filled_button.dart';
import 'package:checklist/ui/shared/custom_text_form_field.dart';
import 'package:checklist/ui/shared/dialogs.dart';
import 'package:checklist/utils/variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:toastification/toastification.dart';

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({super.key, this.task});
  final Task? task;

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateNotifier = ValueNotifier<DateTime>(DateTime.now());
  final timeNotifier = ValueNotifier<DateTime>(DateTime.now());
  final statusNotifier = ValueNotifier<TaskStatus>(TaskStatus.done);

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    titleController.text = widget.task?.title ?? '';
    descriptionController.text = widget.task?.description ?? '';
    dateNotifier.value = widget.task?.dateTime ?? DateTime.now();
    timeNotifier.value = widget.task?.dateTime ?? DateTime.now();
    statusNotifier.value = widget.task?.status ?? TaskStatus.toDo;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white.withAlpha(70),
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          title: Text('Add task'),
          actions: [
            if (widget.task != null)
              IconButton.filled(
                onPressed: () {
                  showCupertinoDialog(
                    context: context,
                    builder:
                        (ctx) => CupertinoAlertDialog(
                          title: Text('Delete Task'),
                          content: Text(
                            'Are you sure you want to delete this task?',
                          ),
                          actions: [
                            CupertinoDialogAction(
                              child: Text('Cancel'),
                              onPressed: () => Navigator.of(ctx).pop(),
                            ),
                            CupertinoDialogAction(
                              isDestructiveAction: true,
                              child: Text('Delete'),
                              onPressed: () {
                                Navigator.of(ctx).pop();
                                if (widget.task != null) {
                                  context.read<TaskCubit>().deleteTask(
                                    widget.task!,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                  );
                },
                style: IconButton.styleFrom(
                  backgroundColor: Colors.red.withAlpha(40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedDelete02,
                  color: Colors.red,
                ),
              ),
            SizedBox(width: 12),
          ],
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Form(
              key: formKey,
              child: ListView(
                padding: EdgeInsets.all(24).copyWith(bottom: 150),
                children: [
                  CustomTextFormField(
                    controller: titleController,
                    labelText: 'Title',
                    validator: (value) {
                      if (value?.isEmpty == true) return 'Please enter a title';
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  CustomTextFormField(
                    controller: descriptionController,
                    labelText: 'Description',
                    minLines: 5,
                  ),
                  SizedBox(height: 10),
                  AIButton(
                    onPressed: () async {
                      if (titleController.text.trim().isEmpty) {
                        showToastNotification(
                          context,
                          'Please add a title',
                          type: ToastificationType.warning,
                        );
                        return;
                      }

                      showToastNotification(context, 'Generating description');

                      try {
                        final uri = Uri.https(authority, 'suggest/description');

                        final task = Task(
                          id: widget.task?.id,
                          title: titleController.text.trim(),
                          description:
                              descriptionController.text.trim().isEmpty
                                  ? null
                                  : descriptionController.text.trim(),
                          dateTime: DateTime(
                            dateNotifier.value.year,
                            dateNotifier.value.month,
                            dateNotifier.value.day,
                            timeNotifier.value.hour,
                            timeNotifier.value.minute,
                            timeNotifier.value.second,
                            timeNotifier.value.millisecond,
                            timeNotifier.value.microsecond,
                          ),
                          status: statusNotifier.value,
                          createdAt: DateTime.now(),
                        );

                        final items = await DBService().getItems();

                        final json = jsonEncode({
                          "task": task.toMap(),
                          "context": items,
                        });

                        final response = await post(
                          uri,
                          body: json,
                          headers: {'Content-Type': 'application/json'},
                        );

                        log('status code: ${response.statusCode}');
                        log('body: ${response.body}');

                        if (response.statusCode == 201) {
                          descriptionController.text =
                              jsonDecode(response.body)[0];
                        } else {
                          throw Exception();
                        }
                      } catch (e) {
                        log('error: $e');
                        if (context.mounted) {
                          showToastNotification(
                            context,
                            'Unable to generate description',
                            type: ToastificationType.error,
                          );
                        }
                      }
                    },
                  ),
                  Divider(height: 80),
                  DateAndTimeSection(
                    dateNotifier: dateNotifier,
                    timeNotifier: timeNotifier,
                  ),
                  AIButton(
                    onPressed: () async {
                      if (titleController.text.trim().isEmpty) {
                        showToastNotification(
                          context,
                          'Please add a title',
                          type: ToastificationType.warning,
                        );
                        return;
                      }

                      showToastNotification(context, 'Generating description');

                      try {
                        final uri = Uri.https(authority, 'suggest/due-date');

                        final task = Task(
                          id: widget.task?.id,
                          title: titleController.text.trim(),
                          description:
                              descriptionController.text.trim().isEmpty
                                  ? null
                                  : descriptionController.text.trim(),
                          dateTime: DateTime(
                            dateNotifier.value.year,
                            dateNotifier.value.month,
                            dateNotifier.value.day,
                            timeNotifier.value.hour,
                            timeNotifier.value.minute,
                            timeNotifier.value.second,
                            timeNotifier.value.millisecond,
                            timeNotifier.value.microsecond,
                          ),
                          status: statusNotifier.value,
                          createdAt: DateTime.now(),
                        );

                        final items = await DBService().getItems();

                        final json = jsonEncode({
                          "task": task.toMap(),
                          "context": items,
                        });

                        final response = await post(
                          uri,
                          body: json,
                          headers: {'Content-Type': 'application/json'},
                        );

                        log('status code: ${response.statusCode}');
                        log('body: ${response.body}');

                        if (response.statusCode == 201) {
                          final datetime = DateTime.parse(
                            jsonDecode(response.body)[0],
                          );

                          dateNotifier.value = datetime;
                          timeNotifier.value = datetime;
                        } else {
                          throw Exception();
                        }
                      } catch (e) {
                        log('error: $e');
                        if (context.mounted) {
                          showToastNotification(
                            context,
                            'Unable to generate due date',
                            type: ToastificationType.error,
                          );
                        }
                      }
                    },
                  ),

                  Divider(height: 80),
                  Text('Set status'),
                  SizedBox(height: 10),
                  StatusDropDownFormField(statusNotifier: statusNotifier),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(24).copyWith(bottom: 32),
              child: CustomFilledButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocConsumer<TaskCubit, TaskState>(
                      listener: (BuildContext context, TaskState state) {
                        if (state is TaskAdded ||
                            state is TaskEdited ||
                            state is TaskDeleted) {
                          Navigator.pop(context);
                        }

                        if (state is TaskAddError ||
                            state is TaskEditError ||
                            state is TaskDeleteError) {
                          showToastNotification(
                            context,
                            state.errorMessage ?? 'Something went wrong',
                            type: ToastificationType.error,
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is TaskAdding ||
                            state is TaskEditing ||
                            state is TaskDeleting) {
                          return SpinKitDoubleBounce(
                            size: 12,
                            color: Colors.white,
                          );
                        }

                        return Text(
                          'Save',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                  ],
                ),
                onPressed: () {
                  if (formKey.currentState?.validate() == true) {
                    if (widget.task == null) {
                      context.read<TaskCubit>().addTask(
                        Task.newTask(
                          title: titleController.text.trim(),
                          description:
                              descriptionController.text.trim().isEmpty
                                  ? null
                                  : descriptionController.text.trim(),
                          dateTime: DateTime(
                            dateNotifier.value.year,
                            dateNotifier.value.month,
                            dateNotifier.value.day,
                            timeNotifier.value.hour,
                            timeNotifier.value.minute,
                            timeNotifier.value.second,
                            timeNotifier.value.millisecond,
                            timeNotifier.value.microsecond,
                          ),
                          status: statusNotifier.value,
                          createdAt: DateTime.now(),
                        ),
                      );
                    } else {
                      Task newTask = Task(
                        id: widget.task!.id,
                        title: titleController.text.trim(),
                        description:
                            descriptionController.text.trim().isEmpty
                                ? null
                                : descriptionController.text.trim(),
                        dateTime: DateTime(
                          dateNotifier.value.year,
                          dateNotifier.value.month,
                          dateNotifier.value.day,
                          timeNotifier.value.hour,
                          timeNotifier.value.minute,
                          timeNotifier.value.second,
                          timeNotifier.value.millisecond,
                          timeNotifier.value.microsecond,
                        ),
                        status: statusNotifier.value,
                        createdAt: DateTime.now(),
                      );

                      if (widget.task != newTask) {
                        context.read<TaskCubit>().editTask(newTask);
                      }
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    dateNotifier.dispose();
    timeNotifier.dispose();
    statusNotifier.dispose();

    super.dispose();
  }
}
