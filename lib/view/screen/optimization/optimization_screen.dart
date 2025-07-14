import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/view/widgets/header/app_header.dart';
import 'package:sodiet/view/widgets/common/title_section_widget.dart';
import 'package:sodiet/route/app_routes.dart';

class OptimizationScreen extends StatefulWidget {
  const OptimizationScreen({Key? key}) : super(key: key);

  @override
  State<OptimizationScreen> createState() => _OptimizationScreenState();
}

class _OptimizationScreenState extends State<OptimizationScreen> {
  bool isSnackSelected = true;
  bool isNonVegSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            AppHeader(
              onMenuTap: () => Scaffold.of(context).openDrawer(),
              onNotificationTap: () {},
              onProfileTap: () {},
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
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
                                // Navigate to meal plan screen
                                Get.toNamed(AppRoutes.mealPlanScreen);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2AB989),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
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

                    // Optimization Cards
                    _buildOptimizationCard(
                      'Week 1',
                      'Feb25 - Mar2',
                      'Optimal',
                      'Yesterday',
                      const Color(0xFFE8F5E8),
                      const Color(0xFF2E7D32),
                      [
                        const Color(0xFF4CAF50),
                        const Color(0xFF81C784),
                        const Color(0xFFA5D6A7),
                      ],
                    ),

                    const SizedBox(height: 4),

                    _buildOptimizationCard(
                      'Week 2',
                      'Mar13 - Mar 20',
                      'NA',
                      'Yesterday',
                      const Color(0xFFF5F5F5),
                      const Color(0xFF4C4C4C),
                      [
                        const Color(0xFFFFB74D),
                        const Color(0xFFFFCC02),
                        const Color(0xFFFFF176),
                      ],
                    ),

                    const SizedBox(height: 4),
                    _buildOptimizationCard(
                      'Week 1',
                      'Mar3 - Mar10',
                      'Error',
                      'Yesterday',
                      const Color(0xFFFFEBEE),
                      const Color(0xFFE53935),
                      [
                        const Color(0xFFE57373),
                        const Color(0xFFEF5350),
                        const Color(0xFFE53935),
                      ],
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
                  ),
                  const SizedBox(width: 8),
                  _buildActionButton(
                    Icons.visibility,
                    actionColors[1],
                  ),
                  const SizedBox(width: 8),
                  _buildActionButton(
                    Icons.settings,
                    actionColors[2],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, Color color) {
    return Container(
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
    );
  }
}
