import 'package:checklist/ui/shared/custom_text_form_field.dart';
import 'package:checklist/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class EmailTextFormField extends StatelessWidget {
  const EmailTextFormField({super.key, this.controller});

  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: controller,
      labelText: 'Email',
      prefixIcon: HugeIcon(
        icon: HugeIcons.strokeRoundedMail01,
        color: Colors.grey,
        size: 16,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your email';
        }
        if (!emailRegex.hasMatch(value.trim().toLowerCase())) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }
}
