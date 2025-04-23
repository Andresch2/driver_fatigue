import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/user_controller.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import '../services/user_database_service.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});
  final _nameCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  final _auth      = Get.find<AuthService>();
  final _userDb    = UserDatabaseService();

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: _nameCtrl,  decoration: const InputDecoration(labelText: 'Nombre')),
          TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
          TextField(controller: _passCtrl,  decoration: const InputDecoration(labelText: 'Contraseña'), obscureText: true),
          const SizedBox(height: 20),
          ElevatedButton(
            child: const Text('Registrar'),
            onPressed: () async {
              final name  = _nameCtrl.text.trim();
              final email = _emailCtrl.text.trim();
              final pass  = _passCtrl.text.trim();
              if (name.isEmpty || email.isEmpty || pass.isEmpty) {
                Get.snackbar('Error', 'Completa todos los campos');
                return;
              }
              final user = await _auth.register(email: email, password: pass, name: name);
              if (user == null) return;

              await _userDb.createProfile(userId: user.$id, name: name, email: email);

              Get.find<UserController>()
                .setUser(userId: user.$id, userName: name, userEmail: email);
              Get.offAllNamed(AppRoutes.home);
            },
          ),
          TextButton(
            child: const Text('Ya tienes cuenta? Inicia sesión'),
            onPressed: () => Get.toNamed(AppRoutes.login),
          ),
        ]),
      ),
    );
  }
}
