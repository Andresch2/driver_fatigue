import 'package:appwrite/appwrite.dart';
import 'package:fatigue_control/app/constants/constants.dart';
import 'package:fatigue_control/app/controllers/analysis_controller.dart';
import 'package:fatigue_control/app/data/models/analysis_record.dart';
import 'package:fatigue_control/app/data/repositories/history_repository.dart';
import 'package:fatigue_control/app/routes/app_routes.dart';
import 'package:fatigue_control/app/services/appwrite_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../shared_widgets/custom_button.dart';

class SaveAnalysisButton extends StatelessWidget {
  final AnalysisRecord record;

  const SaveAnalysisButton({
    super.key,
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomButton(
        text: 'Guardar Análisis',
        icon: Icons.save,
        onPressed: () async {
          final analysisController = Get.find<AnalysisController>();
          final historyRepo = Get.find<HistoryRepository>();
          final dateStr = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
          final recordWithDate = record.copyWith(date: dateStr);
          await historyRepo.saveAnalysisOfflineFirst(recordWithDate);

          try {
            await Databases(client).createDocument(
              databaseId: AppwriteConstants.databaseId,
              collectionId: AppwriteConstants.reportsCollectionId,
              documentId: ID.unique(),
              data: recordWithDate.toCreateMap(),
            );
          } catch (_) {
          }

          analysisController.agregarAnalisis(recordWithDate);
          Get.snackbar('Guardado', 'Análisis guardado correctamente.');
          Get.offAllNamed(AppRoutes.home);
        },
      ),
    );
  }
}
