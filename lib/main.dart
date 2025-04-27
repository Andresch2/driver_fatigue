import 'package:fatigue_control/app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/controllers/user_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(AuthController(),    permanent: true);
  Get.put(UserController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext c) {
    return GetMaterialApp(
      title: 'Control de Fatiga',
      initialRoute: AppRoutes.login,
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
    );
  }
}
