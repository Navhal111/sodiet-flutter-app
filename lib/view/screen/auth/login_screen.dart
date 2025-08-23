import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/controller/auth/authController.dart';
import 'package:sodiet/route/app_routes.dart';
import 'package:sodiet/utils/images.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/view/widgets/custom_text_field.dart';
import 'package:sodiet/view/widgets/password_text_field.dart';

import '../../widgets/common/showCustomSnackBar.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController.text = "test@example.com";
    _passwordController.text = "test123";
  }

  void _login(AuthController authController) {
    // Implement Supabase login functionality
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty) {
      showCustomSnackBar('Please enter your email address', context);
      return;
    }

    if (password.isEmpty) {
      showCustomSnackBar('Please enter your password', context);
      return;
    }

    // Use Supabase authentication instead of demo login
    authController.signIn(email, password, context);

    // Keep demo login as fallback (remove this line when you're ready to fully switch to Supabase)
    // authController.demoLoginTry({
    //   "userName": email,
    //   "password": password,
    // }, context);
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
                      onSubmitted: (_) => _login(authController),
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
                                    _login(authController);
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
                                        'Logging in...',
                                        fontSize: 14,
                                        textColor: Colors.white,
                                      ),
                                    ],
                                  )
                                : MediumText(
                                    'Login',
                                    fontSize: 14,
                                    textColor: Theme.of(context).hintColor,
                                  ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
