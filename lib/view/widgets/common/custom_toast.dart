import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomToast {
  static void show({
    required String message,
    bool? isSuccess, // null for neutral/loading state
    required IconData icon,
    Duration? duration,
  }) {
    Color backgroundColor;
    Color iconColor;

    if (isSuccess == null) {
      // Neutral/loading state
      backgroundColor = const Color(0xFF2196F3);
      iconColor = Colors.white;
    } else if (isSuccess) {
      // Success state
      backgroundColor = const Color(0xFF4CAF50);
      iconColor = Colors.white;
    } else {
      // Error state
      backgroundColor = const Color(0xFFF44336);
      iconColor = Colors.white;
    }

    Get.snackbar(
      '',
      '',
      titleText: Container(),
      messageText: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: duration ?? Duration(seconds: isSuccess == null ? 2 : 3),
      animationDuration: const Duration(milliseconds: 300),
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
    );
  }

  // Convenience methods for common toast types
  static void showSuccess(String message, {Duration? duration}) {
    show(
      message: message,
      isSuccess: true,
      icon: Icons.check_circle,
      duration: duration,
    );
  }

  static void showError(String message, {Duration? duration}) {
    show(
      message: message,
      isSuccess: false,
      icon: Icons.error,
      duration: duration,
    );
  }

  static void showWarning(String message, {Duration? duration}) {
    show(
      message: message,
      isSuccess: false,
      icon: Icons.warning,
      duration: duration,
    );
  }

  static void showInfo(String message, {Duration? duration}) {
    show(
      message: message,
      isSuccess: null,
      icon: Icons.info,
      duration: duration,
    );
  }

  static void showLoading(String message, {Duration? duration}) {
    show(
      message: message,
      isSuccess: null,
      icon: Icons.hourglass_empty,
      duration: duration,
    );
  }
}
