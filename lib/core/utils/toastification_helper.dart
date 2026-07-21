import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastificationHelper {
  static void showSuccess(BuildContext context, String message) {
    toastification.dismissAll();
    toastification.show(
      context: context,
      title: Text(message),
      type: ToastificationType.success,
      style: ToastificationStyle.minimal,
      autoCloseDuration: const Duration(seconds: 3),
      alignment: Alignment.topCenter,
    );
  }

  static void showError(BuildContext context, String message) {
    toastification.dismissAll();
    toastification.show(
      context: context,
      title: Text(message),
      type: ToastificationType.error,
      style: ToastificationStyle.minimal,
      autoCloseDuration: const Duration(seconds: 3),
      alignment: Alignment.topCenter,
    );
  }

  static void showWarning(BuildContext context, String message) {
    toastification.dismissAll();
    toastification.show(
      context: context,
      title: Text(message),
      type: ToastificationType.warning,
      style: ToastificationStyle.minimal,
      autoCloseDuration: const Duration(seconds: 3),
      alignment: Alignment.topCenter,
    );
  }

  static void showInfo(BuildContext context, String message) {
    toastification.dismissAll();
    toastification.show(
      context: context,
      title: Text(message),
      type: ToastificationType.info,
      style: ToastificationStyle.minimal,
      autoCloseDuration: const Duration(seconds: 3),
      alignment: Alignment.topCenter,
    );
  }
}
