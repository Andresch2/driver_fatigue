import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/tips_controller.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<TipsController>();
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
            const SizedBox(height: 16),
            Text(
              '¡Has leído todos los tips!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Verlos de nuevo'),
              onPressed: () {
                ctrl.resetTips();
              },
            ),
          ],
        ),
      ),
    );
  }
}