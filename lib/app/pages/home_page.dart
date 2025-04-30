import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/analysis_controller.dart';
import '../controllers/user_controller.dart';
import '../data/models/analysis_record.dart';
import '../routes/app_routes.dart';
import '../widgets/custom_background.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/status_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final analysisController = Get.find<AnalysisController>();
    final userController     = Get.find<UserController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Análisis'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
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
        child: Obx(() {
          final List<AnalysisRecord> historial = analysisController.historial;
          final bool isLoading = historial.isEmpty;

          return ShimmerLoading(
            isLoading: isLoading,
            child: isLoading
                ? ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: 5,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, __) => const ShimmerPlaceholder(height: 80),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: historial.length,
                    itemBuilder: (context, index) {
                      final record = historial[index];
                      return Dismissible(
                        key: ValueKey(record.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (_) async {
                          return await Get.dialog<bool>(
                            AlertDialog(
                              title: const Text('Confirmar'),
                              content: const Text('¿Eliminar este análisis?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Get.back(result: false),
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () => Get.back(result: true),
                                  child: const Text('Sí'),
                                ),
                              ],
                            ),
                          ) ?? false;
                        },
                        onDismissed: (_) {
                          analysisController.deleteAnalysis(record.id, index);
                          Get.snackbar('Eliminado', 'Análisis borrado correctamente');
                        },
                        child: StatusCard(
                          status:       record.status,
                          date:         record.date,
                          observations: record.observations,
                          fatigueScore: record.fatigueScore,
                          onTap: () => Get.toNamed(AppRoutes.detail, arguments: record.toMap()),
                        ),
                      );
                    },
                  ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Nuevo análisis'),
        onPressed: () => Get.toNamed(AppRoutes.scan),
      ),
    );
  }
}
