import 'package:flutter/material.dart';

class ReportIndicators extends StatelessWidget {
  final double eyeProbability;
  final double headTilt;
  final bool yawnDetected;

  const ReportIndicators({
    super.key,
    required this.eyeProbability,
    required this.headTilt,
    required this.yawnDetected,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(Icons.analytics_outlined, color: Theme.of(context).colorScheme.primary),
      title: Text(
        'Indicadores de fatiga',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      children: [
        ListTile(
          leading: const Icon(Icons.remove_red_eye),
          title: const Text('Apertura de ojos'),
          trailing: Text('${(eyeProbability * 100).toStringAsFixed(0)}%'),
        ),
        ListTile(
          leading: const Icon(Icons.face),
          title: const Text('Inclinación de cabeza'),
          trailing: Text('${(headTilt * 100).toStringAsFixed(0)}%'),
        ),
        ListTile(
          leading: const Icon(Icons.airline_seat_recline_normal),
          title: const Text('Bostezo detectado'),
          trailing: Text(yawnDetected ? 'Sí' : 'No'),
        ),
      ],
    );
  }
}
