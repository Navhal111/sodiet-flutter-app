import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sodiet/controller/navigation/navigation_controller.dart';
import 'package:sodiet/view/widgets/header/app_header.dart';
import 'package:sodiet/view/widgets/home/home_drawer.dart';

class BaseScreenLayout extends StatelessWidget {
  final Widget child;
  final String currentRoute;
  final String? title;
  final bool showBackButton;
  final Function? onBackTap;
  final bool hasDrawer;

  const BaseScreenLayout({
    Key? key,
    required this.child,
    required this.currentRoute,
    this.title,
    this.showBackButton = false,
    this.onBackTap,
    this.hasDrawer = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    // Update the current route in navigation controller immediately
    try {
      Get.find<NavigationController>().updateCurrentRoute(currentRoute);
    } catch (e) {
      // NavigationController might not be initialized yet
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        // Handle custom back button logic if provided
        if (onBackTap != null) {
          onBackTap!();
          return;
        }

        // Default back button handling
        await _handleBackButton(context);
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).cardColor,
        drawer: hasDrawer ? const HomeDrawer() : null,
        body: SafeArea(
          child: Column(
            children: [
              // App Header
              AppHeader(
                onMenuTap: hasDrawer
                    ? () => scaffoldKey.currentState?.openDrawer()
                    : null,
                onNotificationTap: _handleNotificationTap,
                onProfileTap: _handleProfileTap,
                showBackButton: showBackButton,
                title: title,
                onBackTap: onBackTap,
              ),

              // Screen content
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleBackButton(BuildContext context) async {
    // If already on home screen, show exit confirmation
    if (currentRoute == '/home_screen') {
      _showExitConfirmationDialog(context);
    } else {
      // Navigate to home screen
      Get.offAllNamed('/home_screen');
    }
  }

  void _showExitConfirmationDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Do you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Close the app
              SystemNavigator.pop();
            },
            child: const Text('Exit'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _handleNotificationTap() {
    // TODO: Implement notification screen navigation
    Get.snackbar(
      'Notifications',
      'Notifications feature will be implemented soon',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.primaryColor,
      colorText: Colors.white,
    );
  }

  void _handleProfileTap() {
    // TODO: Implement profile screen navigation
    Get.snackbar(
      'Profile',
      'Profile feature will be implemented soon',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.primaryColor,
      colorText: Colors.white,
    );
  }
}
