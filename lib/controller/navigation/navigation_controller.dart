import 'package:get/get.dart';
import 'package:sodiet/route/app_routes.dart';

class NavigationController extends GetxController {
  static NavigationController get instance => Get.find();

  // Current active route
  RxString _currentRoute = AppRoutes.homeScreen.obs;
  String get currentRoute => _currentRoute.value;

  // Update current route
  void updateCurrentRoute(String route) {
    _currentRoute.value = route;
    update();
  }

  // Check if route is currently active
  bool isRouteActive(String route) {
    return _currentRoute.value == route;
  }

  // Navigation methods with route tracking
  void navigateToHome() {
    if (_currentRoute.value != AppRoutes.homeScreen) {
      Get.offNamed(AppRoutes.homeScreen);
      _currentRoute.value = AppRoutes.homeScreen;
      update();
    }
  }

  void navigateToPlan() {
    if (_currentRoute.value != AppRoutes.planScreen) {
      Get.offNamed(AppRoutes.planScreen);
      _currentRoute.value = AppRoutes.planScreen;
      update();
    }
  }

  void navigateToRecipes() {
    if (_currentRoute.value != AppRoutes.recipesScreen) {
      Get.offNamed(AppRoutes.recipesScreen);
      _currentRoute.value = AppRoutes.recipesScreen;
      update();
    }
  }

  void navigateToOptimization() {
    if (_currentRoute.value != AppRoutes.optimizationScreen) {
      Get.offNamed(AppRoutes.optimizationScreen);
      _currentRoute.value = AppRoutes.optimizationScreen;
      update();
    }
  }

  void navigateToCoursesCorrection() {
    if (_currentRoute.value != AppRoutes.courseCorrectionScreen) {
      Get.offNamed(AppRoutes.courseCorrectionScreen);
      _currentRoute.value = AppRoutes.courseCorrectionScreen;
      update();
    }
  }

  void navigateToPreferences() {
    if (_currentRoute.value != AppRoutes.preferenceOnboardingScreen) {
      Get.offNamed(AppRoutes.preferenceOnboardingScreen);
      _currentRoute.value = AppRoutes.preferenceOnboardingScreen;
      update();
    }
  }

  void navigateToMealPlan() {
    if (_currentRoute.value != AppRoutes.mealPlanScreen) {
      Get.offNamed(AppRoutes.mealPlanScreen);
      _currentRoute.value = AppRoutes.mealPlanScreen;
      update();
    }
  }

  void navigateToWeightLogManager() {
    if (_currentRoute.value != AppRoutes.weightLogManagerScreen) {
      Get.offNamed(AppRoutes.weightLogManagerScreen);
      _currentRoute.value = AppRoutes.weightLogManagerScreen;
      update();
    }
  }

  void navigateToPhysicalActivity() {
    if (_currentRoute.value != AppRoutes.physicalActivityScreen) {
      Get.offNamed(AppRoutes.physicalActivityScreen);
      _currentRoute.value = AppRoutes.physicalActivityScreen;
      update();
    }
  }

  void navigateToPhysicalActivityPlanner() {
    if (_currentRoute.value != AppRoutes.physicalActivityPlannerScreen) {
      Get.offNamed(AppRoutes.physicalActivityPlannerScreen);
      _currentRoute.value = AppRoutes.physicalActivityPlannerScreen;
      update();
    }
  }

  void navigateToIntegrations() {
    if (_currentRoute.value != AppRoutes.integrationsScreen) {
      Get.offNamed(AppRoutes.integrationsScreen);
      _currentRoute.value = AppRoutes.integrationsScreen;
      update();
    }
  }

  void navigateToDietRecall() {
    if (_currentRoute.value != AppRoutes.dietRecallScreen) {
      Get.offNamed(AppRoutes.dietRecallScreen);
      _currentRoute.value = AppRoutes.dietRecallScreen;
      update();
    }
  }

  // Helper method to get display name for route
  String getRouteDisplayName(String route) {
    switch (route) {
      case AppRoutes.homeScreen:
        return 'Dashboard';
      case AppRoutes.planScreen:
        return 'Plan';
      case AppRoutes.recipesScreen:
        return 'Recipes';
      case AppRoutes.optimizationScreen:
        return 'Diet Optimization';
      case AppRoutes.courseCorrectionScreen:
        return 'Course Correction';
      case AppRoutes.preferenceOnboardingScreen:
        return 'Preferences';
      case AppRoutes.mealPlanScreen:
        return 'Meal Plan';
      case AppRoutes.weightLogManagerScreen:
        return 'Weight Log Manager';
      case AppRoutes.physicalActivityScreen:
        return 'Physical Activity';
      case AppRoutes.physicalActivityPlannerScreen:
        return 'Physical Activity Planner';
      case AppRoutes.integrationsScreen:
        return 'Integrations';
      case AppRoutes.dietRecallScreen:
        return 'Diet Recall';
      default:
        return 'Unknown';
    }
  }
}
