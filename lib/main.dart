import 'package:fatigue_control/app/controllers/analysis_controller.dart';
import 'package:fatigue_control/app/controllers/auth_controller.dart';
import 'package:fatigue_control/app/controllers/user_controller.dart';
import 'package:fatigue_control/app/data/repositories/auth_repository.dart';
import 'package:fatigue_control/app/routes/app_pages.dart';
import 'package:fatigue_control/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authRepo = AuthRepository();
  await authRepo.isLoggedIn();
  Get.put(authRepo, permanent: true);

  Get.put(AuthController(),       permanent: true);
  Get.put(UserController(),       permanent: true);
  Get.put(AnalysisController(),   permanent: true);

  final initial = authRepo.user.value != null
      ? AppRoutes.home
      : AppRoutes.login;

  runApp(MyApp(initialRoute: initial));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({ required this.initialRoute, super.key });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Control de Fatiga',
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
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
