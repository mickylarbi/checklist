import 'package:checklist/ui/shared/custom_text_form_field.dart';
import 'package:checklist/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class PasswordTextFormField extends StatefulWidget {
  const PasswordTextFormField({super.key, this.controller});

  final TextEditingController? controller;

  @override
  State<PasswordTextFormField> createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: widget.controller,
      labelText: 'Password',
      obscureText: obscureText,
      prefixIcon: HugeIcon(
        icon: HugeIcons.strokeRoundedSquareLock01,
        color: Colors.grey,
        size: 16,
      ),
      suffixIcon: InkWell(
        onTap: () {
          obscureText = !obscureText;
          setState(() {});
        },
        child: HugeIcon(
          icon:
              obscureText
                  ? HugeIcons.strokeRoundedView
                  : HugeIcons.strokeRoundedViewOff,
          color: primaryColor,
          size: 20,
        ),
      ),
    );
  }
}
