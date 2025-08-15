import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/view/widgets/app_text.dart';

class CourseCorrectionModeWidget extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final String? recommendationText;
  final VoidCallback onTap;
  final bool isSelected;
  final bool hasSlider;
  final RxDouble? sliderValue;
  final Function(double)? onSliderChanged;

  const CourseCorrectionModeWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.imagePath,
    this.recommendationText,
    required this.onTap,
    this.isSelected = false,
    this.hasSlider = false,
    this.sliderValue,
    this.onSliderChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5), // Light gray background
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF2AB989) : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Icon/Image Section
            Container(
              width: 80,
              height: 80,
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(width: 16),

            // Content Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SemiBoldText(
                    title,
                    fontSize: 16,
                    textColor: const Color(0xFF091242),
                  ),
                  const SizedBox(height: 4),
                  RegularText(
                    description,
                    fontSize: 13,
                    textColor: Colors.grey.shade600,
                    maxLines: 3,
                  ),
                  if (recommendationText != null && !hasSlider) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F8FF),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: const Color(0xFF007BFF),
                          width: 1,
                        ),
                      ),
                      child: RegularText(
                        recommendationText!,
                        fontSize: 11,
                        textColor: const Color(0xFF007BFF),
                      ),
                    ),
                  ],
                  if (hasSlider && sliderValue != null) ...[
                    Obx(() => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: const Color(0xFFFF9800),
                                inactiveTrackColor: Colors.grey.shade300,
                                thumbColor: const Color(0xFFFF9800),
                                overlayColor:
                                    const Color(0xFFFF9800).withOpacity(0.2),
                                trackHeight: 4,
                                thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 8),
                              ),
                              child: Slider(
                                value: sliderValue!.value,
                                min: 0,
                                max: 100,
                                divisions: 100,
                                onChanged: onSliderChanged,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: RegularText(
                                'Intake ${sliderValue!.value.toInt()}% and Expenditure ${(100 - sliderValue!.value).toInt()}%',
                                fontSize: 11,
                                textColor: Colors.black,
                              ),
                            ),
                          ],
                        )),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
