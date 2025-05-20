import 'package:checklist/ui/home/profile/change_password_list_tile.dart';
import 'package:checklist/ui/home/profile/delete_account_list_tile.dart';
import 'package:checklist/ui/home/profile/edit_email_list_tile.dart';
import 'package:checklist/ui/home/profile/edit_name_list_tile.dart';
import 'package:checklist/ui/home/profile/edit_profile_image.dart';
import 'package:checklist/ui/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.imageSetState});
  final void Function(void Function()) imageSetState;

  User get user => FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Profile'),
        actions: [LogoutIconButton()],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 40),
        children: [
          EditProfileImage(imageSetState: imageSetState,),
          SizedBox(height: 20),
          EditNameListTile(),
          EditEmailListTile(),
          ChangePasswordListTile(),
          DeleteAccountListTile(),
        ],
      ),
    );
  }
}

class LogoutIconButton extends StatelessWidget {
  const LogoutIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.logout),
      tooltip: 'Log out',
      onPressed: () async {
        final shouldLogout = await showCupertinoDialog<bool>(
          context: context,
          builder:
              (context) => CupertinoAlertDialog(
                title: const Text('Log out'),
                content: const Text('Are you sure you want to log out?'),
                actions: [
                  CupertinoDialogAction(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    child: const Text('Log out'),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ],
              ),
        );
        if (shouldLogout == true) {
          await FirebaseAuth.instance.signOut();
          if (context.mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => SplashScreen()),
              (route) => false,
            );
          }
        }
      },
    );
  }
}
