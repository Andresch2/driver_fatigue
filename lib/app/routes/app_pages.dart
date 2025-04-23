import 'package:get/get.dart';

import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';
import '../routes/app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.login,    page: () => LoginPage()),
    GetPage(name: AppRoutes.register, page: () => RegisterPage()),
    GetPage(name: AppRoutes.home,     page: () => HomePage()),
  ];
}
