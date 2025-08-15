import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sodiet/controller/course_correction/course_correction_controller.dart';
import 'package:sodiet/route/app_routes.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/view/widgets/layouts/base_screen_layout.dart';
import 'package:sodiet/view/widgets/common/title_section_widget.dart';
import 'package:sodiet/view/widgets/common/shimmer_loading.dart';

class CourseCorrectionScreen extends StatefulWidget {
  const CourseCorrectionScreen({Key? key}) : super(key: key);

  @override
  State<CourseCorrectionScreen> createState() => _CourseCorrectionScreenState();
}

class _CourseCorrectionScreenState extends State<CourseCorrectionScreen> {
  late CourseCorrectionController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<CourseCorrectionController>();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      currentRoute: AppRoutes.courseCorrectionScreen,
      child: RefreshIndicator(
        onRefresh: controller.refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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

              // Removed summary section as requested

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

                    // Dynamic Date Cards or Shimmer Loading
                    Obx(() {
                      if (controller.isLoading.value) {
                        return _buildShimmerLoading();
                      } else if (controller.correctionData.isEmpty) {
                        return _buildEmptyState();
                      } else {
                        return Column(
                          children: List.generate(
                            controller.correctionData.length,
                            (index) => _buildDateCard(index),
                          ),
                        );
                      }
                    }),

                    const SizedBox(height: 24),

                    // Total Delta and Submit Section
                    Obx(() => SizedBox(
                          height: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SemiBoldText(
                                      'Total Delta:',
                                      fontSize: 16,
                                      textColor: const Color(0xFF091242),
                                    ),
                                    const SizedBox(height: 4),
                                    SemiBoldText(
                                      '${controller.totalDelta.value.toStringAsFixed(2)} Kcal',
                                      fontSize: 18,
                                      textColor:
                                          controller.totalDelta.value >= 0
                                              ? const Color(0xFF4CAF50)
                                              : const Color(0xFFE53E3E),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                width: 120,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed:
                                      controller.selectedCorrections.isNotEmpty
                                          ? controller.submitCorrections
                                          : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFF9800),
                                    disabledBackgroundColor:
                                        Colors.grey.shade300,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: controller.isSubmitting.value
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          ),
                                        )
                                      : SemiBoldText(
                                          'Submit',
                                          fontSize: 16,
                                          textColor: controller
                                                  .selectedCorrections
                                                  .isNotEmpty
                                              ? Colors.white
                                              : Colors.grey.shade600,
                                        ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Build shimmer loading for course correction cards
  Widget _buildShimmerLoading() {
    return Column(
      children: List.generate(
        3,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ShimmerCombinationForm(
            width: double.infinity,
            height: 150,
            title: 'Loading Course Correction...',
          ),
        ),
      ),
    );
  }

  // Build empty state when no data available
  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 32),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(
            Icons.assignment_turned_in_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          SemiBoldText(
            'No Course Corrections Available',
            fontSize: 16,
            textColor: Colors.grey.shade600,
          ),
          const SizedBox(height: 8),
          RegularText(
            'All course corrections are up to date',
            fontSize: 14,
            textColor: Colors.grey.shade500,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDateCard(int index) {
    final correctionData = controller.correctionData[index];
    final isSelected = controller.isSelected(index);

    // Format date
    DateTime date = DateTime.parse(correctionData.date);
    String formattedDate = DateFormat('dd-MM-yyyy').format(date);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: correctionData.actualTotalDelta >= 0
            ? const Color(0xFFE8F5E8) // Light green for positive
            : const Color(0xFFFFEBEE), // Light red for negative
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
                'Date: $formattedDate',
                fontSize: 14,
                textColor: Colors.grey.shade700,
              ),
              GestureDetector(
                onTap: () {
                  controller.toggleSelection(index);
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
            '${correctionData.actualTotalDelta.toStringAsFixed(2)} Kcal',
            fontSize: 24,
            textColor: correctionData.actualTotalDelta >= 0
                ? const Color(0xFF4CAF50)
                : const Color(0xFFE53E3E),
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
                    '${correctionData.expDelta.toStringAsFixed(2)} Kcal',
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
                    '${correctionData.intakeDelta.toStringAsFixed(2)} Kcal',
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
