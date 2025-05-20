import 'package:checklist/ui/shared/dialogs.dart';
import 'package:checklist/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:toastification/toastification.dart';

class ChangePasswordListTile extends StatefulWidget {
  const ChangePasswordListTile({super.key});

  @override
  State<ChangePasswordListTile> createState() => _ChangePasswordListTileState();
}

class _ChangePasswordListTileState extends State<ChangePasswordListTile> {
  User get user => FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        final currentPasswordController = TextEditingController();
        final newPasswordController = TextEditingController();
        final confirmPasswordController = TextEditingController();
        bool? hasChanged = await showCupertinoDialog(
          context: context,
          builder: (context) {
            bool loading = false;
            String? error;

            return StatefulBuilder(
              builder:
                  (context, setState) => CupertinoAlertDialog(
                    title: const Text('Change Password'),
                    content: Column(
                      children: [
                        const SizedBox(height: 8),
                        CupertinoTextField(
                          controller: currentPasswordController,
                          placeholder: 'Current password',
                          obscureText: true,
                          enabled: !loading,
                        ),
                        const SizedBox(height: 8),
                        CupertinoTextField(
                          controller: newPasswordController,
                          placeholder: 'New password',
                          obscureText: true,
                          enabled: !loading,
                        ),
                        const SizedBox(height: 8),
                        CupertinoTextField(
                          controller: confirmPasswordController,
                          placeholder: 'Confirm new password',
                          obscureText: true,
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
                                  final currentPassword =
                                      currentPasswordController.text.trim();
                                  final newPassword =
                                      newPasswordController.text.trim();
                                  final confirmPassword =
                                      confirmPasswordController.text.trim();

                                  if (newPassword != confirmPassword) {
                                    setState(() {
                                      error = 'Passwords do not match';
                                      loading = false;
                                    });
                                    return;
                                  }
                                  if (newPassword.length < 6) {
                                    setState(() {
                                      error =
                                          'Password must be at least 6 characters';
                                      loading = false;
                                    });
                                    return;
                                  }
                                  try {
                                    // Re-authenticate user
                                    final cred = EmailAuthProvider.credential(
                                      email: user.email!,
                                      password: currentPassword,
                                    );
                                    await user.reauthenticateWithCredential(
                                      cred,
                                    );
                                    await user.updatePassword(newPassword);
                                    if (context.mounted) {
                                      Navigator.of(context).pop(true);
                                    }
                                  } on FirebaseAuthException catch (e) {
                                    setState(() {
                                      if (e.code == 'wrong-password') {
                                        error = 'Current password is incorrect';
                                      } else {
                                        error = 'Failed to update password';
                                      }
                                      loading = false;
                                    });
                                  } catch (e) {
                                    setState(() {
                                      error = 'Failed to update password';
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

        currentPasswordController.dispose();
        newPasswordController.dispose();
        confirmPasswordController.dispose();

        if (hasChanged == true && context.mounted) {
          showToastNotification(
            context,
            'Password changed successfully',
            type: ToastificationType.success,
          );
        }
      },
      title: const Text(
        'Change Password',
        style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
      ),

      leading: HugeIcon(
        icon: HugeIcons.strokeRoundedSquareLock02,
        color: primaryColor,
      ),
    );
  }
}
