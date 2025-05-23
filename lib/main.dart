import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/controllers/analysis_controller.dart';
import 'app/controllers/auth_controller.dart';
import 'app/controllers/user_controller.dart';
import 'app/data/models/analysis_record.dart';
import 'app/data/models/user_model.dart';
import 'app/data/repositories/auth_repository.dart';
import 'app/data/repositories/history_repository.dart';
import 'app/data/repositories/user_repository.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/services/push_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(AnalysisRecordAdapter());
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<AnalysisRecord>('history');
  await Hive.openBox<UserModel>('userBox');

  await GetStorage.init();
  await Firebase.initializeApp();
  await PushService.init();

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