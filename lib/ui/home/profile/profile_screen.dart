import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) return Center(child: Text('user not found'));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, title: Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 40),
        children: [CircleAvatar(radius: 100), NameListTile(user: user)],
      ),
    );
  }
}

class NameListTile extends StatefulWidget {
  const NameListTile({super.key, required this.user});

  final User? user;

  @override
  State<NameListTile> createState() => _NameListTileState();
}

class _NameListTileState extends State<NameListTile> {
  bool editMode = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      // Opacity(
      //   opacity: editMode ? 1 : 0,
      //   child: CustomTextFormField(
      //     labelText: 'Name',
      //     enabled: editMode,
      //     onFieldSubmitted: (value) {
      //       editMode = false;
      //       setState(() {});
      //     },
      //   ),
      // ),
      ListTile(
        onTap: () {
          editMode = true;
          setState(() {});
        },
        title: Text(FirebaseAuth.instance.currentUser?.displayName ?? '-'),
        subtitle: const Text('Name'),
        subtitleTextStyle: GoogleFonts.montserratTextTheme().bodyMedium
            ?.copyWith(color: Colors.grey),
        trailing: HugeIcon(
          icon: HugeIcons.strokeRoundedEdit02,
          color: Colors.grey,
        ),
      ),
    ];

    return Stack(
      alignment: Alignment.center,
      children: editMode ? children : children.reversed.toList(),
    );
  }
}
