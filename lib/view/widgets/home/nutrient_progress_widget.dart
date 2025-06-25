import 'package:flutter/material.dart';
import 'package:sodiet/view/widgets/app_text.dart';

class NutrientProgressWidget extends StatelessWidget {
  final String nutrientName;
  final double percentage;
  final double inputValue;
  final double requiredValue;
  final Color progressColor;
  final Function()? onTap;

  const NutrientProgressWidget({
    Key? key,
    required this.nutrientName,
    required this.percentage,
    required this.inputValue,
    required this.requiredValue,
    this.progressColor = const Color(0xFF8BC34A), // Default green color
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row with nutrient name and percentage
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Nutrient name
                SemiBoldText(
                  nutrientName,
                  fontSize: 18,
                  textColor: Colors.black87,
                ),

                // Percentage
                SemiBoldText(
                  '${percentage.toStringAsFixed(1)}%',
                  fontSize: 18,
                  textColor: progressColor,
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: percentage / 100 > 1 ? 1 : percentage / 100,
                backgroundColor: Colors.grey.shade300,
                color: progressColor,
                minHeight: 8,
              ),
            ),

            const SizedBox(height: 10),

            // Bottom row with input and required values
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Input value
                RegularText(
                  'IN:${inputValue.toStringAsFixed(1)}',
                  fontSize: 16,
                  textColor: Colors.grey.shade500,
                ),

                // Required value
                RegularText(
                  'REQ: ${requiredValue.toStringAsFixed(1)}',
                  fontSize: 16,
                  textColor: Colors.grey.shade500,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
