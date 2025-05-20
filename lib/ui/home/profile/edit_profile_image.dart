import 'dart:developer';

import 'package:checklist/ui/shared/dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toastification/toastification.dart';

class EditProfileImage extends StatefulWidget {
  const EditProfileImage({super.key, required this.imageSetState});
  final void Function(void Function()) imageSetState;

  @override
  State<EditProfileImage> createState() => _EditProfileImageState();
}

class _EditProfileImageState extends State<EditProfileImage> {
  User get user => FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final ImagePicker picker = ImagePicker();
        XFile? image = await showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return CupertinoActionSheet(
              title: const Text('Select Image'),
              actions: [
                CupertinoActionSheetAction(
                  child: const Text('Take Photo'),
                  onPressed: () async {
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.camera,
                    );
                    if (context.mounted) Navigator.pop(context, image);
                  },
                ),
                CupertinoActionSheetAction(
                  child: const Text('Choose from Gallery'),
                  onPressed: () async {
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (context.mounted) Navigator.pop(context, image);
                  },
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            );
          },
        );

        if (image != null) {
          final confirm = await showCupertinoDialog<bool>(
            context: context,
            builder:
                (context) => CupertinoAlertDialog(
                  title: const Text('Update Profile Photo'),
                  content: const Text(
                    'Are you sure you want to update your profile photo?',
                  ),
                  actions: [
                    CupertinoDialogAction(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    CupertinoDialogAction(
                      isDestructiveAction: true,
                      child: const Text('Update'),
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ],
                ),
          );

          if (confirm != true) return;

          log('image is not null');
          showToastNotification(context, 'Updating profile photo');

          final storageRef = FirebaseStorage.instance.ref().child(
            'profile_images/${user.uid}.jpg',
          );
          await storageRef.putData(await image.readAsBytes());
          final downloadUrl = await storageRef.getDownloadURL();
          await user.updatePhotoURL(downloadUrl);

          setState(() {
            widget.imageSetState(() {});
            showToastNotification(
              context,
              'Profile photo updated',
              type: ToastificationType.success,
            );
          });
        }
      },
      child: CircleAvatar(
        radius: 100,
        backgroundColor: user.photoURL == null ? Colors.grey : null,
        backgroundImage:
            user.photoURL == null ? null : NetworkImage(user.photoURL!),
        child:
            user.photoURL == null
                ? HugeIcon(
                  icon: HugeIcons.strokeRoundedUser,
                  color: Colors.white,
                  size: 100,
                )
                : null,
      ),
    );
  }
}
