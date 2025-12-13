import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SnackbarType {
  success,
  warning,
  error,
}

class AppSnackbar {
  static void show(String message, SnackbarType type, {String? title}) {
    Color bgColor;
    IconData icon;

    switch (type) {
      case SnackbarType.success:
        bgColor = Colors.green.withOpacity(0.15);
        icon = Icons.check_circle_outline;
        title ??= "Success";
        break;

      case SnackbarType.warning:
        bgColor = Colors.orange.withOpacity(0.15);
        icon = Icons.warning_amber_rounded;
        title ??= "Warning";
        break;

      case SnackbarType.error:
        bgColor = Colors.red.withOpacity(0.15);
        icon = Icons.error_outline;
        title ??= "Error";
        break;
    }

    Get.snackbar(
      title,
      message,
      backgroundColor: bgColor,
      colorText: Colors.black,
      icon: Icon(icon, color: Colors.black54),
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }
}
