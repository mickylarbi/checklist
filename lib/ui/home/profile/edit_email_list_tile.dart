import 'dart:developer';

import 'package:checklist/ui/shared/dialogs.dart';
import 'package:checklist/ui/shared/text_themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class EditEmailListTile extends StatefulWidget {
  const EditEmailListTile({super.key});

  @override
  State<EditEmailListTile> createState() => _EditEmailListTileState();
}

class _EditEmailListTileState extends State<EditEmailListTile> {
  User get user => FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        final controller = TextEditingController(text: user.email ?? '');
        bool? hasChanged = await showCupertinoDialog(
          context: context,
          builder: (context) {
            bool loading = false;
            String? error;

            return StatefulBuilder(
              builder:
                  (context, setState) => CupertinoAlertDialog(
                    title: const Text('Edit Email'),
                    content: Column(
                      children: [
                        const SizedBox(height: 8),
                        CupertinoTextField(
                          controller: controller,
                          placeholder: 'Enter your email',
                          enabled: !loading,
                          keyboardType: TextInputType.emailAddress,
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
                                    await user.verifyBeforeUpdateEmail(
                                      controller.text.trim(),
                                    );
                                    await user.reload();
                                    if (context.mounted) {
                                      Navigator.of(context).pop(true);
                                    }
                                  } catch (e) {
                                    log('error updating email: $e');
                                    setState(() {
                                      error = 'Failed to update email';
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

        if (hasChanged == true && context.mounted) {
          showToastNotification(
            context,
            'Please check your new email for instructions to change your email',
          );
        }
      },
      leading: HugeIcon(
        icon: HugeIcons.strokeRoundedMail01,
        color: Colors.grey,
      ),
      title: Text(user.email ?? '-'),
      subtitle: Text(
        'Email',
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
