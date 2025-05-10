import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onMarkRead;
  final VoidCallback onSkip;

  const CardWidget({
    super.key,
    required this.icon,
    required this.text,
    required this.onMarkRead,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Row(
          children: [
            Icon(icon, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (opt) {
                if (opt == 'leido') {
                  onMarkRead();
                } else {
                  onSkip();
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'leido', child: Text('Marcar como leído')),
                PopupMenuItem(value: 'no',    child: Text('No me interesa')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}