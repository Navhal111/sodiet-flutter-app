import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sodiet/constant/appConstant.dart';
import 'package:sodiet/route/app_pages.dart';
import 'package:sodiet/theme/dark.dart';
import 'package:sodiet/theme/light.dart';
import 'helper/get_di.dart' as di;
import 'controller/theme/themeController.dart';
import 'route/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // checkes code my side

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    initializeDefaultFromAndroidResource();

    super.initState();
  }

  Future<void> initializeDefaultFromAndroidResource() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top],
    );
    // checkes code my side
    return GetBuilder<ThemeController>(builder: (themeController) {
      return GetMaterialApp(
        // checkes code my side
        title: AppConstants.APP_NAME,
        debugShowCheckedModeBanner: false,
        // checkes code my side
        theme: themeController.darkTheme ? dark : light,
        getPages: AppPages.pages,
        // checkes code my side
        defaultTransition: Transition.rightToLeft,
        initialRoute: AppRoutes.splashScreen,
        // initialRoute: AppRoutes.dashboard,
      );
    });
  }
}
