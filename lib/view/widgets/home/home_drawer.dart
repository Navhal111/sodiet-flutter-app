import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/route/app_routes.dart';
import 'package:sodiet/utils/images.dart';
import 'package:sodiet/view/widgets/app_text.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          const SizedBox(
            height: 56,
          ),
          // Header with app logo and close button
          Center(
            child: Image.asset(
              MyImages.splashLogo,
              height: 50,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          // Dashboard item (highlighted)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _buildDrawerItem(
              context,
              Icons.dashboard_outlined,
              'Dashboard',
              isSelected: true,
            ),
          ),

          // Menu items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildDrawerItem(context, Icons.assignment_outlined, 'Plan',
                    onTap: () {
                  Get.toNamed(AppRoutes.planScreen);
                }),
                _buildDrawerItem(
                    context, Icons.restaurant_menu_outlined, 'Recipes',
                    hasDropdown: true, onTap: () {
                  Get.toNamed(AppRoutes.recipesScreen);
                }),
                _buildDrawerItem(
                    context, Icons.tune_outlined, 'Diet Optimization',
                    onTap: () {
                  Get.toNamed(AppRoutes.optimizationScreen);
                }),
                _buildDrawerItem(
                    context, Icons.history_outlined, 'Diet Recall'),
                _buildDrawerItem(
                    context, Icons.trending_up_outlined, 'Weight Log Manager'),
                _buildDrawerItem(context, Icons.directions_run_outlined,
                    'Physical Activity'),
                _buildDrawerItem(context, Icons.event_note_outlined,
                    'Physical Activity Planner'),
                _buildDrawerItem(
                    context, Icons.auto_fix_high_outlined, 'Course Correction'),
                _buildDrawerItem(
                    context, Icons.calendar_today_outlined, 'Calendar'),
                _buildDrawerItem(
                    context, Icons.settings_outlined, 'Preferences'),
                _buildDrawerItem(
                    context, Icons.extension_outlined, 'Integrations'),
                _buildDrawerItem(context, Icons.help_outline, 'Help Desk'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title, {
    Function? onTap,
    bool isSelected = false,
    bool hasDropdown = false,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
        size: 24,
      ),
      title: isSelected
          ? SemiBoldText(
              title,
              fontSize: 16,
              textColor: Colors.black,
            )
          : SemiBoldText(
              title,
              fontSize: 16,
              textColor: Colors.black87,
            ),
      trailing: hasDropdown
          ? Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey.shade600,
            )
          : null,
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
