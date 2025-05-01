import 'package:fatigue_control/app/controllers/analysis_controller.dart';
import 'package:fatigue_control/app/controllers/auth_controller.dart';
import 'package:fatigue_control/app/controllers/user_controller.dart';
import 'package:fatigue_control/app/data/repositories/auth_repository.dart';
import 'package:fatigue_control/app/data/repositories/history_repository.dart';
import 'package:fatigue_control/app/data/repositories/user_repository.dart';
import 'package:fatigue_control/app/routes/app_pages.dart';
import 'package:fatigue_control/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put<AuthRepository>(AuthRepository(), permanent: true);
  Get.put<HistoryRepository>(HistoryRepository(), permanent: true);
  Get.put<UserRepository>(UserRepository(), permanent: true);

  Get.put<AuthController>(AuthController(), permanent: true);
  Get.put<UserController>(UserController(), permanent: true);
  Get.put<AnalysisController>(AnalysisController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Control de Fatiga',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      defaultTransition: Transition.fadeIn,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
        ),
      ),
    );
  }
}
