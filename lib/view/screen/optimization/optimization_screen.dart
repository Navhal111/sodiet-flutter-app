import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/controller/optimization/optimization_controller.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/view/widgets/layouts/base_screen_layout.dart';
import 'package:sodiet/view/widgets/common/title_section_widget.dart';
import 'package:sodiet/view/widgets/common/shimmer_loading.dart';
import 'package:sodiet/route/app_routes.dart';

class OptimizationScreen extends StatefulWidget {
  const OptimizationScreen({Key? key}) : super(key: key);

  @override
  State<OptimizationScreen> createState() => _OptimizationScreenState();
}

class _OptimizationScreenState extends State<OptimizationScreen> {
  bool isSnackSelected = true;
  bool isNonVegSelected = true;
  late OptimizationController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<OptimizationController>();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      currentRoute: AppRoutes.optimizationScreen,
      child: RefreshIndicator(
        onRefresh: () async {
          await controller.refreshData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Section
              TitleSectionWidget(
                imagePath: 'assets/images/plan.png',
                title: 'Optimization Status',
                description:
                    'View and manage your weekly optimization plans to track your progress and stay on top of your diet and fitness goals.',
              ),

              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Filter Options
                    Row(
                      children: [
                        _buildFilterOption(
                          'Snack',
                          isSnackSelected,
                          () {
                            setState(() {
                              isSnackSelected = !isSnackSelected;
                            });
                          },
                        ),
                        const SizedBox(width: 16),
                        _buildFilterOption(
                          'Non-Veg',
                          isNonVegSelected,
                          () {
                            setState(() {
                              isNonVegSelected = !isNonVegSelected;
                            });
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Run All Button
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to meal plan screen with default view mode
                          Get.toNamed(AppRoutes.mealPlanScreen, arguments: {
                            'mode':
                                'view', // Default to view mode - no close icon
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2AB989),
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            SemiBoldText(
                              'Run all',
                              fontSize: 16,
                              textColor: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 4),

              // Optimization Cards - Dynamic List
              Obx(() {
                if (controller.isLoading.value) {
                  return Column(
                    children: List.generate(
                      3,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: ShimmerLoading(
                            width: double.infinity,
                            height: 120,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                if (controller.weekPlanData.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(32),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        SemiBoldText(
                          'No optimization data available',
                          fontSize: 16,
                          textColor: Colors.grey.shade600,
                        ),
                        const SizedBox(height: 8),
                        RegularText(
                          'Pull to refresh to check for new data',
                          fontSize: 14,
                          textColor: Colors.grey.shade500,
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: controller.weekPlanData.map((weekPlan) {
                    final colors =
                        controller.getStatusColors(weekPlan.optStatus);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: _buildOptimizationCard(
                        'Week ${weekPlan.week}',
                        weekPlan.dateRange,
                        weekPlan.optStatus,
                        weekPlan.lastRunDate,
                        colors[0] as Color, // Background color
                        colors[1] as Color, // Text color
                        colors[2] as List<Color>, // Action colors
                        weekPlan.week, // Pass week number for navigation
                      ),
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterOption(String title, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade400,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: isSelected
                ? const Icon(
                    Icons.check,
                    size: 14,
                    color: Colors.white,
                  )
                : null,
          ),
          const SizedBox(width: 8),
          RegularText(
            title,
            fontSize: 14,
            textColor: Colors.grey.shade700,
          ),
        ],
      ),
    );
  }

  Widget _buildOptimizationCard(
    String week,
    String dateRange,
    String status,
    String lastRunDate,
    Color backgroundColor,
    Color statusColor,
    List<Color> actionColors,
    int weekNumber,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SemiBoldText(
                week,
                fontSize: 16,
                textColor: statusColor,
              ),
              SemiBoldText(
                dateRange,
                fontSize: 14,
                textColor: statusColor,
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Status
          SemiBoldText(
            status,
            fontSize: 24,
            textColor: statusColor,
          ),

          const SizedBox(height: 16),

          // Last Run Date and Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RegularText(
                    'Last run date',
                    fontSize: 12,
                    textColor: Colors.grey.shade600,
                  ),
                  const SizedBox(height: 2),
                  SemiBoldText(
                    lastRunDate,
                    fontSize: 14,
                    textColor: statusColor,
                  ),
                ],
              ),

              // Action Buttons
              Row(
                children: [
                  _buildActionButton(
                    Icons.play_arrow,
                    actionColors[0],
                    () {
                      // Handle play/run action
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildActionButton(
                    Icons.visibility,
                    actionColors[1],
                    () {
                      // Clear old data and navigate immediately
                      controller.weeklyMenuList.clear();
                      controller.currentWeekNo.value = weekNumber;

                      // Navigate immediately with view mode
                      Get.toNamed(AppRoutes.mealPlanScreen, arguments: {
                        'week_no': weekNumber,
                        'mode': 'view', // View mode - no close icon
                      });

                      // Load data after navigation
                      controller.getWeeklyMenu(weekNumber);
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildActionButton(
                    Icons.settings,
                    actionColors[2],
                    () {
                      // Clear old data and navigate immediately
                      controller.weeklyMenuList.clear();
                      controller.currentWeekNo.value = weekNumber;

                      // Navigate to meal plan with edit mode
                      Get.toNamed(AppRoutes.mealPlanScreen, arguments: {
                        'week_no': weekNumber,
                        'mode': 'edit', // Edit mode - show close icon
                      });

                      // Load data after navigation
                      controller.getWeeklyMenu(weekNumber);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, Color color, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }
}
