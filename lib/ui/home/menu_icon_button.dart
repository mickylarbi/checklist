import 'dart:developer';
import 'package:checklist/business_logic/cubits/task/task_cubit.dart';
import 'package:checklist/business_logic/services/db_service.dart';
import 'package:checklist/ui/shared/dialogs.dart';
import 'package:checklist/utils/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

class MenuIconButton extends StatelessWidget {
  const MenuIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.more_horiz, color: Colors.black),
      onPressed: () {
        showCupertinoModalPopup(
          context: context,
          builder:
              (ctx) => CupertinoActionSheet(
                actions: [
                  CupertinoActionSheetAction(
                    onPressed: () async {
                      Navigator.pop(ctx);
                      // Action 1 logic here
                      try {
                        showToastNotification(
                          context,
                          'Backing up...',
                          type: ToastificationType.info,
                        );
                        await backupTasksToFirestore();
                        if (context.mounted) {
                          showToastNotification(
                            context,
                            'Backup successful!',
                            type: ToastificationType.success,
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          showToastNotification(
                            context,
                            'Backup failed!',
                            type: ToastificationType.success,
                          );
                        }
                      }
                    },
                    child: Text('Backup to cloud'),
                  ),
                  CupertinoActionSheetAction(
                    onPressed: () async {
                      Navigator.pop(ctx);
                      // Action 2 logic here
                      try {
                        showToastNotification(
                          context,
                          'Restoring backup...',
                          type: ToastificationType.info,
                        );
                        await restoreTasksFromFirestore();
                        if (context.mounted) {
                          context.read<TaskCubit>().getTasks();
                          showToastNotification(
                            context,
                            'Restore successful!',
                            type: ToastificationType.success,
                          );
                        }
                      } catch (e) {
                        log('$e');

                        if (context.mounted) {
                          showToastNotification(
                            context,
                            'Restore failed!',
                            type: ToastificationType.error,
                          );
                        }
                      }
                    },
                    child: Text('Restore backup'),
                  ),
                  CupertinoActionSheetAction(
                    onPressed: () async {
                      Navigator.pop(ctx);
                      try {
                        showToastNotification(
                          context,
                          'Exporting CSV...',
                          type: ToastificationType.info,
                        );
                        // Fetch all tasks from local DB
                        final items = await DBService().getItems();
                        final csvString = listToCsv(items);
                        await shareCsvBuffer(
                          csvString,
                          fileName: 'tasks_export.csv',
                        );
                      } catch (e) {
                        if (context.mounted) {
                          showToastNotification(
                            context,
                            'CSV export failed!',
                            type: ToastificationType.error,
                          );
                        }
                      }
                    },
                    child: Text('Export as CSV'),
                  ),
                ],
                cancelButton: CupertinoActionSheetAction(
                  onPressed: () => Navigator.pop(context),
                  isDefaultAction: true,
                  child: const Text('Cancel'),
                ),
              ),
        );
      },
    );
  }
}
