import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/tips_controller.dart';
import '../widgets/tips_widgets/card_widget.dart';
import '../widgets/tips_widgets/empty_widget.dart';
import '../widgets/tips_widgets/header_widget.dart';

class TipsPage extends StatelessWidget {
  final TipsController ctrl = Get.put(TipsController());

  TipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tips de Descanso')),
      body: Obx(() {
        final tips = ctrl.tipsVisibles;
        return Column(
          children: [
            const HeaderWidget(),
            Expanded(
              child: tips.isEmpty
                  ? const EmptyWidget()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: tips.length,
                      itemBuilder: (_, i) {
                        final tip = tips[i];
                        return CardWidget(
                          icon: tip.icon,
                          text: tip.text,
                          onMarkRead: () => ctrl.marcarComoLeido(tip.id),
                          onSkip:      () => ctrl.noMeInteresa(tip.id),
                        );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }
}
