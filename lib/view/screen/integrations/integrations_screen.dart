import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/view/widgets/common/title_section_widget.dart';
import 'package:sodiet/view/widgets/layouts/base_screen_layout.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/route/app_routes.dart';

class IntegrationsScreen extends StatefulWidget {
  const IntegrationsScreen({Key? key}) : super(key: key);

  @override
  State<IntegrationsScreen> createState() => _IntegrationsScreenState();
}

class _IntegrationsScreenState extends State<IntegrationsScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      currentRoute: AppRoutes.integrationsScreen,
      title: 'Integrations',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleSectionWidget(
              imagePath: 'assets/images/integrations.png',
              title: 'Integrations',
              description:
                  'Seamlessly connect your wearable devices with Virtual Dietician through platforms like Apple HealthKit and Google Health SDK.',
              imageWidth: 60,
              imageHeight: 60,
            ),

            // Apple HealthKit Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
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
                  SemiBoldText(
                    'Apple HealthKit',
                    fontSize: 18,
                    textColor: Colors.black87,
                  ),
                  const SizedBox(height: 12),
                  RegularText(
                    'Enable synchronization with Apple HealthKit to import your activity, sleep, and nutrition data directly into Virtual Dietician for a comprehensive health analysis.',
                    fontSize: 14,
                    textColor: const Color(0xFF4C4C4C),
                  ),
                  const SizedBox(height: 16),

                  // Steps list
                  _buildStepItem('1. Open Apple Health App'),
                  _buildStepItem('2. Go to Sources Tab'),
                  _buildStepItem(
                      '3. Find \'Virtual Dietician\' and enable permissions'),

                  const SizedBox(height: 20),

                  // Get Started Button
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle Apple HealthKit integration
                        Get.snackbar(
                          'Apple HealthKit',
                          'Opening Apple Health integration...',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: const Color(0xFF4CAF50),
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(16),
                          borderRadius: 8,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF9800),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Google Health SDK Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
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
                  SemiBoldText(
                    'Google Health SDK',
                    fontSize: 18,
                    textColor: Colors.black87,
                  ),
                  const SizedBox(height: 12),
                  RegularText(
                    'Connect your Android wearables and apps with Virtual Dietician using Google Health SDK for real-time health tracking and personalized diet plans.',
                    fontSize: 14,
                    textColor: const Color(0xFF4C4C4C),
                  ),
                  const SizedBox(height: 16),

                  // Steps list
                  _buildStepItem('1. Open \'Virtual Dietician\' App Settings'),
                  _buildStepItem('2. Select \'Connect to Google Health\''),
                  _buildStepItem('3. Authorize and sync your data'),

                  const SizedBox(height: 20),

                  // Get Started Button
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle Google Health SDK integration
                        Get.snackbar(
                          'Google Health SDK',
                          'Opening Google Health integration...',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: const Color(0xFF4CAF50),
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(16),
                          borderRadius: 8,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF9800),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStepItem(String step) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6, right: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF091242),
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: RegularText(
              step,
              fontSize: 14,
              textColor: const Color(0xFF4C4C4C),
            ),
          ),
        ],
      ),
    );
  }
}
