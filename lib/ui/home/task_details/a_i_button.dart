import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class AIButton extends StatelessWidget {
  const AIButton({super.key, this.onLongPress, this.onPressed});

  final void Function()? onPressed;
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: FilledButton.icon(
        onPressed: onPressed,
        onLongPress: onLongPress,
        style: FilledButton.styleFrom(
          backgroundColor: Colors.purple.withAlpha(40),
          foregroundColor: Colors.purple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: HugeIcon(
          icon: HugeIcons.strokeRoundedAiMagic,
          color: Colors.purple,
        ),
        label: Text('AI Assist', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}
