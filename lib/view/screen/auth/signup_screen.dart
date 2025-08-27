import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/controller/auth/authController.dart';
import 'package:sodiet/route/app_routes.dart';
import 'package:sodiet/utils/images.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/view/widgets/custom_text_field.dart';
import 'package:sodiet/view/widgets/password_text_field.dart';

import '../../widgets/common/showCustomSnackBar.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _signup(AuthController authController) {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty) {
      showCustomSnackBar('Please enter your email address', context);
      return;
    }

    if (password.isEmpty) {
      showCustomSnackBar('Please enter your password', context);
      return;
    }

    if (confirmPassword.isEmpty) {
      showCustomSnackBar('Please confirm your password', context);
      return;
    }

    if (password != confirmPassword) {
      showCustomSnackBar('Passwords do not match', context);
      return;
    }

    if (password.length < 6) {
      showCustomSnackBar(
          'Password must be at least 6 characters long', context);
      return;
    }

    // Use Supabase authentication for signup
    authController.signUp(email, password, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        body: GetBuilder<AuthController>(builder: (authController) {
          return SafeArea(
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
                    MediumText(
                      'Sign Up',
                      fontSize: 24,
                    ),
                    const SizedBox(height: 10),
                    RegularText(
                      'Create your account to get started with your diet plan',
                      textColor: Colors.black54,
                      fontSize: 14,
                    ),
                    const SizedBox(height: 30),
                    CustomTextField(
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      nextFocus: _passwordFocusNode,
                      hintText: 'Email address',
                      textInputType: TextInputType.emailAddress,
                    ),
                    PasswordTextField(
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      nextFocus: _confirmPasswordFocusNode,
                      hintText: 'Password',
                    ),
                    PasswordTextField(
                      controller: _confirmPasswordController,
                      focusNode: _confirmPasswordFocusNode,
                      hintText: 'Confirm Password',
                      onSubmitted: (_) => _signup(authController),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: Obx(() {
                        return Container(
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
                                : () {
                                    _signup(authController);
                                  },
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
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      MediumText(
                                        'Creating Account...',
                                        fontSize: 14,
                                        textColor: Colors.white,
                                      ),
                                    ],
                                  )
                                : MediumText(
                                    'Sign Up',
                                    fontSize: 14,
                                    textColor: Theme.of(context).hintColor,
                                  ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RegularText(
                            'Already have an account? ',
                            textColor: Colors.black54,
                            fontSize: 14,
                          ),
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: SemiBoldText(
                              'Login',
                              textColor: Theme.of(context).primaryColorDark,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
