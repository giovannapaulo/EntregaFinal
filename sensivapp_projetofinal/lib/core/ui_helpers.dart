import 'package:flutter/material.dart';

class SensivSnackBar {
  static void show(BuildContext context, String message,
      {bool isError = true}) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style:
              const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
        ),
        backgroundColor:
            isError ? Colors.redAccent.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.fixed,
        duration: const Duration(milliseconds: 2000),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        elevation: 6,
      ),
    );
  }
}
