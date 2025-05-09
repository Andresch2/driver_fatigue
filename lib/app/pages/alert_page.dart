import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';

import '../data/models/analysis_record.dart';
import '../routes/app_routes.dart';
import '../widgets/shared_widgets/custom_button.dart';

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warning_amber_rounded, size: 100, color: Colors.white),
              const SizedBox(height: 20),
              Text(
                record.status,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Score de Fatiga: ${(record.fatigueScore * 100).toStringAsFixed(1)}%',
                style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'Por favor tome un descanso.\nPulse el botón si está consciente.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: "Estoy despierto",
                icon: Icons.check_circle_outline,
                onPressed: _stopAlert,
                backgroundColor: Colors.white,
                textColor: Colors.red.shade900,
                width: 220,
                isLoading: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
