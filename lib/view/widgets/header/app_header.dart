import 'package:flutter/material.dart';
import 'package:sodiet/utils/images.dart';

class AppHeader extends StatelessWidget {
  final Function? onMenuTap;
  final Function? onNotificationTap;
  final Function? onProfileTap;
  final bool showBackButton;
  final String? title;
  final Function? onBackTap;

  const AppHeader({
    Key? key,
    this.onMenuTap,
    this.onNotificationTap,
    this.onProfileTap,
    this.showBackButton = false,
    this.title,
    this.onBackTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Center - Logo (positioned in the center of the stack)
          Center(
            child: Image.asset(
              MyImages.splashLogo,
              height: 50,
              fit: BoxFit.contain,
            ),
          ),

          // Left and right elements in a Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side - Menu or Back button
              GestureDetector(
                onTap: () {
                  if (showBackButton) {
                    if (onBackTap != null) {
                      onBackTap!();
                    } else {
                      Navigator.pop(context);
                    }
                  } else if (onMenuTap != null) {
                    onMenuTap!();
                  }
                },
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  child: showBackButton
                      ? Icon(Icons.arrow_back, color: Colors.black54)
                      : Icon(Icons.menu, color: Colors.black54),
                ),
              ),

              // Right side - Actions
              Row(
                children: [
                  // Notification Bell
                  GestureDetector(
                    onTap: onNotificationTap as void Function()?,
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.notifications_outlined,
                        color: Theme.of(context).hintColor.withOpacity(0.4),
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Profile Icon
                  GestureDetector(
                    onTap: onProfileTap as void Function()?,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
