import 'package:checklist/ui/home/task_details/a_i_button.dart';
import 'package:checklist/ui/shared/custom_text_form_field.dart';
import 'package:checklist/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:hugeicons/hugeicons.dart';

class DateAndTimeSection extends StatefulWidget {
  const DateAndTimeSection({super.key});

  @override
  State<DateAndTimeSection> createState() => _DateAndTimeSectionState();
}

class _DateAndTimeSectionState extends State<DateAndTimeSection> {
  final _controller = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      setState(() {
        if (_controller.value) {
          // _checked = true;
        } else {
          // _checked = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text('Date and Time'),
            Spacer(),
            AdvancedSwitch(
              controller: _controller,
              height: 20,
              width: 36,
              activeColor: secondaryColor,
            ),
          ],
        ),
        const SizedBox(height: 20),
        CustomTextFormField(
          labelText: 'Date',
          suffixIcon: HugeIcon(
            icon: HugeIcons.strokeRoundedCalendar03,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 20),
        CustomTextFormField(
          labelText: 'Time',
          suffixIcon: HugeIcon(
            icon: HugeIcons.strokeRoundedClock01,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 10),
        AIButton(),
      ],
    );
  }
}
