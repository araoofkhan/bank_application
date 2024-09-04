import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
  static const String defaultLogoPath = 'lib/resources/banklogo/meezan.png'; // Default image path

  /// Displays a customizable toast message with optional image.
  static void showToast({
    required BuildContext context,
    required String message,
    String? imagePath = defaultLogoPath, // Optional image path with a default
    Color backgroundColor = Colors.white,
    Color textColor = Colors.black,
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) {
    // Cancel any existing toasts before showing a new one
    Fluttertoast.cancel();

    FToast fToast = FToast();
    fToast.init(context);

    // Create the custom toast widget
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: backgroundColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (imagePath != null) // Display image if provided
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Image.asset(
                imagePath,
                width: 30,
                height: 30,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error, color: textColor); // Fallback icon if image fails
                },
              ),
            ),
          Flexible(
            child: Text(
              message,
              style: TextStyle(color: textColor, fontSize: 16.0),
            ),
          ),
        ],
      ),
    );

    // Show the toast
    fToast.showToast(
      child: toast,
      gravity: gravity,
      toastDuration: const Duration(seconds: 3),
    );
  }
}
