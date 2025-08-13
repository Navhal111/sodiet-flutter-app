import 'package:flutter/material.dart';
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

    return Scaffold(
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
