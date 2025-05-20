
import 'package:checklist/business_logic/cubits/task/task_cubit.dart';
import 'package:checklist/ui/home/menu_icon_button.dart';
import 'package:checklist/ui/home/profile_image.dart';
import 'package:checklist/ui/home/task_details/task_details_screen.dart';
import 'package:checklist/ui/home/task_list_view.dart';
import 'package:checklist/ui/shared/text_themes.dart';
import 'package:checklist/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TaskCubit taskCubit = context.read<TaskCubit>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leadingWidth: MediaQuery.of(context).size.width * .7,
        leading: Row(
          children: [
            SizedBox(width: 24),
            Text(
              'Checklist',
              style: titleLarge(
                context,
              ).copyWith(color: primaryColor, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 10),
            Image.asset('assets/images/logo.png', height: 24, width: 24),
          ],
        ),
        actions: [ProfileImage(), MenuIconButton(), SizedBox(width: 10)],
      ),

      body: TaskListView(),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => BlocProvider.value(
                        value: taskCubit,
                        child: TaskDetailsScreen(),
                      ),
                ),
              );
            },
            backgroundColor: secondaryColor,
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedTaskAdd01,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.purple,
            heroTag: 'AI',
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedAiMagic,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}
