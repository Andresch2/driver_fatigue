import 'dart:io';

import 'package:fatigue_control/app/data/models/analysis_record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;


class PdfService {
  Future<File> generateAnalysisHistoryPdf(List<AnalysisRecord> records) async {
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context ctx) => [
          pw.Header(level: 0, child: pw.Text('Historial de Análisis')),
          pw.Table.fromTextArray(
            headers: [
              'Fecha',
              'Estado',
              'Observaciones',
              'Ojo (%)',
              'Bostezo',
              'Inclinación',
              'Fatiga'
            ],
            data: records.map((r) => [
              r.date,
              r.status,
              r.observations,
              (r.eyeProbability * 100).toStringAsFixed(1),
              r.yawnDetected ? 'Sí' : 'No',
              r.headTilt.toStringAsFixed(1),
              r.fatigueScore.toStringAsFixed(1),
            ]).toList(),
          ),
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/analisis_historial_${DateTime.now().millisecondsSinceEpoch}.pdf');
    final bytes = await doc.save();
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<File> generateAnalysisDetailPdf(AnalysisRecord record) async {
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (pw.Context ctx) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Detalle de Análisis', style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 16),
            pw.Text('ID: ${record.id}'),
            pw.Text('Usuario: ${record.userId}'),
            pw.Text('Fecha: ${record.date}'),
            pw.Text('Estado: ${record.status}'),
            pw.SizedBox(height: 12),
            pw.Text('Observaciones:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(record.observations),
            pw.SizedBox(height: 12),
            pw.Text('Prob. Ojo: ${(record.eyeProbability * 100).toStringAsFixed(1)} %'),
            pw.Text('Bostezo Detectado: ${record.yawnDetected ? 'Sí' : 'No'}'),
            pw.Text('Inclinación Cabeza: ${record.headTilt.toStringAsFixed(1)}°'),
            pw.Text('Puntaje Fatiga: ${record.fatigueScore.toStringAsFixed(1)}'),
          ],
        ),
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/analisis_detalle_${record.id}_${DateTime.now().millisecondsSinceEpoch}.pdf');
    final bytes = await doc.save();
    await file.writeAsBytes(bytes);
    return file;
  }
}
