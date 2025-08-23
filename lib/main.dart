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
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  await Supabase.initialize(
    url: "https://fqzgqbfpwhofywgdroye.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZxemdxYmZwd2hvZnl3Z2Ryb3llIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDY1MDc2NTYsImV4cCI6MjA2MjA4MzY1Nn0.wsrYPeZalAeEi4vnVTtDwzV8-lG7Kt99GGv4AZy2Duc",
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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

    return GetBuilder<ThemeController>(builder: (themeController) {
      return GetMaterialApp(
        title: AppConstants.APP_NAME,
        debugShowCheckedModeBanner: false,
        theme: themeController.darkTheme ? dark : light,
        getPages: AppPages.pages,
        defaultTransition: Transition.rightToLeft,
        initialRoute: AppRoutes.splashScreen,
        // initialRoute: AppRoutes.dashboard,
      );
    });
  }
}
