import 'package:fatigue_control/app/controllers/tips_controller.dart';
import 'package:fatigue_control/app/widgets/backgrounds/tips_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/tips_widgets/card_widget.dart';
import '../widgets/tips_widgets/empty_widget.dart';
import '../widgets/tips_widgets/header_widget.dart';

class TipsPage extends StatelessWidget {
  final TipsController ctrl = Get.put(TipsController());

  TipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tips',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: TipsBackground(
        child: Column(
          children: [
            const HeaderWidget(title: 'Como combatir la fatiga'),
            Expanded(
              child: Obx(() {
                if (ctrl.tipsVisibles.isEmpty) {
                  return const EmptyWidget();
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: ctrl.tipsVisibles.length,
                  itemBuilder: (_, i) {
                    final tip = ctrl.tipsVisibles[i];
                    if (tip.title == "Consejo final") {
                      return const SizedBox.shrink();
                    }
                    return CardWidget(
                      imagePath: tip.imagePath,
                      text: tip.text,
                      title: tip.title,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}