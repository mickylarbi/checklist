import 'package:checklist/ui/shared/text_themes.dart';
import 'package:checklist/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.labelText,
    this.controller,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.minLines,
    this.enabled,
  });

  final String labelText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final int? minLines;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
      validator: validator,
      obscureText: obscureText,
      minLines: minLines,
      maxLines: minLines,
      enabled: enabled,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.teal),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Color(0xFFC1C1C1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Color(0xFFC1C1C1)),
        ),

        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        labelText: labelText,
        alignLabelWithHint: true,
        labelStyle: bodyMedium(context).copyWith(color: Colors.grey),
        floatingLabelStyle: labelMedium(
          context,
        ).copyWith(color: primaryColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}
