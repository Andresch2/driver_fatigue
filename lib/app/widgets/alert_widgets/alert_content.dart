import 'package:flutter/material.dart';

import '../../data/models/analysis_record.dart';
import '../shared_widgets/custom_button.dart';

class AlertContent extends StatelessWidget {
  final AnalysisRecord record;
  final VoidCallback onStop;

  const AlertContent({
    super.key,
    required this.record,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
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
              onPressed: onStop,
              backgroundColor: Colors.white,
              textColor: Colors.red.shade900,
              width: 220,
            ),
          ],
        ),
      ),
    );
  }
}
