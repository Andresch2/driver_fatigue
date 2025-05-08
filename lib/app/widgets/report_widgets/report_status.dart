import 'package:flutter/material.dart';

class ReportStatus extends StatelessWidget {
  final String status;
  final double fatigueScore;

  const ReportStatus({
    super.key,
    required this.status,
    required this.fatigueScore,
  });

  @override
  Widget build(BuildContext context) {
    final isFatigued = status.toLowerCase().contains('fatigad');
    final scorePct = (fatigueScore * 100).toStringAsFixed(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estado: $status',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isFatigued ? Colors.red.shade800 : Colors.green.shade800,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Score de Fatiga: $scorePct%',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: fatigueScore > 0.4 ? Colors.red : Colors.green,
          ),
        ),
      ],
    );
  }
}
