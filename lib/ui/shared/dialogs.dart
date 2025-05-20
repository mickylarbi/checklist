import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

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

ToastificationItem showToastNotification(
  BuildContext context,
  String titleText, {
  ToastificationType? type,
}) {
  return toastification.show(
    context: context,
    title: Text(titleText, style: const TextStyle(fontWeight: FontWeight.w600)),

    foregroundColor: Theme.of(context).colorScheme.onSurface,
    autoCloseDuration: const Duration(seconds: 3),
    showProgressBar: false,
    style: ToastificationStyle.fillColored,
    type: type ?? ToastificationType.info,
    // primaryColor: colorFromToastificationType(type ?? ToastificationType.info),
    alignment: Alignment.bottomCenter,
    // backgroundColor: themePrimaryColorFromContext(context).withOpacity(.5),
  );
}
