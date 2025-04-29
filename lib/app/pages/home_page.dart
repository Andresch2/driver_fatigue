import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/user_controller.dart';
import '../routes/app_routes.dart';
import '../widgets/custom_background.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Mi perfil',
            onPressed: () {
              final uid = userController.userId.value;
              if (uid.isNotEmpty) {
                Get.toNamed(AppRoutes.profile, arguments: uid);
              } else {
                Get.snackbar('Error', 'Usuario no identificado');
              }
            },
          ),
        ],
      ),
      body: CustomBackground(
        child: Center(
          child: Obx(() {
            final nombre = userController.nombre.value;
            if (nombre.isEmpty) {
              return const Text(
                'Bienvenido',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              );
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '¡Bienvenido,',
                  style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  nombre,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.person),
                  label: const Text('Ver mi perfil'),
                  onPressed: () {
                    final uid = userController.userId.value;
                    Get.toNamed(AppRoutes.profile, arguments: uid);
                  },
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
