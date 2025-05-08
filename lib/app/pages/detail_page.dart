import 'package:fatigue_control/app/widgets/custom_background.dart';
import 'package:fatigue_control/app/widgets/detail_widgets/detail_chart.dart';
import 'package:fatigue_control/app/widgets/detail_widgets/fatigue_indicator_row.dart';
import 'package:fatigue_control/app/widgets/detail_widgets/observations_box.dart';
import 'package:fatigue_control/app/widgets/detail_widgets/status_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments as Map<String, dynamic>?;

    if (data == null || data.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalle del Análisis')),
        body: const Center(child: Text('No se encontró información')),
      );
    }

    final estado = data['estado']?.toString() ??
        data['status']?.toString() ??
        'N/A';
    final isFatigued = estado.toLowerCase().contains('fatigad');

    final probOjos = (data['probabilidad_ojos'] ??
            data['eye_probability'] ??
            1.0) as num;
    final bostezos = (data['bostezo_detectado'] == true) ||
        (data['yawn_detected'] == true);
    final inclinacion = (data['inclinacion_cabeza'] ??
            data['head_tilt'] ??
            0.0) as num;
    final scoreFatiga = (data['score_fatiga'] ??
            data['fatigue_score'] ??
            0.0) as num;

    final fecha = data['fecha']?.toString() ??
        data['date']?.toString() ??
        'N/A';
    final observaciones = data['observaciones']?.toString() ??
        data['observations']?.toString() ??
        'Sin observaciones.';

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del Análisis')),
      body: CustomBackground(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  StatusIndicator(
                    isFatigued: isFatigued,
                    estado: estado,
                    fecha: fecha,
                    scoreFatiga: scoreFatiga.toDouble(),
                  ),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  const Text(
                    'Gráfico:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DetailChart(
                    scoreFatiga: scoreFatiga.toDouble(),
                    probOjos: probOjos.toDouble(),
                    inclinacion: inclinacion.toDouble(),
                    bostezos: bostezos,
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'Indicadores de Fatiga:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  FatigueIndicatorRow(
                    title: 'Apertura de ojos',
                    value: probOjos.toDouble(),
                    icon: Icons.remove_red_eye,
                    color: probOjos > 0.5 ? Colors.green : Colors.red,
                    description: '${(probOjos * 100).toStringAsFixed(0)}%',
                  ),
                  const SizedBox(height: 8),
                  FatigueIndicatorRow(
                    title: 'Inclinación de cabeza',
                    value: inclinacion.toDouble(),
                    icon: Icons.face,
                    color: inclinacion < 0.4 ? Colors.green : Colors.orange,
                    description: '${(inclinacion * 100).toStringAsFixed(0)}%',
                    reversed: true,
                  ),
                  const SizedBox(height: 8),
                  FatigueIndicatorRow(
                    title: 'Bostezo detectado',
                    value: bostezos ? 1.0 : 0.0,
                    icon: Icons.airline_seat_recline_normal,
                    color: bostezos ? Colors.red : Colors.grey,
                    description: bostezos ? 'Sí' : 'No',
                    showProgressBar: false,
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'Observaciones:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  ObservationsBox(
                    observations: observaciones,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
