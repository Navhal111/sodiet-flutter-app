import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sodiet/constant/appConstant.dart';
import 'package:sodiet/route/app_routes.dart';

import '../../constant/staticData.dart';
import '../../repo/authRepo.dart';
import '../../view/widgets/common/showCustomSnackBar.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  AuthController({
    required this.authRepo,
  });

  RxBool isLoading = false.obs;

  loginCheckScreen() {
    var userData = authRepo.sharedPreferences.getString(AppConstants.userData);

    if (userData != "" && userData != null) {
      Get.offNamed(AppRoutes.homeScreen);
    } else {
      Get.offNamed(AppRoutes.loginScreen);
    }
  }

  demoLoginTry(Map<String, dynamic> loginData, BuildContext context) {
    isLoading.value = true;
    if (loginData["userName"] == StaticData.LOGIN_USNANE &&
        loginData["password"] == StaticData.LOGIN_PASSWORD) {
      authRepo.sharedPreferences
          .setString(AppConstants.userData, jsonEncode(loginData));
      Get.offNamed(AppRoutes.homeScreen);
    } else {
      showCustomSnackBar("Wrong username and password ", context);
    }
    isLoading.value = false;
  }

  logout(BuildContext context) {
    // Clear all user data from shared preferences
    authRepo.sharedPreferences.remove(AppConstants.userData);
    authRepo.sharedPreferences.remove(AppConstants.TOKEN);
    authRepo.sharedPreferences.remove(AppConstants.SaveAccessKey);

    // Navigate to login screen
    Get.offAllNamed(AppRoutes.loginScreen);

    // Show logout confirmation
    showCustomSnackBar("You have been logged out successfully", context);
  }
}
