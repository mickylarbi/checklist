import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:checklist/ui/home/profile/profile_screen.dart';

class ProfileImage extends StatefulWidget {
  const ProfileImage({super.key});

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  User get user => FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(imageSetState: setState),
          ),
        );
      },
      child: CircleAvatar(
        radius: 20,
        backgroundColor: user.photoURL == null ? Colors.grey : null,
        backgroundImage:
            user.photoURL == null ? null : NetworkImage(user.photoURL!,),
        child:
            user.photoURL == null
                ? HugeIcon(
                  icon: HugeIcons.strokeRoundedUser,
                  color: Colors.white,
                  size: 20,
                )
                : null,
      ),
    );
  }
}
