import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:checklist/ui/home/profile/profile_screen.dart';

class ProfileImage extends StatefulWidget {
  const ProfileImage({super.key});

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
      },
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.grey,
        child: HugeIcon(
          icon: HugeIcons.strokeRoundedUser,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
