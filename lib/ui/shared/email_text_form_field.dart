import 'package:checklist/ui/shared/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class EmailTextFormField extends StatelessWidget {
  const EmailTextFormField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      labelText: 'Email',
      prefixIcon: HugeIcon(
        icon: HugeIcons.strokeRoundedMail01,
        color: Colors.grey,
        size: 16,
      ),
    );
  }
}
