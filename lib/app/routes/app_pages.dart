import 'package:fatigue_control/app/pages/alert_page.dart';
import 'package:fatigue_control/app/pages/detail_page.dart';
import 'package:fatigue_control/app/pages/home_page.dart';
import 'package:fatigue_control/app/pages/login_page.dart';
import 'package:fatigue_control/app/pages/profile_page.dart';
import 'package:fatigue_control/app/pages/register_page.dart';
import 'package:fatigue_control/app/pages/report_page.dart';
import 'package:fatigue_control/app/pages/scan_page.dart';
import 'package:fatigue_control/app/pages/splash_page.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.login,    page: () => LoginPage()),
    GetPage(name: AppRoutes.register, page: () => RegisterPage()),
    GetPage(name: AppRoutes.home,     page: () => HomePage()),
    GetPage(name: AppRoutes.profile, page: () => ProfilePage()),
    GetPage(name: AppRoutes.scan, page: () => ScanPage()),
    GetPage(name: AppRoutes.report, page: () => ReportPage()),
    GetPage(name: AppRoutes.detail, page: () => DetailPage()),
    GetPage(name: AppRoutes.alert, page: () => AlertPage()),
    GetPage(name: AppRoutes.splash, page: () => SplashPage()),
  ];
}
