import 'package:flutter/material.dart';
import 'package:sodiet/utils/images.dart';
import 'package:sodiet/view/widgets/app_text.dart';

class PlanStatusWidget extends StatelessWidget {
  final VoidCallback onResetTap;

  const PlanStatusWidget({
    Key? key,
    required this.onResetTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon/Illustration
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                MyImages.plan,
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SemiBoldText(
                  'Plan Status',
                  fontSize: 20,
                  textColor: const Color(0xFF091242),
                ),
                const SizedBox(height: 4),
                RegularText(
                  'View and manage your weekly optimization plans to track your progress and stay on top of your diet and fitness goals.',
                  fontSize: 12,
                  textColor: Colors.grey.shade600,
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                // Reset Button
                GestureDetector(
                  onTap: onResetTap,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(
                          0xFFDC3545), // Red color like in screenshot
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        MediumText(
                          'Reset',
                          fontSize: 12,
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
