import 'package:flutter/material.dart';

Future<T?> showCustomBottomSheet<T>({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
}) => showModalBottomSheet(
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
  ),
  backgroundColor: Colors.white,
  context: context,
  useRootNavigator: true,
  builder: builder,
  isScrollControlled: true,
);
