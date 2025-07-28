import 'package:flutter/material.dart';
import 'package:sodiet/route/app_routes.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/view/widgets/layouts/base_screen_layout.dart';
import 'package:sodiet/view/widgets/common/title_section_widget.dart';

class CourseCorrectionScreen extends StatefulWidget {
  const CourseCorrectionScreen({Key? key}) : super(key: key);

  @override
  State<CourseCorrectionScreen> createState() => _CourseCorrectionScreenState();
}

class _CourseCorrectionScreenState extends State<CourseCorrectionScreen> {
  List<bool> selectedDates = [false, false, false]; // Track selected dates
  int totalDelta = 0;

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      currentRoute: AppRoutes.courseCorrectionScreen,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            TitleSectionWidget(
              imagePath: 'assets/images/correntions.png',
              title: 'Course Correction',
              description: 'Select Date and Do the Course Correction Here',
            ),
            const SizedBox(height: 4),

            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Select date section
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: SemiBoldText(
                      'Select date for course correction',
                      fontSize: 18,
                      textColor: const Color(0xFF091242),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Date Cards
                  ...List.generate(3, (index) => _buildDateCard(index)),

                  const SizedBox(height: 24),
                  SizedBox(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SemiBoldText(
                              'Total Delta:',
                              fontSize: 16,
                              textColor: const Color(0xFF091242),
                            ),
                            SemiBoldText(
                              '$totalDelta Kcal',
                              fontSize: 16,
                              textColor: const Color(0xFF091242),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          width: 120,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle submit
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: RegularText(
                                      'Course correction submitted successfully'),
                                  backgroundColor: const Color(0xFF2AB989),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF9800),
                              padding: const EdgeInsets.symmetric(vertical: 16),
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
                  )
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDateCard(int index) {
    final isSelected = selectedDates[index];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xffF5F5F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date header with select button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RegularText(
                'Date: 03-09-2025',
                fontSize: 14,
                textColor: Colors.grey.shade700,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDates[index] = !selectedDates[index];
                    // Update total delta based on selection
                    if (selectedDates[index]) {
                      totalDelta += -1724; // Add the delta for this date
                    } else {
                      totalDelta -= -1724; // Remove the delta for this date
                    }
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF2AB989)
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected ? Icons.check : Icons.calendar_today,
                        size: 14,
                        color: isSelected ? Colors.white : Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      RegularText(
                        isSelected ? 'Selected' : 'Select',
                        fontSize: 12,
                        textColor:
                            isSelected ? Colors.white : Colors.grey.shade600,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Calorie Information
          SemiBoldText(
            '-1724 Kcal',
            fontSize: 24,
            textColor: const Color(0xFF091242),
          ),

          const SizedBox(height: 12),

          // Delta Information
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Expenditure Delta
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RegularText(
                    'Expenditure Delta',
                    fontSize: 12,
                    textColor: Colors.grey.shade600,
                  ),
                  const SizedBox(height: 2),
                  SemiBoldText(
                    '479 Kcal',
                    fontSize: 14,
                    textColor: const Color(0xFF091242),
                  ),
                ],
              ),

              // Intake Delta
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RegularText(
                    'Intake Delta',
                    fontSize: 12,
                    textColor: Colors.grey.shade600,
                  ),
                  const SizedBox(height: 2),
                  SemiBoldText(
                    '-2203 Kcal',
                    fontSize: 14,
                    textColor: const Color(0xFF091242),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
