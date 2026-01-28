import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/utils/images.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/view/widgets/custom_button.dart';
import 'package:sodiet/view/widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}
//comment
class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  void _sendResetLink() {
    // Implement send reset link functionality
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar('Error', 'Please enter your registered email address');
      return;
    }

    // TODO: Implement API call to send password reset link
    print('Sending reset link to: $email');

    // Show success message
    Get.snackbar(
      'Success',
      'Password recovery link has been sent to your email',
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
      colorText: Theme.of(context).primaryColor,
    );
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
                Center(
                  child: CustomButton(
                    width: Get.width - 80,
                    text: 'Get Link',
                    onPressed: _sendResetLink,
                    height: 44,
                    showShadow: true,
                  ),
                ),
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
