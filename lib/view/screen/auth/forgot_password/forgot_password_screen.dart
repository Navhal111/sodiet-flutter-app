import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/controller/auth/authController.dart';
import 'package:sodiet/utils/images.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/view/widgets/custom_button.dart';
import 'package:sodiet/view/widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  void _sendResetLink() async {
    // Implement Supabase password reset functionality
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar('Error', 'Please enter your registered email address');
      return;
    }

    // Use AuthController to send password reset
    final authController = Get.find<AuthController>();
    bool success = await authController.resetPassword(email, context);

    // Navigate back to login screen after successful reset
    if (success) {
      Get.back(); // Navigate back to login screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Image.asset(
                  MyImages.splashLogo,
                  width: 80,
                  height: 80,
                ),
                const SizedBox(height: 15),
                SemiBoldText(
                  'Forgot Password',
                  fontSize: 24,
                ),
                const SizedBox(height: 10),
                RegularText(
                  'Please enter the registered email to get the password recovery link',
                  textColor: Colors.black54,
                  fontSize: 14,
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  hintText: 'abc@xyz.com',
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 30),
                Obx(() {
                  final authController = Get.find<AuthController>();
                  return Center(
                    child: Container(
                      width: Get.width - 80,
                      height: 44,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),
                      child: TextButton(
                        onPressed: authController.isLoading.value
                            ? null
                            : _sendResetLink,
                        style: TextButton.styleFrom(
                          backgroundColor: authController.isLoading.value
                              ? Colors.grey.shade400
                              : Theme.of(context).primaryColor,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: authController.isLoading.value
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Get Link',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 20),
                Center(
                  child: CustomButton(
                    width: Get.width - 80,
                    text: 'Back to login',
                    onPressed: () {
                      Get.back(); // Navigate back to login screen
                    },
                    height: 44,
                    showShadow: false,
                    isOutlined: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
