import 'package:flutter/material.dart';
import 'package:sodiet/view/widgets/app_text.dart';

class WelcomeTitleWidget extends StatelessWidget {
  final String userName;
  final Function() onLogWeightTap;

  const WelcomeTitleWidget({
    Key? key,
    required this.userName,
    required this.onLogWeightTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Row(
          children: [
            // Welcome text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RegularText(
                    'Welcome Back',
                    fontSize: 12,
                    textColor: Colors.grey,
                  ),
                  const SizedBox(height: 4),
                  SemiBoldText(
                    '$userName!',
                    fontSize: 24,
                    textColor: const Color(0xFF091242), // Dark blue
                  ),
                ],
              ),
            ),

            // Log weight button
            Container(
              height: 45,
              child: ElevatedButton.icon(
                onPressed: onLogWeightTap,
                icon: const Icon(Icons.grade, color: Colors.white),
                label: MediumText(
                  'Log weight',
                  fontSize: 12,
                  textColor: Colors.white,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFA500), // Orange color
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
