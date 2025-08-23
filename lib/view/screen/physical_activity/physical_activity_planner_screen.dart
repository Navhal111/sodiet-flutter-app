import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/controller/physicalActivity/physicalController.dart';
import 'package:sodiet/view/widgets/common/title_section_widget.dart';
import 'package:sodiet/view/widgets/layouts/base_screen_layout.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/view/widgets/common/shimmer_loading.dart';
import 'package:sodiet/route/app_routes.dart';

class PhysicalActivityPlannerScreen extends StatefulWidget {
  const PhysicalActivityPlannerScreen({Key? key}) : super(key: key);

  @override
  State<PhysicalActivityPlannerScreen> createState() =>
      _PhysicalActivityPlannerScreenState();
}

class _PhysicalActivityPlannerScreenState
    extends State<PhysicalActivityPlannerScreen> {
  String selectedActivity = '';
  double duration = 5; // Duration in minutes (default 5 minutes)
  double estimatedCalories = 0.0;

  // ValueNotifiers for smooth updates without rebuilding entire widget
  final ValueNotifier<double> durationNotifier = ValueNotifier<double>(5.0);
  final ValueNotifier<double> caloriesNotifier = ValueNotifier<double>(0.0);

  final PhysicalActivityController physicalActivityController =
      Get.find<PhysicalActivityController>();

  @override
  void initState() {
    super.initState();
    // Load physical activities when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      physicalActivityController.getPhysicalActivitiesList();
    });
  }

  @override
  void dispose() {
    durationNotifier.dispose();
    caloriesNotifier.dispose();
    super.dispose();
  }

  double _getCaloriesPerMinute(String activityName) {
    final activity = physicalActivityController.activitiesList
        .firstWhereOrNull((activity) => activity.paName == activityName);
    return activity?.energyPerMin ?? 5.0;
  }

  void _calculateCalories() {
    if (selectedActivity.isNotEmpty && duration > 0) {
      setState(() {
        estimatedCalories = _getCaloriesPerMinute(selectedActivity) * duration;
      });

      // Show success message
      Get.snackbar(
        'Calculated',
        'Estimated calories calculated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF4CAF50),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    } else {
      // Show error message
      Get.snackbar(
        'Error',
        'Please select an activity and set duration',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFF44336),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      currentRoute: AppRoutes.physicalActivityPlannerScreen,
      title: 'Physical Activity Planner',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleSectionWidget(
              imagePath:
                  'assets/images/plan.png', // Using plan icon as placeholder
              title: 'Physical Activity Planner',
              description: 'Plan your daily physical activities',
              imageWidth: 60,
              imageHeight: 60,
            ),
            // Main Activity Planner Card
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Choose Activity Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SemiBoldText(
                        'Choose your Activity',
                        fontSize: 18,
                        textColor: Colors.black87,
                      ),
                      IconButton(
                        onPressed: () {
                          physicalActivityController
                              .getPhysicalActivitiesList();
                        },
                        icon: const Icon(
                          Icons.refresh,
                          color: Color(0xFF091242),
                        ),
                        tooltip: 'Refresh Activities',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Activity chips
                  Obx(() {
                    if (physicalActivityController.isLoadingActivities.value) {
                      return SizedBox(
                        height: 100,
                        child: Column(
                          children: List.generate(
                            3,
                            (index) => Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ShimmerLoading(
                                width: double.infinity,
                                height: 24,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    if (physicalActivityController.activitiesList.isEmpty) {
                      return const SizedBox(
                        height: 100,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.grey,
                                size: 32,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'No activities available',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: physicalActivityController.activitiesList
                          .map((activity) {
                        final isSelected = selectedActivity == activity.paName;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedActivity = activity.paName;
                              // Calculate calories when activity changes
                              if (duration > 0) {
                                estimatedCalories =
                                    _getCaloriesPerMinute(activity.paName) *
                                        duration;

                                // Update ValueNotifier for smooth display
                                caloriesNotifier.value = estimatedCalories;
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context)
                                      .primaryColorDark
                                      .withOpacity(0.2)
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(16),
                              border: isSelected
                                  ? Border.all(
                                      color: Theme.of(context).primaryColorDark,
                                      width: 2)
                                  : null,
                            ),
                            child: Text(
                              activity.paName,
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected
                                    ? const Color(0xFF091242)
                                    : Colors.grey.shade700,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }),

                  const SizedBox(height: 24),

                  // Duration Section
                  SemiBoldText(
                    'Duration in mins',
                    fontSize: 16,
                    textColor: Colors.black87,
                  ),
                  const SizedBox(height: 16),

                  // Slider Container with fixed width to prevent scrolling issues
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        ValueListenableBuilder<double>(
                          valueListenable: durationNotifier,
                          builder: (context, durationValue, child) {
                            return SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: Colors.green,
                                inactiveTrackColor: Colors.grey.shade300,
                                thumbColor: Colors.green,
                                overlayColor: Colors.green.withAlpha(32),
                                thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 12),
                                trackHeight: 4,
                              ),
                              child: Slider(
                                value: durationValue,
                                min: 5,
                                max: 120,
                                divisions:
                                    23, // (120-5)/5 = 23 divisions for 5-minute increments
                                label: '${durationValue.round()} mins',
                                onChanged: (value) {
                                  // Update duration smoothly without setState
                                  durationNotifier.value = value;
                                  duration = value;
                                  // Calculate calories smoothly
                                  if (selectedActivity.isNotEmpty) {
                                    caloriesNotifier.value =
                                        _getCaloriesPerMinute(
                                                selectedActivity) *
                                            value;
                                    estimatedCalories = caloriesNotifier.value;
                                  }
                                },
                              ),
                            );
                          },
                        ),
                        // Duration display with ValueListenableBuilder for smooth updates
                        ValueListenableBuilder<double>(
                          valueListenable: durationNotifier,
                          builder: (context, durationValue, child) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '5 mins',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  RegularText(
                                    'Duration: ${durationValue.round()} mins',
                                    fontSize: 14,
                                    textColor: const Color(0xFF091242),
                                  ),
                                  Text(
                                    '120 mins',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Estimated Calories Section
                  SemiBoldText(
                    'Estimated Calories Burn:',
                    fontSize: 16,
                    textColor: Colors.black87,
                  ),
                  const SizedBox(height: 8),

                  // Display single calorie value with smooth updates
                  ValueListenableBuilder<double>(
                    valueListenable: caloriesNotifier,
                    builder: (context, calories, child) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.local_fire_department,
                              color: Colors.orange.shade600,
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            SemiBoldText(
                              '${calories.toStringAsFixed(1)} Kcal',
                              fontSize: 20,
                              textColor: const Color(0xFF091242),
                            ),
                            const SizedBox(height: 4),
                            if (selectedActivity.isNotEmpty) ...[
                              Text(
                                '${_getCaloriesPerMinute(selectedActivity).toStringAsFixed(1)} Kcal/min',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
