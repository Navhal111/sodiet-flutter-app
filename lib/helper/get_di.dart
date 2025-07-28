import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sodiet/controller/theme/themeController.dart';
import 'package:sodiet/controller/navigation/navigation_controller.dart';

init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()),
      fenix: true);

  // Navigation
  Get.lazyPut(() => NavigationController(), fenix: true);
}
