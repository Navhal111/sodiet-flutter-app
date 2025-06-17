import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/route/app_routes.dart';
import 'package:sodiet/utils/images.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/view/widgets/custom_button.dart';
import 'package:sodiet/view/widgets/custom_text_field.dart';
import 'package:sodiet/view/widgets/password_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _login() {
    // Implement login functionality
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty) {
      Get.snackbar('Error', 'Please enter your email address');
      return;
    }

    if (password.isEmpty) {
      Get.snackbar('Error', 'Please enter your password');
      return;
    }

    // TODO: Implement login functionality with API
    print('Login with: $email, $password, Remember: $_rememberMe');

    // Navigate to home screen on successful login
    Get.offAllNamed(AppRoutes.homeScreen);
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
                MediumText(
                  'Login',
                  fontSize: 24,
                ),
                const SizedBox(height: 10),
                RegularText(
                  'Please enter your email and password to access your account',
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
                  hintText: 'Password',
                  onSubmitted: (_) => _login(),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _rememberMe,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (bool? value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                            side: BorderSide(
                              color: Colors.black54,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        MediumText(
                          'Keep me logged in',
                          textColor: Colors.black54,
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.forgotPasswordScreen);
                      },
                      child: SemiBoldText(
                        'Forgot password',
                        textColor: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Center(
                  child: CustomButton(
                    width: Get.width - 80,
                    text: 'Login',
                    onPressed: _login,
                    height: 44,
                    showShadow: true,
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
