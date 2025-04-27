import 'package:appwrite/models.dart' show User;
import 'package:fatigue_control/app/controllers/analysis_controller.dart';
import 'package:fatigue_control/app/controllers/auth_controller.dart';
import 'package:fatigue_control/app/controllers/user_controller.dart';
import 'package:fatigue_control/app/data/repositories/user_repository.dart';
import 'package:fatigue_control/app/routes/app_routes.dart';
import 'package:fatigue_control/app/utils/validators.dart';
import 'package:fatigue_control/app/widgets/custom_background.dart';
import 'package:fatigue_control/app/widgets/custom_button.dart';
import 'package:fatigue_control/app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});
  
  final _nameCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();

  final _authC   = Get.find<AuthController>();
  final _userDb  = UserRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
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
                Text('Crea una cuenta nueva', style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
                const SizedBox(height: 40),

                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: _nameCtrl,
                          labelText: 'Nombre completo',
                          hintText: 'Juan Pérez',
                          prefixIcon: Icons.person_outline,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _emailCtrl,
                          labelText: 'Correo electrónico',
                          hintText: 'ejemplo@email.com',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _passCtrl,
                          labelText: 'Contraseña',
                          prefixIcon: Icons.lock_outline,
                          obscureText: true,
                        ),
                        const SizedBox(height: 24),

                        Obx(() => CustomButton(
                          text: 'Registrarse',
                          icon: Icons.person_add,
                          isLoading: _authC.isLoading.value,
                          onPressed: _handleRegister,
                        )),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('¿Ya tienes cuenta?', style: TextStyle(color: Colors.grey.shade700)),
                    TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.login),
                      child: const Text('Inicia sesión', style: TextStyle(fontWeight: FontWeight.bold)),
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

  Future<void> _handleRegister() async {
    final name  = _nameCtrl .text.trim();
    final email = _emailCtrl.text.trim();
    final pass  = _passCtrl .text.trim();

    if (name.isEmpty || email.isEmpty || pass.isEmpty) {
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

    final ok = await _authC.register(email: email, password: pass, name: name);
    if (!ok) return;

    try {
      final User me = _authC.user.value!;
      await _userDb.registerUser(
        userId: me.$id,
        name: name,
        email: email,
        password: pass,
      );
    } catch (e) {
      Get.snackbar('Error', 'No se pudo guardar perfil: $e',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade800,
      );
      return;
    }

    final uc = Get.find<UserController>();
    uc.setUser(id: _authC.user.value!.$id, nombreUsuario: name, correo: email);

    final ac = Get.find<AnalysisController>();
    ac.setUserId(_authC.user.value!.$id);

    Get.snackbar('¡Listo!', 'Registro exitoso',
      backgroundColor: Colors.green.shade50,
      colorText: Colors.green.shade800,
      icon: const Icon(Icons.check_circle, color: Colors.green),
    );
    Get.offAllNamed(AppRoutes.home);
  }
}
