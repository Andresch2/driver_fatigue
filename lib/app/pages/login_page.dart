import 'package:appwrite/models.dart' show Document, User;
import 'package:fatigue_control/app/controllers/analysis_controller.dart';
import 'package:fatigue_control/app/controllers/auth_controller.dart';
import 'package:fatigue_control/app/controllers/user_controller.dart';
import 'package:fatigue_control/app/data/repositories/user_repository.dart';
import 'package:fatigue_control/app/routes/app_routes.dart';
import 'package:fatigue_control/app/utils/validators.dart';
import 'package:fatigue_control/app/widgets/backgrounds/auth_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/shared_widgets/custom_button.dart';
import '../widgets/shared_widgets/custom_text_field.dart';


class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();

  final _authC  = Get.find<AuthController>();
  final _userDb = UserRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Icon(Icons.shield_outlined, size: 80, color: Theme.of(context).primaryColor),
                const SizedBox(height: 16),
                Text('Control de Fatiga',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)
                ),
                const SizedBox(height: 8),
                Text('Inicia sesión para continuar',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600)
                ),
                const SizedBox(height: 40),

                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: _emailCtrl,
                          labelText: 'Correo electrónico',
                          hintText: 'ejemplo@email.com',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: _passCtrl,
                          labelText: 'Contraseña',
                          prefixIcon: Icons.lock_outline,
                          obscureText: true,
                        ),
                        const SizedBox(height: 24),
                        Obx(() => CustomButton(
                          text: 'Iniciar sesión',
                          icon: Icons.login,
                          isLoading: _authC.isLoading.value,
                          onPressed: _handleLogin,
                        )),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('¿No tienes cuenta?', style: TextStyle(color: Colors.grey.shade700)),
                    TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.register),
                      child: const Text('Regístrate', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    final email = _emailCtrl.text.trim();
    final pass  = _passCtrl.text.trim();
    
    if (email.isEmpty || pass.isEmpty) {
      Get.snackbar('Error', 'Completa todos los campos',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade800,
        icon: const Icon(Icons.error_outline, color: Colors.red),
      );
      return;
    }
    if (!Validators.isValidEmail(email)) {
      Get.snackbar('Error', 'Correo inválido',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade800,
        icon: const Icon(Icons.error_outline, color: Colors.red),
      );
      return;
    }

    final success = await _authC.login(email: email, password: pass);
    if (!success) return;

    final User? me = _authC.user.value;
    if (me == null) {
      Get.snackbar('Error', 'No se pudo obtener tu usuario',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade800,
      );
      return;
    }

    try {

      final Document? doc = await _userDb.getUserById(me.$id);
      if (doc != null) {
        final uc = Get.find<UserController>();
        uc.setUser(
          id: doc.$id,
          nombreUsuario: doc.data['name'],
          correo: doc.data['email'],
        );
      } else {
        Get.snackbar('Aviso', 'Usuario sin perfil, continúa');
      }

      final ac = Get.find<AnalysisController>();
      ac.setUserId(me.$id);

      Get.snackbar('¡Bienvenido!', 'Has iniciado sesión con éxito',
        backgroundColor: Colors.green.shade50,
        colorText: Colors.green.shade800,
        icon: const Icon(Icons.check_circle, color: Colors.green),
      );
      Get.offAllNamed(AppRoutes.home);

    } catch (e) {
      Get.snackbar('Error', 'No se pudo cargar perfil: $e',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade800,
      );
    }
  }
}
