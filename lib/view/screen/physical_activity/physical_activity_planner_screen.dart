import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  double duration = 0; // Duration in minutes
  double estimatedCalories = 0.0;

  final List<String> activities = [
    'Batting',
    'Dancing',
    'Golf',
    'VolleyBall',
    'Tennis',
    'Running- Long distance',
    'Rowing',
    'Basketball',
    'Circuit Training',
    'Walking uphill',
    'Football',
    'Sailing',
    'Walking Around',
    'Walking Slowly',
    'Dancing',
    'Calisthenics',
    'Walking Quickly',
    'Batting',
    'Aerobic Dancing - Low intensity',
    'Climbing Stairs',
    'Cycling'
  ];

  // Calories per minute for different activities (approximate values)
  final Map<String, double> caloriesPerMinute = {
    'Batting': 4.5,
    'Dancing': 3.5,
    'Golf': 3.0,
    'VolleyBall': 6.0,
    'Tennis': 7.0,
    'Running- Long distance': 12.0,
    'Rowing': 8.5,
    'Basketball': 8.0,
    'Circuit Training': 9.0,
    'Walking uphill': 6.5,
    'Football': 9.5,
    'Sailing': 2.5,
    'Walking Around': 3.0,
    'Walking Slowly': 2.0,
    'Calisthenics': 5.5,
    'Walking Quickly': 4.5,
    'Aerobic Dancing - Low intensity': 4.0,
    'Climbing Stairs': 8.0,
    'Cycling': 7.5,
  };

  void _calculateCalories() {
    if (selectedActivity.isNotEmpty && duration > 0) {
      setState(() {
        estimatedCalories =
            (caloriesPerMinute[selectedActivity] ?? 5.0) * duration;
      });

      // Show success message
      Get.snackbar(
        'Calculated',
        'Estimated calories: ${estimatedCalories.toStringAsFixed(2)} Kcal',
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
                  SemiBoldText(
                    'Choose your Activity',
                    fontSize: 18,
                    textColor: Colors.black87,
                  ),
                  const SizedBox(height: 16),

                  // Activity chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: activities.map((activity) {
                      final isSelected = selectedActivity == activity;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedActivity = activity;
                            // Recalculate calories when activity changes
                            if (duration > 0) {
                              estimatedCalories =
                                  (caloriesPerMinute[activity] ?? 5.0) *
                                      duration;
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
                            activity,
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
                  ),

                  const SizedBox(height: 24),

                  // Duration Section
                  SemiBoldText(
                    'Duration in mins',
                    fontSize: 16,
                    textColor: Colors.black87,
                  ),
                  const SizedBox(height: 16),

                  // Slider
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.green,
                      inactiveTrackColor: Colors.grey.shade300,
                      thumbColor: Colors.green,
                      overlayColor: Colors.green.withAlpha(32),
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 12),
                      trackHeight: 4,
                    ),
                    child: Slider(
                      value: duration,
                      min: 0,
                      max: 120,
                      divisions: 24,
                      label: '${duration.round()} mins',
                      onChanged: (value) {
                        setState(() {
                          duration = value;
                          // Recalculate calories when duration changes
                          if (selectedActivity.isNotEmpty) {
                            estimatedCalories =
                                (caloriesPerMinute[selectedActivity] ?? 5.0) *
                                    duration;
                          }
                        });
                      },
                    ),
                  ),

                  // Duration display
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: RegularText(
                      'Duration: ${duration.round()} mins',
                      fontSize: 14,
                      textColor: Colors.grey.shade600,
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
                  SemiBoldText(
                    '${estimatedCalories.toStringAsFixed(2)} Kcal',
                    fontSize: 20,
                    textColor: const Color(0xFF091242),
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
