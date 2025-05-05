import 'package:flutter/material.dart';

class StatusCard extends StatelessWidget {
  final String status;
  final String date;
  final String observations;
  final double fatigueScore;
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
    final theme = Theme.of(context);
    final bool isFatigued = status.toLowerCase().contains('fatigad');
    final Color iconColor = isFatigued ? Colors.redAccent : Colors.green;
    final IconData iconData = isFatigued
        ? Icons.warning_amber_rounded
        : Icons.check_circle_rounded;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 20),
            child: child,
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        shadowColor: theme.colorScheme.secondary.withOpacity(0.3),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: iconColor.withOpacity(0.2),
                  child: Icon(iconData, size: 16, color: iconColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        status,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text('Fecha: $date', style: theme.textTheme.bodySmall),
                      Text(
                        'Fatigue score: ${fatigueScore.toStringAsFixed(2)}',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        observations,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
