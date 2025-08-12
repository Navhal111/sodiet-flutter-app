import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/controller/physicalActivity/physicalController.dart';
import 'package:sodiet/view/widgets/common/title_section_widget.dart';
import 'package:sodiet/view/widgets/layouts/base_screen_layout.dart';
import 'package:sodiet/view/widgets/app_text.dart';
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
  double estimatedCaloriesMale = 0.0;
  double estimatedCaloriesFemale = 0.0;

  // ValueNotifiers for smooth updates without rebuilding entire widget
  final ValueNotifier<double> durationNotifier = ValueNotifier<double>(5.0);
  final ValueNotifier<double> caloriesMaleNotifier = ValueNotifier<double>(0.0);
  final ValueNotifier<double> caloriesFemaleNotifier =
      ValueNotifier<double>(0.0);

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
    caloriesMaleNotifier.dispose();
    caloriesFemaleNotifier.dispose();
    super.dispose();
  }

  double _getMaleCaloriesPerMinute(String activityName) {
    final activity = physicalActivityController.activitiesList
        .firstWhereOrNull((activity) => activity.paName == activityName);
    return activity?.maleValue ?? 5.0;
  }

  double _getFemaleCaloriesPerMinute(String activityName) {
    final activity = physicalActivityController.activitiesList
        .firstWhereOrNull((activity) => activity.paName == activityName);
    return activity?.femaleValue ?? 5.0;
  }

  void _calculateCalories() {
    if (selectedActivity.isNotEmpty && duration > 0) {
      setState(() {
        estimatedCaloriesMale =
            _getMaleCaloriesPerMinute(selectedActivity) * duration;
        estimatedCaloriesFemale =
            _getFemaleCaloriesPerMinute(selectedActivity) * duration;
      });

      // Show success message
      Get.snackbar(
        'Calculated',
        'Estimated calories calculated for both genders',
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
                      return const SizedBox(
                        height: 100,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: Color(0xFF091242),
                              ),
                              SizedBox(height: 8),
                              Text('Loading activities...'),
                            ],
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
                              // Calculate calories for both genders when activity changes
                              if (duration > 0) {
                                estimatedCaloriesMale =
                                    _getMaleCaloriesPerMinute(activity.paName) *
                                        duration;
                                estimatedCaloriesFemale =
                                    _getFemaleCaloriesPerMinute(
                                            activity.paName) *
                                        duration;

                                // Update ValueNotifiers for smooth display
                                caloriesMaleNotifier.value =
                                    estimatedCaloriesMale;
                                caloriesFemaleNotifier.value =
                                    estimatedCaloriesFemale;
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
                                    caloriesMaleNotifier.value =
                                        _getMaleCaloriesPerMinute(
                                                selectedActivity) *
                                            value;
                                    caloriesFemaleNotifier.value =
                                        _getFemaleCaloriesPerMinute(
                                                selectedActivity) *
                                            value;
                                    estimatedCaloriesMale =
                                        caloriesMaleNotifier.value;
                                    estimatedCaloriesFemale =
                                        caloriesFemaleNotifier.value;
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

                  // Display both male and female calories with smooth updates
                  Row(
                    children: [
                      Expanded(
                        child: ValueListenableBuilder<double>(
                          valueListenable: caloriesMaleNotifier,
                          builder: (context, maleCalories, child) {
                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.blue.shade200),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SemiBoldText(
                                    'Male',
                                    fontSize: 14,
                                    textColor: Colors.blue.shade700,
                                  ),
                                  const SizedBox(height: 4),
                                  SemiBoldText(
                                    '${maleCalories.toStringAsFixed(1)} Kcal',
                                    fontSize: 16,
                                    textColor: const Color(0xFF091242),
                                  ),
                                  if (selectedActivity.isNotEmpty) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      '${_getMaleCaloriesPerMinute(selectedActivity).toStringAsFixed(1)} Kcal/min',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ValueListenableBuilder<double>(
                          valueListenable: caloriesFemaleNotifier,
                          builder: (context, femaleCalories, child) {
                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.pink.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.pink.shade200),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SemiBoldText(
                                    'Female',
                                    fontSize: 14,
                                    textColor: Colors.pink.shade700,
                                  ),
                                  const SizedBox(height: 4),
                                  SemiBoldText(
                                    '${femaleCalories.toStringAsFixed(1)} Kcal',
                                    fontSize: 16,
                                    textColor: const Color(0xFF091242),
                                  ),
                                  if (selectedActivity.isNotEmpty) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      '${_getFemaleCaloriesPerMinute(selectedActivity).toStringAsFixed(1)} Kcal/min',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Calculate Button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: _calculateCalories,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9800),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Calculate',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
