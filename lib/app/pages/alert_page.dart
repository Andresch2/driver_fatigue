import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';

import '../data/models/analysis_record.dart';
import '../routes/app_routes.dart';
import '../widgets/alert_widgets/alert_content.dart';

class AlertPage extends StatefulWidget {
  const AlertPage({super.key});
  @override
  State<AlertPage> createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  final FlutterTts _tts = FlutterTts();
  late final AnalysisRecord record;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is AnalysisRecord) {
      record = args;
      _triggerAlert();
    } else {
      Get.snackbar('Error', 'Datos inválidos para alerta.');
      Get.offAllNamed(AppRoutes.home);
    }
  }

  Future<void> _triggerAlert() async {
    try {
      await _tts.setLanguage("es-ES");
      await _tts.setSpeechRate(0.5);
      await _tts.setPitch(1.0);

      String msg = "¡Atención! Se detectó fatiga. Por favor, tome un descanso.";
      if (record.fatigueScore > 0.6) msg += " Nivel de fatiga alto.";
      if (record.eyeProbability < 0.4) msg += " Sus ojos indican somnolencia.";
      if (record.yawnDetected) msg += " Se detectaron bostezos.";

      await _tts.speak(msg);

      if (await Vibration.hasVibrator()) {
        await Vibration.vibrate(
          pattern: record.fatigueScore > 0.6
              ? [500, 1000, 500, 1000, 500, 1000]
              : [500, 1000, 500, 1000],
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Error al generar alerta: $e');
    }
  }

  void _stopAlert() {
    _tts.stop();
    Vibration.cancel();
    Get.offAllNamed(
      AppRoutes.report,
      arguments: record.toMap(),
    );
  }

  @override
  void dispose() {
    _tts.stop();
    Vibration.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade900,
      appBar: AppBar(
        title: const Text('Alerta de Fatiga'),
        backgroundColor: Colors.red.shade900,
        automaticallyImplyLeading: false,
      ),
      body: AlertContent(
        record: record,
        onStop: _stopAlert,
      ),
    );
  }
}
