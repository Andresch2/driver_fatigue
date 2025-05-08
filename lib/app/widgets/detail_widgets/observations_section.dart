import 'package:flutter/material.dart';

class ObservationsSection extends StatelessWidget {
  final String observations;

  const ObservationsSection({
    super.key,
    required this.observations,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        observations,
        style: const TextStyle(fontSize: 15),
      ),
    );
  }
}