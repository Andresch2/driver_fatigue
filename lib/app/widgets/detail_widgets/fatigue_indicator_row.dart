import 'package:flutter/material.dart';

class FatigueIndicatorRow extends StatelessWidget {
  final String title;
  final double value;
  final IconData icon;
  final Color color;
  final String description;
  final bool showProgressBar;
  final bool reversed;

  const FatigueIndicatorRow({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.description,
    this.showProgressBar = true,
    this.reversed = false,
  });

  @override
  Widget build(BuildContext context) {
    final displayValue = reversed ? 1 - value : value;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                if (showProgressBar) ...[
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: displayValue,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(description, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
