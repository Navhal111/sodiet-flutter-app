import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/view/widgets/header/app_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _handleNotificationTap() {
    // TODO: Implement notification screen navigation
    Get.snackbar(
      'Notifications',
      'Notifications feature will be implemented soon',
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
      colorText: Theme.of(context).primaryColor,
    );
  }

  void _handleProfileTap() {
    // TODO: Implement profile screen navigation
    Get.snackbar(
      'Profile',
      'Profile feature will be implemented soon',
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
      colorText: Theme.of(context).primaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).cardColor,
      drawer: _buildDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            // App Header
            AppHeader(
              onMenuTap: _openDrawer,
              onNotificationTap: _handleNotificationTap,
              onProfileTap: _handleProfileTap,
            ),

            // Home content
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SemiBoldText(
                      'Welcome to SoDiet',
                      fontSize: 24,
                      textColor: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 16),
                    RegularText(
                      'Your health journey starts here',
                      fontSize: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    color: Theme.of(context).primaryColor,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 10),
                SemiBoldText(
                  'User Name',
                  textColor: Colors.white,
                  fontSize: 18,
                ),
                RegularText(
                  'user@example.com',
                  textColor: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.home, 'Home'),
          _buildDrawerItem(Icons.person, 'Profile'),
          _buildDrawerItem(Icons.settings, 'Settings'),
          _buildDrawerItem(Icons.info_outline, 'About'),
          const Divider(),
          _buildDrawerItem(Icons.logout, 'Logout', onTap: () {
            Get.back();
            // TODO: Implement logout functionality
            Get.offAllNamed('/login_screen');
          }),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, {Function? onTap}) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).primaryColor,
      ),
      title: RegularText(
        title,
        fontSize: 16,
      ),
      onTap: () {
        // Close drawer first
        Get.back();
        // Then perform action if provided
        if (onTap != null) {
          onTap();
        }
      },
    );
  }
}
