import 'package:fatigue_control/app/widgets/custom_background.dart';
import 'package:fl_chart/fl_chart.dart';
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

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isFatigued
                              ? Colors.red.shade100
                              : Colors.green.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isFatigued
                              ? Icons.warning_rounded
                              : Icons.check_circle_rounded,
                          color: isFatigued ? Colors.red : Colors.green,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Estado: $estado',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: isFatigued
                                    ? Colors.red.shade800
                                    : Colors.green.shade800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Fecha: ${data['fecha']?.toString() ?? data['date']?.toString() ?? 'N/A'}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  'Score Fatiga: ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Text(
                                  '${(scoreFatiga * 100).toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: scoreFatiga > 0.4
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
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
                  Container(
                    height: 200,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: BarChart(
                      BarChartData(
                        barGroups: [
                          BarChartGroupData(x: 0, barRods: [
                            BarChartRodData(toY: scoreFatiga * 100),
                          ]),
                          BarChartGroupData(x: 1, barRods: [
                            BarChartRodData(toY: probOjos * 100),
                          ]),
                          BarChartGroupData(x: 2, barRods: [
                            BarChartRodData(toY: inclinacion * 100),
                          ]),
                          BarChartGroupData(x: 3, barRods: [
                            BarChartRodData(toY: bostezos ? 100 : 0),
                          ]),
                        ],
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                switch (value.toInt()) {
                                  case 0:
                                    return const Text('Fatiga', style: TextStyle(fontSize: 10));
                                  case 1:
                                    return const Text('Ojos', style: TextStyle(fontSize: 10));
                                  case 2:
                                    return const Text('Cabeza', style: TextStyle(fontSize: 10));
                                  case 3:
                                    return const Text('Bostezo', style: TextStyle(fontSize: 10));
                                  default:
                                    return const Text('');
                                }
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(show: true, horizontalInterval: 20),
                        maxY: 100,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'Indicadores de Fatiga:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  
                  _buildIndicatorRow(
                    'Apertura de ojos',
                    probOjos.toDouble(),
                    Icons.remove_red_eye,
                    probOjos > 0.5 ? Colors.green : Colors.red,
                    description: '${(probOjos * 100).toStringAsFixed(0)}%',
                  ),
                  const SizedBox(height: 8),
                  _buildIndicatorRow(
                    'Inclinación de cabeza',
                    inclinacion.toDouble(),
                    Icons.face,
                    inclinacion < 0.4 ? Colors.green : Colors.orange,
                    description: '${(inclinacion * 100).toStringAsFixed(0)}%',
                    reversed: true,
                  ),
                  const SizedBox(height: 8),
                  _buildIndicatorRow(
                    'Bostezo detectado',
                    bostezos ? 1.0 : 0.0,
                    Icons.airline_seat_recline_normal,
                    bostezos ? Colors.red : Colors.grey,
                    description: bostezos ? 'Sí' : 'No',
                    showProgressBar: false,
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'Observaciones:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      data['observaciones']?.toString() ??
                          data['observations']?.toString() ??
                          'Sin observaciones.',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIndicatorRow(
    String title,
    double value,
    IconData icon,
    Color color, {
    required String description,
    bool showProgressBar = true,
    bool reversed = false,
  }) {
    final displayValue = reversed ? 1 - value : value;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 13,
                    )),
                if (showProgressBar) ...[
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: displayValue,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            description,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}
