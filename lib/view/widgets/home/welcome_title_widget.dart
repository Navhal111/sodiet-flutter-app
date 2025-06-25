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
            SizedBox(
              height: 45,
              child: ElevatedButton(
                onPressed: onLogWeightTap,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/pulse.png',
                      width: 12,
                      height: 12,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    MediumText(
                      'Log weight',
                      fontSize: 12,
                      textColor: Colors.white,
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFA500), // Orange color
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
