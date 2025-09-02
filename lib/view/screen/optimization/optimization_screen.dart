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
    controller.getWeekPlanMaster();
    controller.getRecipes(); // Load recipes on initialization
  }

  @override
  void dispose() {
    // Stop task monitoring when screen is disposed
    controller.stopTaskMonitoring();
    super.dispose();
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

                    // // Run All Button
                    // SizedBox(
                    //   width: 100,
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       // Navigate to meal plan screen with default view mode
                    //       Get.toNamed(AppRoutes.mealPlanScreen, arguments: {
                    //         'mode':
                    //             'view', // Default to view mode - no close icon
                    //       });
                    //     },
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: const Color(0xFF2AB989),
                    //       padding: const EdgeInsets.symmetric(vertical: 4),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(8),
                    //       ),
                    //     ),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         const Icon(
                    //           Icons.play_arrow,
                    //           color: Colors.white,
                    //           size: 20,
                    //         ),
                    //         const SizedBox(width: 8),
                    //         SemiBoldText(
                    //           'Run all',
                    //           fontSize: 16,
                    //           textColor: Colors.white,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
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
                        weekPlan, // Pass the entire weekPlan object
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

  // Function to handle play button click
  Future<void> _handlePlayButtonClick(
      int weekNumber, String startDate, String endDate) async {
    // Check if any task is already running
    if (controller.activeTaskWeek.value != 0) {
      // Show error message that another task is already running
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Task Already Running'),
            content: Text(
                'A task is already running for Week ${controller.activeTaskWeek.value}. Please wait for it to complete before starting a new task.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Clear any previous failed task progress for this week to allow retry
    final existingProgress = controller.getTaskProgressForWeek(weekNumber);
    if (existingProgress != null && existingProgress.isFailed) {
      controller.clearTaskProgressForWeek(weekNumber);
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Expanded(
                child: Text('Starting optimization for Week $weekNumber...'),
              ),
            ],
          ),
        );
      },
    );

    try {
      // Call the API
      final result = await controller.runModelDriver(
        weekNo: weekNumber,
        startDate: startDate,
        endDate: endDate,
        includeSnacks: isSnackSelected,
        includeNonVeg: isNonVegSelected,
      );

      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }

      // Small delay to ensure dialog is closed
      await Future.delayed(const Duration(milliseconds: 100));

      // Handle the result
      if (result['success'] == true) {
        // Don't show success dialog, just show a toast as monitoring will show progress
        // The progress will be visible in the card itself
        // CustomToast is already shown in the controller
      } else {
        // Show error message
        if (mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content:
                    Text(result['message'] ?? 'Failed to start optimization'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (e) {
      // Close loading dialog if it's open
      if (mounted) {
        Navigator.of(context).pop();
      }

      // Show error message
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text('An error occurred: $e'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
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
    WeekPlanData weekPlan,
  ) {
    return Obx(() {
      final taskProgress = controller.getTaskProgressForWeek(weekNumber);
      final isActiveTask = controller.isWeekTaskActive(weekNumber);

      // Determine background color based on task status
      Color cardBackgroundColor = backgroundColor;
      if (taskProgress != null) {
        if (taskProgress.isRunning && isActiveTask) {
          // Green with higher opacity for running
          cardBackgroundColor = Colors.green.withOpacity(0.3);
        } else if (taskProgress.isFailed) {
          // Red with higher opacity for error/failure
          cardBackgroundColor = Colors.red.withOpacity(0.3);
        } else if (taskProgress.isCompleted) {
          // Light green for success/completed status
          cardBackgroundColor = Colors.green.withOpacity(0.3);
        }
      } else {
        // Use original status colors if no task progress
        if (status.toLowerCase() == 'failed' ||
            status.toLowerCase() == 'failure' ||
            status.toLowerCase() == 'error') {
          cardBackgroundColor = Colors.red.withOpacity(0.3);
        }
      }

      return Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: cardBackgroundColor,
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

            // Status - Show task status if available, otherwise show original status
            Builder(
              builder: (context) {
                String displayStatus;
                Color displayStatusColor = statusColor;

                if (taskProgress != null) {
                  // Use task progress status and determine color
                  displayStatus = taskProgress.status;
                  if (taskProgress.isFailed) {
                    displayStatusColor = Colors.red.shade700;
                  } else if (taskProgress.isRunning) {
                    displayStatusColor = Colors.green.shade700;
                  } else if (taskProgress.isCompleted) {
                    displayStatusColor = Colors.green.shade700;
                  }
                } else {
                  // Use original status
                  displayStatus = status;
                  // Update color for failure status in original data too
                  if (status.toLowerCase() == 'failed' ||
                      status.toLowerCase() == 'failure' ||
                      status.toLowerCase() == 'error') {
                    displayStatusColor = Colors.red.shade700;
                  }
                }

                return SemiBoldText(
                  displayStatus,
                  fontSize: 24,
                  textColor: displayStatusColor,
                );
              },
            ),

            // Error message for failed tasks
            Builder(
              builder: (context) {
                if (taskProgress != null &&
                    taskProgress.isFailed &&
                    taskProgress.message.isNotEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                          border:
                              Border.all(color: Colors.red.withOpacity(0.3)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red.shade600,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: RegularText(
                                taskProgress.message,
                                fontSize: 12,
                                textColor: Colors.red.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            // Progress Bar (show only if task is active for this week)
            Builder(
              builder: (context) {
                if (taskProgress != null &&
                    (taskProgress.isRunning || isActiveTask)) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: Get.width - 120,
                            child: RegularText(
                              taskProgress.message,
                              fontSize: 12,
                              textColor: Colors.grey.shade600,
                              maxLines: 2,
                            ),
                          ),
                          RegularText(
                            '${taskProgress.current}/${taskProgress.total}',
                            fontSize: 12,
                            textColor: Colors.grey.shade600,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: taskProgress.progress / 100,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      RegularText(
                        '${taskProgress.progress.toInt()}% complete',
                        fontSize: 10,
                        textColor: Colors.grey.shade500,
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
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
                    Obx(() {
                      final taskProgress =
                          controller.getTaskProgressForWeek(weekNumber);
                      final isActiveTask =
                          controller.isWeekTaskActive(weekNumber);
                      final isTaskRunning = taskProgress != null &&
                          (taskProgress.isRunning || isActiveTask);

                      return _buildActionButton(
                        Icons.play_arrow,
                        actionColors[0],
                        isTaskRunning
                            ? null // Disable button when task is running for this week
                            : () {
                                // Handle play/run action
                                _handlePlayButtonClick(weekPlan.week,
                                    weekPlan.startDate, weekPlan.endDate);
                              },
                        isLoading: isTaskRunning,
                      );
                    }),
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
    });
  }

  Widget _buildActionButton(IconData icon, Color color, VoidCallback? onTap,
      {bool isLoading = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isLoading ? color.withOpacity(0.6) : color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: isLoading
            ? const SizedBox(
                width: 10,
                height: 10,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Icon(
                icon,
                color: Colors.white,
                size: 18,
              ),
      ),
    );
  }
}
