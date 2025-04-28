import 'package:flutter/material.dart';

class StatusCard extends StatelessWidget {
  final String status;
  final String date;
  final String observations;
  final num fatigueScore;
  final VoidCallback onTap;

  const StatusCard({
    super.key,
    required this.status,
    required this.date,
    required this.observations,
    required this.fatigueScore,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isFatigued = status.toLowerCase().contains('fatigad');
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          isFatigued ? Icons.warning_amber_rounded : Icons.check_circle_rounded,
          color: isFatigued ? Colors.red : Colors.green,
        ),
        title: Text('Estado: $status'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fecha: $date'),
            Text('Fatigue score: ${fatigueScore.toStringAsFixed(2)}'),
            Text('Observaciones: $observations'),
          ],
        ),
      ),
    );
  }
}
