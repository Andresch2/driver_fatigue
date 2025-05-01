import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';

import '../routes/app_routes.dart';
import '../widgets/custom_button.dart';

class AlertPage extends StatefulWidget {
  const AlertPage({super.key});
  @override
  State<AlertPage> createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _triggerAlert();
  }

  Future<void> _triggerAlert() async {
    try {
      await _tts.setLanguage("es-ES");
      await _tts.setSpeechRate(0.5);
      await _tts.setPitch(1.0);

      final data = Get.arguments as Map<String, dynamic>? ?? {};
      final double score = (data['fatigue_score'] ?? data['score_fatiga'] ?? 0.0) as double;
      final double eyeP  = (data['eye_probability'] ?? data['probabilidad_ojos'] ?? 1.0) as double;
      final bool yawn    = data['yawn_detected'] == true || data['bostezo_detectado'] == true;

      String msg = "¡Atención! Se detectó fatiga. Por favor, tome un descanso.";
      if (score > 0.6) msg += " Nivel de fatiga alto.";
      if (eyeP < 0.4)   msg += " Sus ojos indican somnolencia.";
      if (yawn)         msg += " Se detectaron bostezos.";

      await _tts.speak(msg);

      if (await Vibration.hasVibrator()) {
        await Vibration.vibrate(
          pattern: score > 0.6
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
    Get.offAllNamed(AppRoutes.home);
  }

  @override
  void dispose() {
    _tts.stop();
    Vibration.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments as Map<String, dynamic>? ?? {};
    final String estado = data['status']?.toString() ?? 'Fatiga detectada';
    final double score  = (data['fatigue_score'] ?? data['score_fatiga'] ?? 0.0) as double;

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
                estado,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Score de Fatiga: ${(score * 100).toStringAsFixed(1)}%',
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
