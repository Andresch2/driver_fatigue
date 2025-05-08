import 'package:flutter/material.dart';

class ReportObservations extends StatelessWidget {
  final String observations;

  const ReportObservations({
    super.key,
    required this.observations,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Observaciones:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(
          observations.isNotEmpty ? observations : 'No se detectó rostro.',
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
