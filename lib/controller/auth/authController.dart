import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/constant/appConstant.dart';
import 'package:sodiet/route/app_routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../api/supabase_auth_service.dart';
import '../../constant/staticData.dart';
import '../../repo/authRepo.dart';
import '../../view/widgets/common/showCustomSnackBar.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  AuthController({
    required this.authRepo,
  });

  RxBool isLoading = false.obs;

  loginCheckScreen() async {
    // Check if user is logged in with Supabase
    if (SupabaseAuthService.isLoggedIn) {
      final response = await SupabaseAuthService.refreshSession();
      if (response.session?.accessToken != null) {
        await authRepo.sharedPreferences
            .setString(AppConstants.TOKEN, response.session!.accessToken);
      }
      Get.offNamed(AppRoutes.homeScreen);
    } else {
      Get.offNamed(AppRoutes.loginScreen);
    }
  }

  // Supabase Sign In
  Future<void> signIn(
      String email, String password, BuildContext context) async {
    // Prevent multiple simultaneous login attempts
    if (isLoading.value) return;

    try {
      isLoading.value = true;

      final response = await SupabaseAuthService.signIn(
        email: email,
        password: password,
      );
      if (response.user != null) {
        // Save user data to shared preferences
        final userData = {
          'id': response.user!.id,
          'email': response.user!.email,
          'created_at': response.user!.createdAt,
          'name': SupabaseAuthService.userName,
          'full_name': SupabaseAuthService.userFullName,
          'user_metadata': response.user!.userMetadata,
        };
        print(
            " SupabaseAuthService.userName!===== ${SupabaseAuthService.userName}");

        await authRepo.sharedPreferences
            .setString(AppConstants.userData, jsonEncode(userData));
        if (response.session?.accessToken != null) {
          await authRepo.sharedPreferences
              .setString(AppConstants.TOKEN, response.session!.accessToken);
          print(
              " SupabaseAuthService.new token !===== ${response.session!.accessToken}");
        }
        showCustomSnackBar("Login successful!", context, isError: false);
        Get.offNamed(AppRoutes.homeScreen);
      } else {
        showCustomSnackBar("Login failed. Please try again.", context);
      }
    } catch (e) {
      showCustomSnackBar(SupabaseAuthService.getAuthErrorMessage(e), context);
    } finally {
      isLoading.value = false;
    }
  }

  // Supabase Sign Up
  Future<void> signUp(String email, String password, BuildContext context,
      {Map<String, dynamic>? userData}) async {
    try {
      isLoading.value = true;

      final response = await SupabaseAuthService.signUp(
        email: email,
        password: password,
        data: userData,
      );

      if (response.user != null) {
        showCustomSnackBar(
            "Account created successfully! Please check your email to confirm your account.",
            context,
            isError: false);
        Get.offNamed(AppRoutes.loginScreen);
      } else {
        showCustomSnackBar("Registration failed. Please try again.", context);
      }
    } catch (e) {
      showCustomSnackBar(SupabaseAuthService.getAuthErrorMessage(e), context);
    } finally {
      isLoading.value = false;
    }
  }

  // Send Password Reset Email
  Future<void> resetPassword(String email, BuildContext context) async {
    try {
      isLoading.value = true;

      await SupabaseAuthService.resetPassword(email: email);
      showCustomSnackBar("Password reset link sent to your email!", context,
          isError: false);
    } catch (e) {
      showCustomSnackBar(SupabaseAuthService.getAuthErrorMessage(e), context);
    } finally {
      isLoading.value = false;
    }
  }

  // Keep the demo login for backward compatibility (you can remove this later)
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

  // Logout method without context dependency
  Future<bool> logoutUser() async {
    try {
      // Sign out from Supabase
      await SupabaseAuthService.signOut();

      // Clear all user data from shared preferences
      authRepo.sharedPreferences.remove(AppConstants.userData);
      authRepo.sharedPreferences.remove(AppConstants.TOKEN);
      authRepo.sharedPreferences.remove(AppConstants.SaveAccessKey);

      // Navigate to login screen
      Get.offAllNamed(AppRoutes.loginScreen);

      // Show success message using GetX snackbar (doesn't depend on context)
      Get.snackbar(
        "Success",
        "You have been logged out successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        margin: EdgeInsets.all(12),
        borderRadius: 8,
      );

      return true;
    } catch (e) {
      // Show error using GetX snackbar
      Get.snackbar(
        "Error",
        "Error during logout: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(12),
        borderRadius: 8,
      );
      return false;
    }
  }

  // Keep the old logout method for backward compatibility
  logout(BuildContext context) async {
    await logoutUser();
  }

  // Get current user info
  User? get currentUser => SupabaseAuthService.currentUser;

  // Check if user is logged in
  bool get isUserLoggedIn => SupabaseAuthService.isLoggedIn;

  // Get user email
  String? get userEmail => SupabaseAuthService.userEmail;

  // Get user ID
  String? get userId => SupabaseAuthService.userId;

  // Get user name
  String? get userName => SupabaseAuthService.userName;

  // Get user full name
  String? get userFullName => SupabaseAuthService.userFullName;

  // Get user display name (tries full name first, then just name, then email)
  String get userDisplayName {
    return userFullName ?? userName ?? userEmail ?? 'User';
  }

  // Update user profile
  Future<void> updateProfile(
      Map<String, dynamic> data, BuildContext context) async {
    try {
      isLoading.value = true;

      await SupabaseAuthService.updateProfile(data: data);
      showCustomSnackBar("Profile updated successfully!", context,
          isError: false);
    } catch (e) {
      showCustomSnackBar(SupabaseAuthService.getAuthErrorMessage(e), context);
    } finally {
      isLoading.value = false;
    }
  }
}
