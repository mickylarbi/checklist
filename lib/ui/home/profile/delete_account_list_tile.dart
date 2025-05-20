import 'package:checklist/ui/shared/dialogs.dart';
import 'package:checklist/ui/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:toastification/toastification.dart';

class DeleteAccountListTile extends StatefulWidget {
  const DeleteAccountListTile({super.key});

  @override
  State<DeleteAccountListTile> createState() => _DeleteAccountListTileState();
}

class _DeleteAccountListTileState extends State<DeleteAccountListTile> {
  User get user => FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        final passwordController = TextEditingController();
        bool? deleted = await showCupertinoDialog(
          context: context,
          builder: (context) {
            bool loading = false;
            String? error;

            return StatefulBuilder(
              builder:
                  (context, setState) => CupertinoAlertDialog(
                    title: const Text('Delete Account'),
                    content: Column(
                      children: [
                        const SizedBox(height: 8),
                        CupertinoTextField(
                          controller: passwordController,
                          placeholder: 'Enter your password',
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
                        isDestructiveAction: true,
                        onPressed:
                            loading
                                ? null
                                : () async {
                                  setState(() {
                                    loading = true;
                                    error = null;
                                  });
                                  final password =
                                      passwordController.text.trim();
                                  try {
                                    // Re-authenticate user
                                    final cred = EmailAuthProvider.credential(
                                      email: user.email!,
                                      password: password,
                                    );
                                    await user.reauthenticateWithCredential(
                                      cred,
                                    );
                                    await user.delete();
                                    if (context.mounted) {
                                      Navigator.of(context).pop(true);
                                    }
                                  } on FirebaseAuthException catch (e) {
                                    setState(() {
                                      if (e.code == 'wrong-password') {
                                        error = 'Password is incorrect';
                                      } else {
                                        error = 'Failed to delete account';
                                      }
                                      loading = false;
                                    });
                                  } catch (e) {
                                    setState(() {
                                      error = 'Failed to delete account';
                                      loading = false;
                                    });
                                  }
                                },
                        child:
                            loading
                                ? const CupertinoActivityIndicator()
                                : const Text('Delete'),
                      ),
                    ],
                  ),
            );
          },
        );

        passwordController.dispose();

        if (deleted == true && context.mounted) {
          showToastNotification(
            context,
            'Account deleted successfully',
            type: ToastificationType.success,
          );

          // Optionally, navigate to login or onboarding screen
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SplashScreen()),
            (route) => false,
          );
        }
      },
      title: const Text(
        'Delete Account',
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
      ),
      leading: HugeIcon(
        icon: HugeIcons.strokeRoundedUserRemove02,
        color: Colors.red,
      ),
    );
  }
}
