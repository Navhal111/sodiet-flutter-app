import 'package:get/get.dart';
import 'package:sodiet/view/screen/auth/forgot_password/forgot_password_screen.dart';
import 'package:sodiet/view/screen/auth/login_screen.dart';
import 'package:sodiet/view/screen/course_correction/course_correction_screen.dart';
import 'package:sodiet/view/screen/home/home_screen.dart';
import 'package:sodiet/view/screen/plan/plan_screen.dart';
import 'package:sodiet/view/screen/recipes/recipes_screen.dart';
import 'package:sodiet/view/screen/recipes/recipe_detail_screen.dart';
import 'package:sodiet/view/screen/optimization/optimization_screen.dart';
import 'package:sodiet/view/screen/meal_plan/meal_plan_screen.dart';
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
  ];
}
