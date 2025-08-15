import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sodiet/controller/home/homeController.dart';
import 'package:sodiet/controller/navigation/navigation_controller.dart';
import 'package:sodiet/controller/physicalActivity/physicalController.dart';
import 'package:sodiet/controller/plan/planController.dart';
import 'package:sodiet/controller/recipe/recipeController.dart';
import 'package:sodiet/controller/theme/themeController.dart';
import 'package:sodiet/controller/weight_log/weight_log_controller.dart';
import 'package:sodiet/controller/fat_log/fat_log_controller.dart';
import 'package:sodiet/controller/preference/preference_onboarding_controller.dart';
import 'package:sodiet/controller/course_correction/course_correction_controller.dart';

import '../api/api_client.dart';
import '../constant/appConstant.dart';
import '../controller/auth/authController.dart';
import '../controller/diet/dietController.dart';
import '../repo/authRepo.dart';

init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();

  Get.lazyPut(() => sharedPreferences);

  Get.lazyPut(
      () => ApiClient(
          appBaseUrl: AppConstants.BASE_URL, sharedPreferences: Get.find()),
      fenix: true);

// Data controllers
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()),
      fenix: true);
  Get.lazyPut(() => AuthController(authRepo: Get.find()), fenix: true);
  Get.lazyPut(() => DietController(authRepo: Get.find()), fenix: true);
  Get.lazyPut(() => PhysicalActivityController(authRepo: Get.find()),
      fenix: true);
  Get.lazyPut(() => PlanController(authRepo: Get.find()), fenix: true);
  Get.lazyPut(() => HomeController(authRepo: Get.find()), fenix: true);
  Get.lazyPut(() => RecipeController(authRepo: Get.find()), fenix: true);
  Get.lazyPut(() => WeightLogController(authRepo: Get.find()), fenix: true);
  Get.lazyPut(() => FatLogController(authRepo: Get.find()), fenix: true);
  Get.lazyPut(() => PreferenceOnboardingController(authRepo: Get.find()),
      fenix: true);
  Get.lazyPut(() => CourseCorrectionController(authRepo: Get.find()),
      fenix: true);

  // Navigation
  Get.put(NavigationController(), permanent: true);

  // Repositories
  Get.lazyPut(
      () => AuthRepo(sharedPreferences: Get.find(), apiClient: Get.find()),
      fenix: true);
}
