import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/controller/auth/authController.dart';
import 'package:sodiet/controller/navigation/navigation_controller.dart';
import 'package:sodiet/route/app_routes.dart';
import 'package:sodiet/utils/images.dart';
import 'package:sodiet/view/widgets/app_text.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  bool isRecipesExpanded = false;
  late final NavigationController navigationController;

  @override
  void initState() {
    super.initState();
    navigationController = Get.find<NavigationController>();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      print(
          '===========================Check the values chnages in drawer ${navigationController.currentRoute}');
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
            // Dashboard item (highlighted based on current route)

            // Menu items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildDrawerItem(
                    context,
                    Icons.assignment_outlined,
                    'Dashboard',
                    isSelected: navigationController.currentRoute ==
                        AppRoutes.homeScreen,
                    onTap: () => {
                      navigationController.navigateToHome(),
                      setState(() {})
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.assignment_outlined,
                    'Plan',
                    isSelected: navigationController.currentRoute ==
                        AppRoutes.planScreen,
                    onTap: () => {
                      navigationController.navigateToPlan(),
                      setState(() {})
                    },
                  ),
                  // Recipes with submenu
                  _buildDrawerItem(
                    context,
                    Icons.restaurant_menu_outlined,
                    'Recipes',
                    hasDropdown: true,
                    isSelected: navigationController.currentRoute ==
                        AppRoutes.recipesScreen,
                    onTap: () {
                      setState(() {
                        isRecipesExpanded = !isRecipesExpanded;
                      });
                    },
                    isExpanded: isRecipesExpanded,
                  ),
                  // Recipes submenu
                  if (isRecipesExpanded) ...[
                    _buildSubMenuItem(
                      context,
                      'All Recipes',
                      onTap: () => navigationController.navigateToRecipes(),
                    ),
                    _buildSubMenuItem(
                      context,
                      'Custom Recipes',
                      onTap: () => navigationController.navigateToRecipes(),
                    ),
                    _buildSubMenuItem(
                      context,
                      'New Recipes',
                      onTap: () => navigationController.navigateToAddRecipes(),
                    ),
                    _buildSubMenuItem(
                      context,
                      'New Ingredient',
                      onTap: () =>
                          navigationController.navigateToAddIngredient(),
                    ),
                  ],
                  _buildDrawerItem(
                    context,
                    Icons.tune_outlined,
                    'Diet Optimization',
                    isSelected: navigationController.currentRoute ==
                        AppRoutes.optimizationScreen,
                    onTap: () => navigationController.navigateToOptimization(),
                  ),
                  _buildDrawerItem(
                      context, Icons.history_outlined, 'Diet Recall',
                      isSelected: navigationController.currentRoute ==
                          AppRoutes.dietRecallScreen,
                      onTap: () => navigationController.navigateToDietRecall()),
                  _buildDrawerItem(
                      context, Icons.trending_up_outlined, 'Weight Log Manager',
                      isSelected: navigationController.currentRoute ==
                          AppRoutes.weightLogManagerScreen,
                      onTap: () =>
                          navigationController.navigateToWeightLogManager()),
                  _buildDrawerItem(
                      context, Icons.trending_up_outlined, 'Fat Log Manager',
                      isSelected: navigationController.currentRoute ==
                          AppRoutes.fatLogManagerScreen,
                      onTap: () =>
                          navigationController.navigateToFatLogManager()),
                  _buildDrawerItem(context, Icons.directions_run_outlined,
                      'Physical Activity',
                      isSelected: navigationController.currentRoute ==
                          AppRoutes.physicalActivityScreen,
                      onTap: () =>
                          navigationController.navigateToPhysicalActivity()),
                  _buildDrawerItem(context, Icons.event_note_outlined,
                      'Physical Activity Planner',
                      isSelected: navigationController.currentRoute ==
                          AppRoutes.physicalActivityPlannerScreen,
                      onTap: () => navigationController
                          .navigateToPhysicalActivityPlanner()),
                  _buildDrawerItem(
                    context,
                    Icons.auto_fix_high_outlined,
                    'Course Correction',
                    isSelected: navigationController.currentRoute ==
                        AppRoutes.courseCorrectionScreen,
                    onTap: () =>
                        navigationController.navigateToCoursesCorrection(),
                  ),
                  _buildDrawerItem(
                      context, Icons.calendar_today_outlined, 'Calendar',
                      isSelected: navigationController.currentRoute ==
                          AppRoutes.calendarScreen,
                      onTap: () => navigationController.navigateToCalendar()),
                  _buildDrawerItem(
                    context,
                    Icons.settings_outlined,
                    'Preferences',
                    isSelected: navigationController.currentRoute ==
                        AppRoutes.preferenceOnboardingScreen,
                    onTap: () => navigationController.navigateToPreferences(),
                  ),
                  _buildDrawerItem(
                      context, Icons.extension_outlined, 'Integrations',
                      isSelected: navigationController.currentRoute ==
                          AppRoutes.integrationsScreen,
                      onTap: () =>
                          navigationController.navigateToIntegrations()),
                  // _buildDrawerItem(context, Icons.help_outline, 'Help Desk'),
                  const SizedBox(height: 20),
                  _buildDrawerItem(
                    context,
                    Icons.logout_outlined,
                    'Logout',
                    onTap: () => _showLogoutConfirmation(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  void _showLogoutConfirmation(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout from the app?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // Close dialog first
              final authController = Get.find<AuthController>();
              authController.logout(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF44336),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
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
    bool isExpanded = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? Colors.grey.shade100 : Colors.transparent,
        border: isSelected
            ? Border.all(
                color: Theme.of(context).primaryColor,
                width: 2,
              )
            : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
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
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: Colors.grey.shade600,
              )
            : null,
        onTap: () {
          if (hasDropdown) {
            // Don't close drawer for dropdown items
            if (onTap != null) {
              onTap();
            }
          } else {
            // Close drawer first
            Get.back();
            // Then perform action if provided
            if (onTap != null) {
              onTap();
            }
          }
        },
      ),
    );
  }

  Widget _buildSubMenuItem(
    BuildContext context,
    String title, {
    Function? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 32, right: 0, top: 2, bottom: 2),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        title: RegularText(
          title,
          fontSize: 14,
          textColor: Colors.black54,
        ),
        onTap: () {
          // Close drawer first
          Get.back();
          // Then perform action if provided
          if (onTap != null) {
            onTap();
          }
        },
      ),
    );
  }
}
