import 'package:checklist/ui/home/task_details/a_i_button.dart';
import 'package:checklist/ui/home/task_details/date_and_time_section.dart';
import 'package:checklist/ui/shared/custom_filled_button.dart';
import 'package:checklist/ui/shared/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class TaskDetailsScreen extends StatelessWidget {
  const TaskDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Add task')),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ListView(
            padding: EdgeInsets.all(24).copyWith(bottom: 150),
            children: [
              CustomTextFormField(labelText: 'Title'),
              SizedBox(height: 20),
              CustomTextFormField(labelText: 'Description', minLines: 5),
              SizedBox(height: 10),
              AIButton(),
              Divider(height: 80),
              DateAndTimeSection(),
              Divider(height: 80),
              Text('Set status'),
              SizedBox(height: 10),
              CustomTextFormField(
                labelText: 'Status',
                suffixIcon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                enabled: false,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(24).copyWith(bottom: 32),
            child: CustomFilledButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
