import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppRoute {
  static void navigateOffAll({
    required Widget pageName,
    int? duration,
    Transition? transition,
  }) {
    Get.offAll(
          () => pageName,
      duration: Duration(seconds: duration ?? 2),
      transition: transition ?? Transition.noTransition,
    );
  }

}
