import 'dart:developer';

import 'package:checklist/ui/shared/custom_text_form_field.dart';
import 'package:checklist/ui/shared/text_themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

class DateAndTimeSection extends StatelessWidget {
  const DateAndTimeSection({
    super.key,
    required this.dateNotifier,
    required this.timeNotifier,
  });
  final ValueNotifier<DateTime> dateNotifier;
  final ValueNotifier<DateTime> timeNotifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Date and Time', textAlign: TextAlign.left),
        const SizedBox(height: 20),
        ValueListenableBuilder<DateTime>(
          valueListenable: dateNotifier,
          builder: (context, value, child) {
            return GestureDetector(
              onTap: () async {
                DateTime tempDate = value;

                bool? shouldCancel = await showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: 270,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.date,
                              initialDateTime: value,
                              onDateTimeChanged: (DateTime newDate) {
                                tempDate = DateTime(
                                  newDate.year,
                                  newDate.month,
                                  newDate.day,
                                  value.hour,
                                  value.minute,
                                );
                              },
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    );
                  },
                );

                if (shouldCancel != true) dateNotifier.value = tempDate;
              },
              child: CustomTextFormField(
                enabled: false,
                labelText: DateFormat.yMMMEd().format(value),
                labelStyle: bodyMedium(context).copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                suffixIcon: HugeIcon(
                  icon: HugeIcons.strokeRoundedCalendar03,
                  color: Colors.grey,
                ),
                validator: (value) {
                  try {
                    DateTime dateTime = DateTime(
                      dateNotifier.value.year,
                      dateNotifier.value.month,
                      dateNotifier.value.day,
                      timeNotifier.value.hour,
                      timeNotifier.value.minute,
                      timeNotifier.value.second,
                      timeNotifier.value.millisecond,
                      timeNotifier.value.microsecond,
                    );

                    if (dateTime.isBefore(DateTime.now())) {
                      return 'Please enter a valid date and time';
                    }

                    return null;
                  } catch (e) {
                    log('error: $e');
                    log('date: $value');
                    return 'Cannot use selected date';
                  }
                },
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        ValueListenableBuilder<DateTime>(
          valueListenable: timeNotifier,
          builder: (context, value, child) {
            return GestureDetector(
              onTap: () async {
                DateTime tempTime = value;

                bool? shouldCancel = await showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: 300 - 30,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.time,
                              initialDateTime: value,
                              use24hFormat: false,
                              onDateTimeChanged: (DateTime newTime) {
                                tempTime = DateTime(
                                  value.year,
                                  value.month,
                                  value.day,
                                  newTime.hour,
                                  newTime.minute,
                                );
                              },
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(height: 50 - 30),
                        ],
                      ),
                    );
                  },
                );

                if (shouldCancel != true) timeNotifier.value = tempTime;
              },
              child: CustomTextFormField(
                enabled: false,
                labelText: DateFormat.jm().format(value),
                labelStyle: bodyMedium(context).copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                suffixIcon: HugeIcon(
                  icon: HugeIcons.strokeRoundedClock01,
                  color: Colors.grey,
                ),
                validator: (value) {
                  try {
                    DateTime dateTime = DateTime(
                      dateNotifier.value.year,
                      dateNotifier.value.month,
                      dateNotifier.value.day,
                      timeNotifier.value.hour,
                      timeNotifier.value.minute,
                      timeNotifier.value.second,
                      timeNotifier.value.millisecond,
                      timeNotifier.value.microsecond,
                    );

                    if (dateTime.isBefore(DateTime.now())) {
                      return 'Please enter a valid date and time';
                    }

                    return null;
                  } catch (e) {
                    log('error: $e');
                    log('date: $value');
                    return 'Cannot use selected date';
                  }
                },
              ),
            );
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
