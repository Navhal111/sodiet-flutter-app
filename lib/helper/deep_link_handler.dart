import 'dart:async';
import 'dart:developer';
import 'package:app_links/app_links.dart';
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

    switch (path) {
      case '/home':
      case '/dashboard':
        Get.offAllNamed(AppRoutes.homeScreen);
        break;
      case '/profile':
        Get.toNamed(AppRoutes.homeScreen);
        // Navigate to profile tab if you have tabs
        break;
      case '/plan':
        Get.toNamed(AppRoutes.planScreen);
        break;
      case '/recipes':
        Get.toNamed(AppRoutes.recipesScreen);
        break;
      case '/calendar':
        Get.toNamed(AppRoutes.calendarScreen);
        break;
      case '/optimization':
        Get.toNamed(AppRoutes.optimizationScreen);
        break;
      case '/onboarding':
        Get.offAllNamed(AppRoutes.splashScreen);
        break;
      default:
        // Default to home screen if path is not recognized
        Get.offAllNamed(AppRoutes.homeScreen);
    }
  }

  /// Handle HTTPS deep links (https://sodiet.app/...)
  static void _handleHttpsLink(Uri uri) {
    if (uri.host == 'sodiet.app' || uri.host == 'www.sodiet.app') {
      final path = uri.path;
      final queryParams = uri.queryParameters;

      log('HTTPS path: $path');
      log('Query parameters: $queryParams');

      switch (path) {
        case '/':
        case '/home':
          Get.offAllNamed(AppRoutes.homeScreen);
          break;
        case '/download':
          Get.offAllNamed(AppRoutes.splashScreen);
          break;
        case '/plan':
          Get.toNamed(AppRoutes.planScreen);
          break;
        case '/recipes':
          Get.toNamed(AppRoutes.recipesScreen);
          break;
        case '/calendar':
          Get.toNamed(AppRoutes.calendarScreen);
          break;
        case '/optimization':
          Get.toNamed(AppRoutes.optimizationScreen);
          break;
        default:
          Get.offAllNamed(AppRoutes.homeScreen);
      }
    }
  }

  /// Dispose resources
  static void dispose() {
    _linkSubscription?.cancel();
  }
}
