import 'package:checklist/ui/shared/dialogs.dart';
import 'package:checklist/ui/shared/text_themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:toastification/toastification.dart';

class EditNameListTile extends StatefulWidget {
  const EditNameListTile({super.key,});

  @override
  State<EditNameListTile> createState() => _EditNameListTileState();
}

class _EditNameListTileState extends State<EditNameListTile> {
  User get user => FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        final controller = TextEditingController(text: user.displayName ?? '');
        bool? hasChanged = await showCupertinoDialog(
          context: context,
          builder: (context) {
            bool loading = false;
            String? error;

            return StatefulBuilder(
              builder:
                  (context, setState) => CupertinoAlertDialog(
                    title: const Text('Edit Name'),
                    content: Column(
                      children: [
                        const SizedBox(height: 8),
                        CupertinoTextField(
                          controller: controller,
                          placeholder: 'Enter your name',
                          enabled: !loading,
                        ),
                        if (error != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            error!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ],
                    ),
                    actions: [
                      CupertinoDialogAction(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      CupertinoDialogAction(
                        onPressed:
                            loading
                                ? null
                                : () async {
                                  setState(() {
                                    loading = true;
                                    error = null;
                                  });
                                  try {
                                    await user.updateDisplayName(
                                      controller.text.trim(),
                                    );
                                    await user.reload();
                                    if (context.mounted) {
                                      Navigator.of(context).pop(true);
                                    }
                                  } catch (e) {
                                    setState(() {
                                      error = 'Failed to update name';
                                      loading = false;
                                    });
                                  }
                                },
                        child:
                            loading
                                ? const CupertinoActivityIndicator()
                                : const Text('Save'),
                      ),
                    ],
                  ),
            );
          },
        );

        controller.dispose();

        if (hasChanged == true) {
          setState(() {
            showToastNotification(
              context,
              'Name changed successfully',
              type: ToastificationType.success,
            );
          });
        }
      },
      leading: HugeIcon(icon: HugeIcons.strokeRoundedUser, color: Colors.grey),
      title: Text(user.displayName ?? '-'),
      subtitle: Text(
        'Name',
        style: labelMedium(
          context,
        ).copyWith(color: Colors.grey, fontWeight: FontWeight.bold),
      ),
      trailing: HugeIcon(
        icon: HugeIcons.strokeRoundedEdit02,
        color: Colors.grey,
      ),
    );
  }
}
