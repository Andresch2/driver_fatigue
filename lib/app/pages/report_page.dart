import 'package:appwrite/appwrite.dart';
import 'package:fatigue_control/app/constants/constants.dart';
import 'package:fatigue_control/app/data/models/analysis_record.dart';
import 'package:fatigue_control/app/data/repositories/history_repository.dart';
import 'package:fatigue_control/app/routes/app_routes.dart';
import 'package:fatigue_control/app/services/appwrite_client.dart';
import 'package:fatigue_control/app/widgets/custom_background.dart';
import 'package:fatigue_control/app/widgets/custom_button.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/analysis_controller.dart';
import '../controllers/user_controller.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final analysisController = Get.find<AnalysisController>();
    final userController     = Get.find<UserController>();
    final args = Get.arguments as Map<String, dynamic>?;

    if (args == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Informe de Fatiga')),
        body: const Center(child: Text('No hay datos para mostrar')),
      );
    }

    final record = AnalysisRecord.fromMap(args);

    final dateStr = DateFormat('yyyy-MM-dd HH:mm:ss')
        .format(DateTime.now());

    final scorePct = (record.fatigueScore * 100).toStringAsFixed(1);

    return Scaffold(
      appBar: AppBar(title: const Text('Informe de Fatiga')),
      body: CustomBackground(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estado: ${record.status}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: record.status.toLowerCase().contains('fatigad')
                              ? Colors.red.shade800
                              : Colors.green.shade800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Score de Fatiga: $scorePct%',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: record.fatigueScore > 0.4
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
                      ExpansionTile(
                        leading: Icon(Icons.analytics_outlined, color: Theme.of(context).colorScheme.primary),
                        title: Text(
                          'Indicadores de fatiga',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        children: [
                          ListTile(
                            leading: const Icon(Icons.remove_red_eye),
                            title: const Text('Apertura de ojos'),
                            trailing: Text('${(record.eyeProbability * 100).toStringAsFixed(0)}%'),
                          ),
                          ListTile(
                            leading: const Icon(Icons.face),
                            title: const Text('Inclinación de cabeza'),
                            trailing: Text('${(record.headTilt * 100).toStringAsFixed(0)}%'),
                          ),
                          ListTile(
                            leading: const Icon(Icons.airline_seat_recline_normal),
                            title: const Text('Bostezo detectado'),
                            trailing: Text(record.yawnDetected ? 'Sí' : 'No'),
                          ),
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 10),
                      const Text('Observaciones:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        record.observations.isNotEmpty
                          ? record.observations
                          : 'No se detectó rostro.',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Text('Gráfico:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              Expanded(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: BarChart(
                      BarChartData(
                        barGroups: [
                          BarChartGroupData(x: 0, barRods: [
                            BarChartRodData(toY: record.fatigueScore * 100),
                          ]),
                        ],
                        titlesData: FlTitlesData(
                          leftTitles:  AxisTitles(sideTitles: SideTitles(showTitles: true)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (_, __) => const Text('Fatiga %', style: TextStyle(fontSize: 12)),
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Center(
                child: CustomButton(
                  text: 'Guardar Análisis',
                  icon: Icons.save,
                  onPressed: () async {
                    try {
                      await Databases(client).createDocument(
                        databaseId:   AppwriteConstants.databaseId,
                        collectionId: AppwriteConstants.reportsCollectionId,
                        documentId:   ID.unique(),
                        data:         record.toCreateMap(),
                      );

                      final histDoc = await HistoryRepository().saveToHistory(
                        userId:         record.userId,
                        status:         record.status,
                        date:           dateStr,
                        observations:   record.observations,
                        eyeProbability: record.eyeProbability,
                        yawnDetected:   record.yawnDetected,
                        headTilt:       record.headTilt,
                        fatigueScore:   record.fatigueScore,
                      );

                      final newMap = {
                        r'$id': histDoc.$id,
                        ...record.toCreateMap(),
                      };
                      final newRecord = AnalysisRecord.fromMap(newMap);
                      analysisController.agregarAnalisis(newRecord);

                      Get.snackbar('Guardado', 'Análisis guardado correctamente.');
                      Get.offAllNamed(AppRoutes.home);
                    } catch (e) {
                      Get.snackbar('Error', 'No se pudo guardar en Appwrite: $e');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
