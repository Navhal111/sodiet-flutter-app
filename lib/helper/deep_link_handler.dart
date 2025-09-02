import 'dart:async';
import 'dart:developer';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/route/app_routes.dart';

class DeepLinkHandler {
  static final _appLinks = AppLinks();
  static StreamSubscription<Uri>? _linkSubscription;

  /// Initialize deep link handling
  static Future<void> initialize() async {
    try {
      // Handle initial link when app is launched via deep link
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        log('Initial deep link: $initialUri');
        _handleDeepLink(initialUri);
      }

      // Listen for incoming links when app is already running
      _linkSubscription = _appLinks.uriLinkStream.listen(
        (uri) {
          log('Deep link received: $uri');
          _handleDeepLink(uri);
        },
        onError: (err) {
          log('Deep link error: $err');
        },
      );
    } catch (e) {
      log('Error initializing deep links: $e');
    }
  }

  /// Handle the deep link navigation
  static void _handleDeepLink(Uri uri) {
    log('Processing deep link: $uri');

    // Handle different deep link patterns
    switch (uri.scheme) {
      case 'sodiet':
        _handleCustomScheme(uri);
        break;
      case 'https':
        _handleHttpsLink(uri);
        break;
      default:
        log('Unknown scheme: ${uri.scheme}');
    }
  }

  /// Handle custom scheme deep links (sodiet://...)
  static void _handleCustomScheme(Uri uri) {
    final path = uri.path;
    final queryParams = uri.queryParameters;

    log('Custom scheme path: $path');
    log('Query parameters: $queryParams');

    // Handle password reset deep link
    _handlePasswordResetLink(queryParams);

    // switch (path) {
    //   case '/home':
    //   case '/dashboard':
    //     Get.offAllNamed(AppRoutes.homeScreen);
    //     break;
    //   case '/profile':
    //     Get.toNamed(AppRoutes.homeScreen);
    //     // Navigate to profile tab if you have tabs
    //     break;
    //   case '/plan':
    //     Get.toNamed(AppRoutes.planScreen);
    //     break;
    //   case '/recipes':
    //     Get.toNamed(AppRoutes.recipesScreen);
    //     break;
    //   case '/calendar':
    //     Get.toNamed(AppRoutes.calendarScreen);
    //     break;
    //   case '/optimization':
    //     Get.toNamed(AppRoutes.optimizationScreen);
    //     break;
    //   case '/onboarding':
    //     Get.offAllNamed(AppRoutes.splashScreen);
    //     break;
    //   default:
    //     // Default to home screen if path is not recognized
    //     Get.offAllNamed(AppRoutes.homeScreen);
    // }
  }

  /// Handle password reset deep link with query parameters
  static void _handlePasswordResetLink(Map<String, String> queryParams) {
    log('Handling password reset link with params: $queryParams');

    // Check if there's an error in the query parameters
    if (queryParams.containsKey('error')) {
      final error = queryParams['error'];
      final errorCode = queryParams['error_code'];
      final errorDescription = queryParams['error_description'];

      log('Password reset error: $error, code: $errorCode, description: $errorDescription');

      // Show error popup based on error type
      String errorMessage;
      String errorTitle = 'Password Reset Error';

      switch (errorCode) {
        case 'otp_expired':
          errorTitle = 'Link Expired';
          errorMessage =
              'This password reset link has expired. Please request a new one.';
          break;
        case 'access_denied':
          errorTitle = 'Access Denied';
          errorMessage =
              'This password reset link is invalid or has been used already.';
          break;
        default:
          errorMessage = errorDescription ??
              'An error occurred with the password reset link.';
      }

      // Show error popup
      Get.snackbar(
        errorTitle,
        errorMessage,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
        icon: const Icon(
          Icons.error_outline,
          color: Colors.white,
        ),
      );

      return;
    }

    // Check if there's a code parameter (successful case)
    if (queryParams.containsKey('code')) {
      final code = queryParams['code'];

      if (code != null && code.isNotEmpty) {
        log('Password reset code received: $code');

        // Navigate to reset password screen with the token
        Get.toNamed(AppRoutes.resetPasswordScreen, arguments: {'token': code});
      } else {
        // Show error for empty code
        Get.snackbar(
          'Invalid Link',
          'The password reset link is missing required information.',
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(12),
          borderRadius: 8,
        );
      }
    } else {
      // No code or error found
      Get.snackbar(
        'Invalid Link',
        'The password reset link is not valid.',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
      );
    }
  }

  /// Handle HTTPS deep links (https://sodiet.app/...)
  static void _handleHttpsLink(Uri uri) {
    if (uri.host == 'sodiet.app' || uri.host == 'www.sodiet.app') {
      final path = uri.path;
      final queryParams = uri.queryParameters;

      log('HTTPS path: $path');
      log('Query parameters: $queryParams');

      // switch (path) {
      //   case '/':
      //   case '/home':
      //     Get.offAllNamed(AppRoutes.homeScreen);
      //     break;
      //   case '/download':
      //     Get.offAllNamed(AppRoutes.splashScreen);
      //     break;
      //   case '/plan':
      //     Get.toNamed(AppRoutes.planScreen);
      //     break;
      //   case '/recipes':
      //     Get.toNamed(AppRoutes.recipesScreen);
      //     break;
      //   case '/calendar':
      //     Get.toNamed(AppRoutes.calendarScreen);
      //     break;
      //   case '/optimization':
      //     Get.toNamed(AppRoutes.optimizationScreen);
      //     break;
      //   default:
      //     Get.offAllNamed(AppRoutes.homeScreen);
      // }
    }
  }

  /// Dispose resources
  static void dispose() {
    _linkSubscription?.cancel();
  }
}
