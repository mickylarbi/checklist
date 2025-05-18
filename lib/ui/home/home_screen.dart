import 'package:checklist/ui/home/filter/filter_row.dart';
import 'package:checklist/ui/home/task_details/task_details_screen.dart';
import 'package:checklist/ui/shared/text_themes.dart';
import 'package:checklist/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        actions: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey,
            child: Text(
              'M',
              style: titleMedium(
                context,
              ).copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          SizedBox(width: 24),
        ],
      ),
      body: Column(
        children: [
          FilterRow(),
          Divider(height: 0),
          Expanded(
            child: ListView.separated(
              itemCount: 20,
              separatorBuilder: (BuildContext context, int index) {
                return Divider(height: 0);
              },
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Buy groceries',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Pick up milk, eggs, bread, fruit and snacks',
                        style: bodySmall(context).copyWith(color: Colors.grey),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            '${DateFormat.MMMEd().format(DateTime.now())} at ${DateFormat.jm().format(DateTime.now())}',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedTimeHalfPass,
                            color: secondaryColor,
                            size: 16,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'In Progress',
                            style: TextStyle(
                              color: secondaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskDetailsScreen()),
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
