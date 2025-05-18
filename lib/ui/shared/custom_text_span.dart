import 'package:checklist/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomTextSpan extends StatelessWidget {
  const CustomTextSpan({
    super.key,
    required this.firstText,
    required this.secondText,
    required this.onActionPressed,
    this.style,
  });
  final String firstText;
  final String secondText;
  final VoidCallback onActionPressed;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      runAlignment: WrapAlignment.center,
      children: [
        Text(firstText, style: style),
        InkWell(
          onTap: onActionPressed,
          child: Text(
            secondText,
            style: (style ?? const TextStyle()).copyWith(
              color: primaryColor,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
              decorationColor: primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}