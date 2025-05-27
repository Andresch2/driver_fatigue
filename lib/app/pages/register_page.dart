import 'package:appwrite/models.dart' show User;
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

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey   = GlobalKey<FormState>();
  final _nameCtrl  = TextEditingController();
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
                Icon(
                  Icons.shield_outlined,
                  size: 80,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 16),
                Text(
                  'Control de Fatiga',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Crea una cuenta nueva',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 40),

                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: _nameCtrl,
                            labelText: 'Nombre completo',
                            hintText: 'Juan Perez',
                            prefixIcon: Icons.person_outline,
                            errorMaxLines: 2,
                            validator: (value) {
                              if (!Validators.isNotEmpty(value ?? '')) {
                                return 'Por favor, rellena tu nombre completo';
                              }
                              if (!Validators.isValidName(value!)) {
                                return 'Sólo letras y espacios';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _emailCtrl,
                            labelText: 'Correo electrónico',
                            hintText: 'ejemplo@gmail.com',
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            errorMaxLines: 2,
                            validator: (value) {
                              if (!Validators.isNotEmpty(value ?? '')) {
                                return 'Por favor, rellena el correo';
                              }
                              if (!Validators.isValidEmail(value!)) {
                                return 'Introduce un correo válido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _passCtrl,
                            labelText: 'Contraseña',
                            prefixIcon: Icons.lock_outline,
                            obscureText: true,
                            errorMaxLines: 2,
                            validator: (value) {
                              if (!Validators.isNotEmpty(value ?? '')) {
                                return 'Por favor, rellena la contraseña';
                              }
                              if (!Validators.isValidPassword(value!)) {
                                return 'Al menos 8 caracteres y una mayúscula';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          Obx(
                            () => CustomButton(
                              text: 'Registrarse',
                              icon: Icons.person_add,
                              isLoading: _authC.isLoading.value,
                              onPressed: _handleRegister,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿Ya tienes cuenta?',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.login),
                      child: const Text(
                        'Inicia sesión',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
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
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name  = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final pass  = _passCtrl.text.trim();

    final ok = await _authC.register(email: email, password: pass, name: name);
    if (!ok) return;

    try {
      final User me = _authC.user.value!;
      await _userDb.registerUser(
        userId: me.$id,
        name: name,
        email: email,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo guardar perfil: $e',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade800,
        icon: const Icon(Icons.error_outline, color: Colors.red),
      );
      return;
    }

    final uc = Get.find<UserController>();
    uc.setUser(
      id: _authC.user.value!.$id,
      nombreUsuario: name,
      correo: email,
    );

    final ac = Get.find<AnalysisController>();
    ac.setUserId(_authC.user.value!.$id);

    Get.snackbar(
      '¡Listo!',
      'Registro exitoso',
      backgroundColor: Colors.green.shade50,
      colorText: Colors.green.shade800,
      icon: const Icon(Icons.check_circle, color: Colors.green),
    );
    Get.offAllNamed(AppRoutes.home);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }
}