import 'package:flutter/material.dart';
import 'package:sodiet/view/widgets/app_text.dart';

void showCustomSnackBar(String message, BuildContext context,
    {bool isError = true}) {
  if (message != null && message.isNotEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      dismissDirection: DismissDirection.horizontal,
      margin: EdgeInsets.all(12),
      duration: Duration(seconds: 3),
      backgroundColor: isError ? Colors.redAccent : Colors.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: Colors.black26)),
      content: SemiBoldText(
        message,
        textColor: Colors.white,
      ),
    ));
  }
}
