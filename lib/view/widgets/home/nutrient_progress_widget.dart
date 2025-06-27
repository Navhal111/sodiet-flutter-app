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
      borderRadius: BorderRadius.circular(19),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(19),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row with nutrient name and percentage
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Nutrient name
                MediumText(
                  nutrientName,
                  fontSize: 14,
                  textColor: Colors.black87,
                ),

                // Percentage
                SemiBoldText(
                  '${percentage.toStringAsFixed(1)}%',
                  fontSize: 14,
                  textColor: progressColor,
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: LinearProgressIndicator(
                value: percentage / 100 > 1 ? 1 : percentage / 100,
                backgroundColor: Colors.grey.shade300,
                color: progressColor,
                minHeight: 6,
              ),
            ),

            const SizedBox(height: 10),

            // Bottom row with input and required values
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Input value
                MediumText(
                  'IN:${inputValue.toStringAsFixed(1)}',
                  fontSize: 14,
                  textColor: Color(0xFF4C4C80).withOpacity(0.5),
                ),

                // Required value
                MediumText(
                  'REQ: ${requiredValue.toStringAsFixed(1)}',
                  fontSize: 16,
                  textColor: Color(0xFF4C4C80).withOpacity(0.5),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
