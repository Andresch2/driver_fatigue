import 'package:fatigue_control/app/widgets/report_widgets/report_chart.dart';
import 'package:fatigue_control/app/widgets/report_widgets/report_indicators.dart';
import 'package:fatigue_control/app/widgets/report_widgets/report_observations.dart';
import 'package:fatigue_control/app/widgets/report_widgets/report_status.dart';
import 'package:fatigue_control/app/widgets/report_widgets/save_analysis_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/models/analysis_record.dart';
import '../widgets/shared_widgets/custom_background.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;

    if (args == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Informe de Fatiga')),
        body: const Center(child: Text('No hay datos para mostrar')),
      );
    }

    final record = AnalysisRecord.fromMap(args);

    return Scaffold(
      appBar: AppBar(title: const Text('Informe de Fatiga')),
      body: CustomBackground(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ReportStatus(
                          status: record.status,
                          fatigueScore: record.fatigueScore,
                        ),
                        const SizedBox(height: 10),
                        const Divider(),
                        const SizedBox(height: 10),
                        ReportIndicators(
                          eyeProbability: record.eyeProbability,
                          headTilt: record.headTilt,
                          yawnDetected: record.yawnDetected,
                        ),
                        const SizedBox(height: 10),
                        const Divider(),
                        const SizedBox(height: 10),
                        ReportObservations(observations: record.observations),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Gráfico:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                SizedBox(
                  height: 300,
                  child: ReportChart(fatigueScore: record.fatigueScore),
                ),
                const SizedBox(height: 20),
                SaveAnalysisButton(record: record),
              ],
            ),
          ),
        ),
      ),
    );
  }
}