import 'package:fatigue_control/app/pages/home_page.dart';
import 'package:fatigue_control/app/pages/login_page.dart';
import 'package:fatigue_control/app/pages/profile_page.dart';
import 'package:fatigue_control/app/pages/register_page.dart';
import 'package:fatigue_control/app/pages/scan_page.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.login,    page: () => LoginPage()),
    GetPage(name: AppRoutes.register, page: () => RegisterPage()),
    GetPage(name: AppRoutes.home,     page: () => HomePage()),
    GetPage(name: AppRoutes.profile, page: () => ProfilePage()),
    GetPage(name: AppRoutes.scan, page: () => ScanPage()),
  ];
}
