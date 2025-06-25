import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/model/weight_data.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/view/widgets/chart/weight_progress_chart.dart';
import 'package:sodiet/view/widgets/header/app_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Sample data for the weight progress chart - matching the design screenshot
  List<WeightData> sampleWeightData = [
    // Logged weight data (purple line) with some fluctuation
    WeightData(day: 1, loggedWeight: 1.0, plannedWeight: 100.0),
    WeightData(day: 3, loggedWeight: 0.79, plannedWeight: 99.5),
    WeightData(day: 5, loggedWeight: 0.5, plannedWeight: 99.0),
    WeightData(day: 6, loggedWeight: 0.77, plannedWeight: 98.5),
    WeightData(day: 7, loggedWeight: 0.6, plannedWeight: 98.0),
    WeightData(day: 8, loggedWeight: 0.9, plannedWeight: 97.5),

    // Planned weight data with steady decline (pink line)
    WeightData(day: 10, loggedWeight: -1, plannedWeight: 97.3),
    WeightData(day: 12, loggedWeight: -1, plannedWeight: 97.0),
    WeightData(day: 14, loggedWeight: -1, plannedWeight: 96.8),
    WeightData(day: 16, loggedWeight: -1, plannedWeight: 96.5),
    WeightData(day: 18, loggedWeight: -1, plannedWeight: 96.3),
    WeightData(day: 20, loggedWeight: -1, plannedWeight: 97.0),
    WeightData(day: 22, loggedWeight: -1, plannedWeight: 96.8),
    WeightData(day: 24, loggedWeight: -1, plannedWeight: 96.5),
    WeightData(day: 26, loggedWeight: -1, plannedWeight: 96.3),
    WeightData(day: 28, loggedWeight: -1, plannedWeight: 96.1),
    WeightData(day: 30, loggedWeight: -1, plannedWeight: 96.0),
  ];

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _handleNotificationTap() {
    // TODO: Implement notification screen navigation
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Notifications feature will be implemented soon'),
      backgroundColor: Theme.of(context).primaryColor,
    ));
  }

  void _handleProfileTap() {
    // TODO: Implement profile screen navigation
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Profile feature will be implemented soon'),
      backgroundColor: Theme.of(context).primaryColor,
    ));
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
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: WeightProgressChart(
                          weightDataList: sampleWeightData,
                          title: 'Plan Progress',
                          titleColor: const Color(
                              0xFF091242), // Dark blue from the design
                          titleFontSize: 22,
                          loggedWeightColor: const Color.fromRGBO(
                              48, 0, 129, 1), // Deep purple
                          plannedWeightColor:
                              const Color.fromRGBO(255, 99, 132, 1), // Pink
                          showRightAxisLabels: true,
                          minKcal: 0.0,
                          maxKcal: 1.0, // KCal scale 0.0-1.0
                          minWeight: 96.0,
                          maxWeight: 100.0, // Weight scale 96.0-100.0 kg
                        ),
                      ),

                      const SizedBox(height: 24),
                      // Additional content can be added here
                    ],
                  ),
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
