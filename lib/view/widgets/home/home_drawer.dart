import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavigationController>(
      builder: (navigationController) {
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
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      navigationController.isRouteActive(AppRoutes.homeScreen)
                          ? Colors.grey.shade100
                          : Colors.transparent,
                  border:
                      navigationController.isRouteActive(AppRoutes.homeScreen)
                          ? Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 2,
                            )
                          : null,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _buildDrawerItem(
                  context,
                  Icons.dashboard_outlined,
                  'Dashboard',
                  isSelected:
                      navigationController.isRouteActive(AppRoutes.homeScreen),
                  onTap: () => navigationController.navigateToHome(),
                ),
              ),
              // Menu items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildDrawerItem(
                      context,
                      Icons.assignment_outlined,
                      'Plan',
                      isSelected: navigationController
                          .isRouteActive(AppRoutes.planScreen),
                      onTap: () => navigationController.navigateToPlan(),
                    ),
                    // Recipes with submenu
                    _buildDrawerItem(
                      context,
                      Icons.restaurant_menu_outlined,
                      'Recipes',
                      hasDropdown: true,
                      isSelected: navigationController
                          .isRouteActive(AppRoutes.recipesScreen),
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
                        onTap: () =>
                            navigationController.navigateToAddRecipes(),
                      ),
                      _buildSubMenuItem(
                        context,
                        'New Ingredient',
                        onTap: () {
                          // TODO: Navigate to New Ingredient screen
                        },
                      ),
                    ],
                    _buildDrawerItem(
                      context,
                      Icons.tune_outlined,
                      'Diet Optimization',
                      isSelected: navigationController
                          .isRouteActive(AppRoutes.optimizationScreen),
                      onTap: () =>
                          navigationController.navigateToOptimization(),
                    ),
                    _buildDrawerItem(
                        context, Icons.history_outlined, 'Diet Recall',
                        isSelected: navigationController
                            .isRouteActive(AppRoutes.dietRecallScreen),
                        onTap: () =>
                            navigationController.navigateToDietRecall()),
                    _buildDrawerItem(context, Icons.trending_up_outlined,
                        'Weight Log Manager',
                        isSelected: navigationController
                            .isRouteActive(AppRoutes.weightLogManagerScreen),
                        onTap: () =>
                            navigationController.navigateToWeightLogManager()),
                    _buildDrawerItem(context, Icons.directions_run_outlined,
                        'Physical Activity',
                        isSelected: navigationController
                            .isRouteActive(AppRoutes.physicalActivityScreen),
                        onTap: () =>
                            navigationController.navigateToPhysicalActivity()),
                    _buildDrawerItem(context, Icons.event_note_outlined,
                        'Physical Activity Planner',
                        isSelected: navigationController.isRouteActive(
                            AppRoutes.physicalActivityPlannerScreen),
                        onTap: () => navigationController
                            .navigateToPhysicalActivityPlanner()),
                    _buildDrawerItem(
                      context,
                      Icons.auto_fix_high_outlined,
                      'Course Correction',
                      isSelected: navigationController
                          .isRouteActive(AppRoutes.courseCorrectionScreen),
                      onTap: () =>
                          navigationController.navigateToCoursesCorrection(),
                    ),
                    _buildDrawerItem(
                        context, Icons.calendar_today_outlined, 'Calendar'),
                    _buildDrawerItem(
                      context,
                      Icons.settings_outlined,
                      'Preferences',
                      isSelected: navigationController
                          .isRouteActive(AppRoutes.preferenceOnboardingScreen),
                      onTap: () => navigationController.navigateToPreferences(),
                    ),
                    _buildDrawerItem(
                        context, Icons.extension_outlined, 'Integrations',
                        isSelected: navigationController
                            .isRouteActive(AppRoutes.integrationsScreen),
                        onTap: () =>
                            navigationController.navigateToIntegrations()),
                    // _buildDrawerItem(context, Icons.help_outline, 'Help Desk'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
