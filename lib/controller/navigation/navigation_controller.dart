import 'package:get/get.dart';
import 'package:sodiet/route/app_routes.dart';

class NavigationController extends GetxController {
  static NavigationController get instance => Get.find();

  @override
  void onInit() {
    super.onInit();
    print('NavigationController: onInit() called');
  }

  @override
  void onReady() {
    super.onReady();
    print('NavigationController: onReady() called');
  }

  @override
  void onClose() {
    print(
        'NavigationController: onClose() called - Controller is being disposed!');
    super.onClose();
  }

  // Current active route
  RxString _currentRoute = AppRoutes.homeScreen.obs;
  String get currentRoute {
    print(
        'NavigationController: currentRoute getter called, returning: ${_currentRoute.value}');
    return _currentRoute.value;
  }

  // Update current route
  void updateCurrentRoute(String route) {
    print(
        'NavigationController: Updating route from ${_currentRoute.value} to $route');
    _currentRoute.value = route;
    _currentRoute.refresh();
    print('Check the values chnages ${_currentRoute.value}');
    update();
  }

  // Check if route is currently active
  bool isRouteActive(String route) {
    // Access .value to ensure Obx reactivity
    bool isActive = _currentRoute.value == route;
    print(
        'NavigationController: Checking if $route is active. Current: ${_currentRoute.value}, Result: $isActive');
    return isActive;
  }

  // Navigation methods with route tracking
  void navigateToHome() {
    if (_currentRoute.value != AppRoutes.homeScreen) {
      Get.offNamed(AppRoutes.homeScreen);
      // Route will be updated by BaseScreenLayout
    }
  }

  void navigateToPlan() {
    if (_currentRoute.value != AppRoutes.planScreen) {
      Get.offNamed(AppRoutes.planScreen);
      // Route will be updated by BaseScreenLayout
    }
  }

  void navigateToGeneratePlan() {
    if (_currentRoute.value != AppRoutes.generatePlanScreen) {
      Get.offNamed(AppRoutes.generatePlanScreen);
      // Route will be updated by BaseScreenLayout
    }
  }

  void navigateToRecipes() {
    if (_currentRoute.value != AppRoutes.recipesScreen) {
      Get.offNamed(AppRoutes.recipesScreen);
      // Route will be updated by BaseScreenLayout
    }
  }

  void navigateToAddRecipes() {
    if (_currentRoute.value != AppRoutes.addRecipeScreen) {
      Get.offNamed(AppRoutes.addRecipeScreen);
      // Route will be updated by BaseScreenLayout
    }
  }

  void navigateToAddIngredient() {
    if (_currentRoute.value != AppRoutes.addIngredientScreen) {
      Get.offNamed(AppRoutes.addIngredientScreen);
      // Route will be updated by BaseScreenLayout
    }
  }

  void navigateToOptimization() {
    if (_currentRoute.value != AppRoutes.optimizationScreen) {
      Get.offNamed(AppRoutes.optimizationScreen);
      // Route will be updated by BaseScreenLayout
    }
  }

  void navigateToCoursesCorrection() {
    if (_currentRoute.value != AppRoutes.courseCorrectionScreen) {
      Get.offNamed(AppRoutes.courseCorrectionScreen);
      // Route will be updated by BaseScreenLayout
    }
  }

  void navigateToCalendar() {
    if (_currentRoute.value != AppRoutes.calendarScreen) {
      Get.offNamed(AppRoutes.calendarScreen);
      // Route will be updated by BaseScreenLayout
    }
  }

  void navigateToPreferences() {
    if (_currentRoute.value != AppRoutes.preferenceOnboardingScreen) {
      Get.offNamed(AppRoutes.preferenceOnboardingScreen);
      // Route will be updated by BaseScreenLayout
    }
  }

  void navigateToMealPlan() {
    if (_currentRoute.value != AppRoutes.mealPlanScreen) {
      Get.offNamed(AppRoutes.mealPlanScreen);
      // Route will be updated by BaseScreenLayout
    }
  }

  void navigateToWeightLogManager() {
    if (_currentRoute.value != AppRoutes.weightLogManagerScreen) {
      Get.offNamed(AppRoutes.weightLogManagerScreen);
      // Route will be updated by BaseScreenLayout
    }
  }

  void navigateToFatLogManager() {
    if (_currentRoute.value != AppRoutes.fatLogManagerScreen) {
      Get.offNamed(AppRoutes.fatLogManagerScreen);
      // Route will be updated by BaseScreenLayout
    }
  }

  void navigateToPhysicalActivity() {
    if (_currentRoute.value != AppRoutes.physicalActivityScreen) {
      Get.offNamed(AppRoutes.physicalActivityScreen);
      // Route will be updated by BaseScreenLayout
    }
  }

  void navigateToPhysicalActivityPlanner() {
    if (_currentRoute.value != AppRoutes.physicalActivityPlannerScreen) {
      Get.offNamed(AppRoutes.physicalActivityPlannerScreen);
      // Route will be updated by BaseScreenLayout
    }
  }

  void navigateToIntegrations() {
    if (_currentRoute.value != AppRoutes.integrationsScreen) {
      Get.offNamed(AppRoutes.integrationsScreen);
      // Route will be updated by BaseScreenLayout
    }
  }

  void navigateToDietRecall() {
    if (_currentRoute.value != AppRoutes.dietRecallScreen) {
      Get.offNamed(AppRoutes.dietRecallScreen);
      // Route will be updated by BaseScreenLayout
    }
  }

  // Helper method to get display name for route
  String getRouteDisplayName(String route) {
    switch (route) {
      case AppRoutes.homeScreen:
        return 'Dashboard';
      case AppRoutes.planScreen:
        return 'Plan';
      case AppRoutes.generatePlanScreen:
        return 'Generate Plan';
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
