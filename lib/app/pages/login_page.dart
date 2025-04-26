import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/user_controller.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import '../services/user_database_service.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  final _auth      = Get.find<AuthService>();
  final _userDb    = UserDatabaseService();

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
          TextField(controller: _passCtrl,  decoration: const InputDecoration(labelText: 'Contraseña'), obscureText: true),
          const SizedBox(height: 20),
          ElevatedButton(
            child: const Text('Iniciar sesión'),
            onPressed: () async {
              final email = _emailCtrl.text.trim();
              final pass  = _passCtrl.text.trim();
              if (email.isEmpty || pass.isEmpty) {
                Get.snackbar('Error', 'Completa todos los campos');
                return;
              }
              final ok = await _auth.login(email: email, password: pass);
              if (!ok) return;
              final me = _auth.user.value;
              if (me == null) return;

              final profile = await _userDb.getProfile(me.$id);
              if (profile != null) {
                Get.find<UserController>()
                  .setUser(userId: me.$id, userName: profile['name'], userEmail: profile['email']);
              }
              Get.offAllNamed(AppRoutes.home);
            },
          ),
          TextButton(
            child: const Text('Crear nueva cuenta'),
            onPressed: () => Get.toNamed(AppRoutes.register),
          ),
        ]),
      ),
    );
  }
}
