import 'package:flutter/material.dart';

class StatusIndicator extends StatelessWidget {
  final bool isFatigued;
  final String estado;
  final String fecha;
  final double scoreFatiga;

  const StatusIndicator({
    super.key,
    required this.isFatigued,
    required this.estado,
    required this.fecha,
    required this.scoreFatiga,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isFatigued ? Colors.red.shade100 : Colors.green.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isFatigued ? Icons.warning_rounded : Icons.check_circle_rounded,
            color: isFatigued ? Colors.red : Colors.green,
            size: 28,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Estado: $estado',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isFatigued ? Colors.red.shade800 : Colors.green.shade800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Fecha: $fecha',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    'Score Fatiga: ',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  Text(
                    '${(scoreFatiga * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: scoreFatiga > 0.4 ? Colors.red : Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
