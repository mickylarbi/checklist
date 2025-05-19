import 'package:checklist/business_logic/enums/task_status.dart';
import 'package:checklist/ui/home/filter/status_filter_bottom_sheet_item.dart';
import 'package:checklist/ui/shared/custom_bottom_sheet.dart';
import 'package:checklist/ui/shared/custom_text_form_field.dart';
import 'package:checklist/ui/shared/dialogs.dart';
import 'package:checklist/ui/shared/text_themes.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class StatusDropDownFormField extends StatelessWidget {
  const StatusDropDownFormField({super.key, required this.statusNotifier});

  final ValueNotifier<TaskStatus> statusNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TaskStatus>(
      valueListenable: statusNotifier,
      builder: (context, value, child) {
        List<TaskStatus> statuses =
            TaskStatus.values.where((e) => e != value).toList();

        return GestureDetector(
          onTap: () {
            showCustomBottomSheet(
              context: context,
              builder:
                  (context) => CustomBottomSheet(
                    body: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(24),
                      itemCount: statuses.length,
                      itemBuilder: (BuildContext context, int index) {
                        TaskStatus status = statuses[index];
                        return StatusFilterBottomSheetItem(
                          onPressed: () {
                            statusNotifier.value = status;
                            Navigator.pop(context);
                          },
                          isSelected: status == value,
                          status: status,
                        );
                      },
                      separatorBuilder:
                          (context, index) => const SizedBox(height: 20),
                    ),
                    title: Text('Status'),
                  ),
            );
          },
          child: CustomTextFormField(
            labelText: getTaskStatusName(value),
            labelStyle: bodyMedium(context).copyWith(
              color: getTaskStatusColor(value),
              fontWeight: FontWeight.w600,
            ),

            prefixIcon: HugeIcon(
              icon: getTaskStatusIcon(value),
              color: getTaskStatusColor(value),
            ),
            suffixIcon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            enabled: false,
          ),
        );
      },
    );
  }
}
