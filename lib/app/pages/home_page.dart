import 'package:fatigue_control/app/controllers/analysis_controller.dart';
import 'package:fatigue_control/app/data/models/analysis_record.dart';
import 'package:fatigue_control/app/routes/app_routes.dart';
import 'package:fatigue_control/app/widgets/custom_background.dart';
import 'package:fatigue_control/app/widgets/shimmer_loading.dart';
import 'package:fatigue_control/app/widgets/status_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AnalysisController ac = Get.find<AnalysisController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Análisis'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Get.toNamed(AppRoutes.profile),
          ),
        ],
      ),
      body: CustomBackground(
        child: Obx(() {
          final List<AnalysisRecord> list = ac.historial;
          return ShimmerLoading(
            isLoading: list.isEmpty,
            child: list.isEmpty
                ? ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: 5,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, __) => const ShimmerPlaceholder(height: 80),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: list.length,
                    itemBuilder: (ctx, i) {
                      final AnalysisRecord r = list[i];
                      return Dismissible(
                        key: ValueKey(r.id),
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
                                TextButton(onPressed: () => Get.back(result: false), child: const Text('No')),
                                TextButton(onPressed: () => Get.back(result: true), child: const Text('Sí')),
                              ],
                            ),
                          ) ?? false;
                        },
                        onDismissed: (_) {
                          ac.deleteAnalysis(r.id, i);
                          Get.snackbar('Eliminado', 'Análisis borrado correctamente');
                        },
                        child: StatusCard(
                          status:       r.status,
                          date:         r.date,
                          observations: r.observations,
                          fatigueScore: r.fatigueScore,
                          onTap: () => Get.toNamed(AppRoutes.detail, arguments: r.toMap()),
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
