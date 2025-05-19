import 'package:checklist/business_logic/cubits/task/task_cubit.dart';
import 'package:checklist/business_logic/enums/task_status.dart';
import 'package:checklist/business_logic/models/task.dart';
import 'package:checklist/ui/home/task_details/a_i_button.dart';
import 'package:checklist/ui/home/task_details/date_and_time_section.dart';
import 'package:checklist/ui/home/task_details/status_drop_down_form_field.dart';
import 'package:checklist/ui/shared/custom_filled_button.dart';
import 'package:checklist/ui/shared/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
          backgroundColor: Colors.white.withAlpha(70),
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          title: Text('Add task'),
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
                  AIButton(),
                  Divider(height: 80),
                  DateAndTimeSection(
                    dateNotifier: dateNotifier,
                    timeNotifier: timeNotifier,
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
                    context.read<TaskCubit>().addTask(
                      Task.newTask(
                        title: titleController.text,
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
