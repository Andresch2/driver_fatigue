import 'package:fatigue_control/app/controllers/analysis_controller.dart';
import 'package:fatigue_control/app/controllers/auth_controller.dart';
import 'package:fatigue_control/app/controllers/user_controller.dart';
import 'package:fatigue_control/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final AuthController _authC = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 1));

    if (_authC.hasLocalSession) {
      final uc = Get.find<UserController>();
      uc.setUser(
        id:             _authC.storedUserId,
        nombreUsuario:  _authC.storedUserName,
        correo:         _authC.storedUserEmail,
      );
      final ac = Get.find<AnalysisController>();
      ac.setUserId(_authC.storedUserId);

      Get.offAllNamed(AppRoutes.home);
      return;
    }

    final loggedIn = await _authC.checkAuth();
    if (!loggedIn) {
      Get.offAllNamed(AppRoutes.login);
      return;
    }


    final hasProfile = await _authC.checkUserProfileExists();
    if (hasProfile) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      await _authC.logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
