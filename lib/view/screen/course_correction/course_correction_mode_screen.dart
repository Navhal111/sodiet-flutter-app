import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sodiet/controller/course_correction/course_correction_controller.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/view/widgets/common/title_section_widget.dart';
import 'package:sodiet/view/widgets/home/data_summary_widget.dart';
import 'package:sodiet/view/widgets/course_correction/course_correction_mode_widget.dart';

class CourseCorrectionModeScreen extends StatefulWidget {
  const CourseCorrectionModeScreen({Key? key}) : super(key: key);

  @override
  State<CourseCorrectionModeScreen> createState() =>
      _CourseCorrectionModeScreenState();
}

class _CourseCorrectionModeScreenState
    extends State<CourseCorrectionModeScreen> {
  late CourseCorrectionController controller;
  RxInt selectedMode =
      0.obs; // 0=Physical, 1=Intake(3day), 2=Intake(Auto), 3=Mix
  RxDouble mixSliderValue = 50.0.obs; // For Mix mode slider (default 50%)

  @override
  void initState() {
    super.initState();
    controller = Get.find<CourseCorrectionController>();
  }

  String _getLastSelectedDate() {
    if (controller.selectedCorrections.isEmpty ||
        controller.correctionData.isEmpty) {
      return 'No date selected';
    }

    final lastIndex = controller.selectedCorrections.last;
    if (lastIndex < controller.correctionData.length) {
      final lastDate = controller.correctionData[lastIndex].date;
      final parsedDate = DateTime.parse(lastDate);
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    }

    return 'Invalid date';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF091242),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SemiBoldText(
                    'Course correction',
                    fontSize: 18,
                    textColor: const Color(0xFF091242),
                  ),
                ],
              ),
            ),
            // Title Section
            TitleSectionWidget(
              imagePath: 'assets/images/correntions.png',
              title: 'Course Correction',
              description: 'Select Date and Do the Course Correction Here',
            ),
            const SizedBox(height: 4),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary Data Widgets - Horizontal Scroll like home screen
                    // Title Section
                    SizedBox(
                      height: 80,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Obx(() => DataSummaryWidget(
                                title: 'Course Correcting Till',
                                startValue: _getLastSelectedDate(),
                                endValue: '',
                                onClick: () {},
                              )),
                          const SizedBox(width: 8),
                          Obx(() => DataSummaryWidget(
                                title: 'Delta',
                                startValue:
                                    '${controller.totalDelta.value.toStringAsFixed(2)}',
                                endValue: '',
                                onClick: () {},
                              )),
                          const SizedBox(width: 16), // Extra space at end
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Mode Selection Section in white container
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
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
                          // Mode Selection Title
                          SemiBoldText(
                            'Select course correction mode',
                            fontSize: 18,
                            textColor: const Color(0xFF091242),
                          ),

                          const SizedBox(height: 16),

                          // Mode Options
                          Obx(() => Column(
                                children: [
                                  // Physical Activity
                                  CourseCorrectionModeWidget(
                                    title: 'Physical Activity',
                                    description:
                                        'Adjust the expenditure by recommending changes in physical activity to offset the positive / negative delta',
                                    imagePath: 'assets/images/physical.gif',
                                    onTap: () => selectedMode.value = 0,
                                    isSelected: selectedMode.value == 0,
                                  ),

                                  // Intake Correction (3 day)
                                  CourseCorrectionModeWidget(
                                    title: 'Intake Correction (3 day)',
                                    description:
                                        'Corrects the delta by adjusting the daily break over the next 3 days with specific percentages',
                                    imagePath: 'assets/images/corrections.gif',
                                    onTap: () => selectedMode.value = 1,
                                    isSelected: selectedMode.value == 1,
                                  ),

                                  // Intake (Auto)
                                  CourseCorrectionModeWidget(
                                    title: 'Intake (Auto)',
                                    description:
                                        'Distributes the delta evenly over the next three days computed by the algorithm',
                                    imagePath: 'assets/images/intake.gif',
                                    onTap: () => selectedMode.value = 2,
                                    isSelected: selectedMode.value == 2,
                                  ),

                                  // Mix of Intake and Physical Activity
                                  CourseCorrectionModeWidget(
                                    title:
                                        'Mix of Intake and Physical Activity',
                                    description:
                                        'Recommends a combination of physical and intake adjustment based on a specific ratio',
                                    imagePath: 'assets/images/mix.gif',
                                    hasSlider: true,
                                    sliderValue: mixSliderValue,
                                    onSliderChanged: (value) {
                                      mixSliderValue.value = value;
                                    },
                                    onTap: () => selectedMode.value = 3,
                                    isSelected: selectedMode.value == 3,
                                  ),
                                ],
                              )),
                          const SizedBox(height: 10),

                          // Submit Button
                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle submission based on selected mode
                                _handleModeSubmission();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF9800),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: SemiBoldText(
                                'Submit',
                                fontSize: 16,
                                textColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleModeSubmission() {
    String modeName = '';
    String additionalInfo = '';

    switch (selectedMode.value) {
      case 0:
        modeName = 'Physical Activity';
        break;
      case 1:
        modeName = 'Intake Correction (3 day)';
        break;
      case 2:
        modeName = 'Intake (Auto)';
        break;
      case 3:
        modeName = 'Mix of Intake and Physical Activity';
        additionalInfo =
            '\n\nIntake: ${mixSliderValue.value.toInt()}%\nExpenditure: ${(100 - mixSliderValue.value).toInt()}%';
        break;
    }

    // Show confirmation dialog
    Get.dialog(
      AlertDialog(
        title: Text('Confirm Submission'),
        content: Text(
            'You have selected "$modeName" for course correction.$additionalInfo\n\nDo you want to proceed?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();

              // Map selectedMode to correctionMode strings
              String correctionMode = '';
              switch (selectedMode.value) {
                case 0:
                  correctionMode = 'PA'; // Physical Activity
                  break;
                case 1:
                  correctionMode = 'AC'; // 3-day
                  break;
                case 2:
                  correctionMode = '3D'; // Auto Correction
                  break;
                case 3:
                  correctionMode = 'IA'; // Intake and Activity mix
                  break;
              }

              // Get the last selected date
              String ccDate = _getLastSelectedDate();

              // Get split ratio for Mix mode
              int splitRatio =
                  correctionMode == 'IA' ? mixSliderValue.value.toInt() : 0;

              // Call the API
              await controller.submitCourseCorrectionMaster(
                delta: controller.totalDelta.value,
                ccDate: ccDate,
                correctionMode: correctionMode,
                splitRatio: splitRatio,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9800),
            ),
            child: Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
