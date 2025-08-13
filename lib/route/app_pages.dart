import 'package:get/get.dart';
import 'package:sodiet/view/screen/auth/forgot_password/forgot_password_screen.dart';
import 'package:sodiet/view/screen/auth/login_screen.dart';
import 'package:sodiet/view/screen/course_correction/course_correction_screen.dart';
import 'package:sodiet/view/screen/fat_log/fat_log_manager_screen.dart';
import 'package:sodiet/view/screen/home/home_screen.dart';
import 'package:sodiet/view/screen/ingredients/add_ingredient_screen.dart';
import 'package:sodiet/view/screen/plan/plan_screen.dart';
import 'package:sodiet/view/screen/recipes/add_recipe_screen.dart';
import 'package:sodiet/view/screen/recipes/recipes_screen.dart';
import 'package:sodiet/view/screen/recipes/recipe_detail_screen.dart';
import 'package:sodiet/view/screen/optimization/optimization_screen.dart';
import 'package:sodiet/view/screen/meal_plan/meal_plan_screen.dart';
import 'package:sodiet/view/screen/preference_onboarding_screen.dart';
import 'package:sodiet/view/screen/weight_log/weight_log_manager_screen.dart';
import 'package:sodiet/view/screen/physical_activity/physical_activity_screen.dart';
import 'package:sodiet/view/screen/physical_activity/physical_activity_planner_screen.dart';
import 'package:sodiet/view/screen/integrations/integrations_screen.dart';
import 'package:sodiet/view/screen/diet_recall/diet_recall_screen.dart';
import 'package:sodiet/view/screen/splash/index.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splashScreen,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.loginScreen,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.forgotPasswordScreen,
      page: () => const ForgotPasswordScreen(),
    ),
    GetPage(
      name: AppRoutes.homeScreen,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: AppRoutes.planScreen,
      page: () => const PlanScreen(),
    ),
    GetPage(
      name: AppRoutes.recipesScreen,
      page: () => const RecipesScreen(),
    ),
    GetPage(
      name: AppRoutes.recipeDetailScreen,
      page: () => RecipeDetailScreen(
        recipe: Get.arguments as Map<String, dynamic>,
      ),
    ),
    GetPage(
      name: AppRoutes.optimizationScreen,
      page: () => const OptimizationScreen(),
    ),
    GetPage(
      name: AppRoutes.mealPlanScreen,
      page: () => const MealPlanScreen(),
    ),
    GetPage(
      name: AppRoutes.courseCorrectionScreen,
      page: () => const CourseCorrectionScreen(),
    ),
    GetPage(
      name: AppRoutes.preferenceOnboardingScreen,
      page: () => const PreferenceOnboardingScreen(),
    ),
    GetPage(
      name: AppRoutes.weightLogManagerScreen,
      page: () => const WeightLogManagerScreen(),
    ),
    GetPage(
      name: AppRoutes.fatLogManagerScreen,
      page: () => const FatLogManagerScreen(),
    ),
    GetPage(
      name: AppRoutes.physicalActivityScreen,
      page: () => const PhysicalActivityScreen(),
    ),
    GetPage(
      name: AppRoutes.physicalActivityPlannerScreen,
      page: () => const PhysicalActivityPlannerScreen(),
    ),
    GetPage(
      name: AppRoutes.integrationsScreen,
      page: () => const IntegrationsScreen(),
    ),
    GetPage(
      name: AppRoutes.dietRecallScreen,
      page: () => const DietRecallScreen(),
    ),
    GetPage(
      name: AppRoutes.addRecipeScreen,
      page: () => const AddRecipeScreen(),
    ),
    GetPage(
      name: AppRoutes.addIngredientScreen,
      page: () => const AddIngredientScreen(),
    ),
  ];
}
