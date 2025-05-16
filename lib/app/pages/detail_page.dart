import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:fatigue_control/app/widgets/detail_widgets/detail_chart.dart';
import 'package:fatigue_control/app/widgets/detail_widgets/fatigue_indicator_row.dart';
import 'package:fatigue_control/app/widgets/detail_widgets/observations_box.dart';
import 'package:fatigue_control/app/widgets/detail_widgets/status_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../widgets/shared_widgets/custom_background.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments as Map<String, dynamic>?;
    final chartKey = GlobalKey();

    if (data == null || data.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalle del Análisis')),
        body: const Center(child: Text('No se encontró información')),
      );
    }

    final estado = data['estado']?.toString() ?? data['status']?.toString() ?? 'N/A';
    final isFatigued = estado.toLowerCase().contains('fatigad');

    final probOjos = (data['probabilidad_ojos'] ?? data['eye_probability'] ?? 1.0) as num;
    final bostezos = (data['bostezo_detectado'] == true) || (data['yawn_detected'] == true);
    final inclinacion = (data['inclinacion_cabeza'] ?? data['head_tilt'] ?? 0.0) as num;
    final scoreFatiga = (data['score_fatiga'] ?? data['fatigue_score'] ?? 0.0) as num;

    final fecha = data['fecha']?.toString() ?? data['date']?.toString() ?? 'N/A';
    final observaciones = data['observaciones']?.toString() ?? data['observations']?.toString() ?? 'Sin observaciones.';

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
                  RepaintBoundary(
                    key: chartKey,
                    child: DetailChart(
                      scoreFatiga: scoreFatiga.toDouble(),
                      probOjos: probOjos.toDouble(),
                      inclinacion: inclinacion.toDouble(),
                      bostezos: bostezos,
                    ),
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

                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _exportarPDF(chartKey, data),
                    icon: Icon(Icons.picture_as_pdf),
                    label: Text('Exportar PDF'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _exportarPDF(GlobalKey chartKey, Map<String, dynamic> data) async {
    final estado = data['estado']?.toString() ?? data['status']?.toString() ?? 'N/A';
    final isFatigued = estado.toLowerCase().contains('fatigad');
    final probOjos = (data['probabilidad_ojos'] ?? data['eye_probability'] ?? 1.0) as num;
    final bostezos = (data['bostezo_detectado'] == true) || (data['yawn_detected'] == true);
    final inclinacion = (data['inclinacion_cabeza'] ?? data['head_tilt'] ?? 0.0) as num;
    final scoreFatiga = (data['score_fatiga'] ?? data['fatigue_score'] ?? 0.0) as num;
    final fecha = data['fecha']?.toString() ?? data['date']?.toString() ?? 'N/A';
    final observaciones = data['observaciones']?.toString() ?? data['observations']?.toString() ?? 'Sin observaciones.';

    final graficoBytes = await _capturarGrafico(chartKey);

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Reporte de Análisis de Fatiga', style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 16),
            pw.Text('Fecha: $fecha'),
            pw.Text('Estado: $estado'),
            pw.Text('Score de Fatiga: ${scoreFatiga.toStringAsFixed(2)}'),
            pw.SizedBox(height: 16),
            pw.Text('Indicadores:', style: pw.TextStyle(fontSize: 18)),
            pw.Bullet(text: 'Apertura de ojos: ${(probOjos * 100).toStringAsFixed(0)}%'),
            pw.Bullet(text: 'Inclinación de cabeza: ${(inclinacion * 100).toStringAsFixed(0)}%'),
            pw.Bullet(text: 'Bostezo detectado: ${bostezos ? "Sí" : "No"}'),
            pw.SizedBox(height: 16),
            if (graficoBytes != null)
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Gráfico:', style: pw.TextStyle(fontSize: 18)),
                  pw.SizedBox(height: 8),
                  pw.Image(pw.MemoryImage(graficoBytes), height: 200),
                ],
              ),
            pw.SizedBox(height: 16),
            pw.Text('Observaciones:', style: pw.TextStyle(fontSize: 18)),
            pw.Text(observaciones),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save(), name: 'reporte_fatiga_$fecha.pdf');
  }

  Future<Uint8List?> _capturarGrafico(GlobalKey key) async {
    final boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary != null) {
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    }
    return null;
  }
}
