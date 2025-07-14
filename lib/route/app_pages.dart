import 'package:get/get.dart';
import 'package:sodiet/view/screen/auth/forgot_password/forgot_password_screen.dart';
import 'package:sodiet/view/screen/auth/login_screen.dart';
import 'package:sodiet/view/screen/home/home_screen.dart';
import 'package:sodiet/view/screen/plan/plan_screen.dart';
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
  ];
}
