import 'package:appwrite/appwrite.dart';
import 'package:fatigue_control/app/constants/constants.dart';
import 'package:fatigue_control/app/controllers/analysis_controller.dart';
import 'package:fatigue_control/app/data/models/analysis_record.dart';
import 'package:fatigue_control/app/data/repositories/history_repository.dart';
import 'package:fatigue_control/app/routes/app_routes.dart';
import 'package:fatigue_control/app/services/appwrite_client.dart';
import 'package:fatigue_control/app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


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
          final dateStr = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

          try {
            await Databases(client).createDocument(
              databaseId: AppwriteConstants.databaseId,
              collectionId: AppwriteConstants.reportsCollectionId,
              documentId: ID.unique(),
              data: record.toCreateMap(),
            );

            final histDoc = await HistoryRepository().saveToHistory(
              userId: record.userId,
              status: record.status,
              date: dateStr,
              observations: record.observations,
              eyeProbability: record.eyeProbability,
              yawnDetected: record.yawnDetected,
              headTilt: record.headTilt,
              fatigueScore: record.fatigueScore,
            );

            final newMap = {
              r'$id': histDoc.$id,
              ...record.toCreateMap(),
            };
            final newRecord = AnalysisRecord.fromMap(newMap);
            analysisController.agregarAnalisis(newRecord);

            Get.snackbar('Guardado', 'Análisis guardado correctamente.');
            Get.offAllNamed(AppRoutes.home);
          } catch (e) {
            Get.snackbar('Error', 'No se pudo guardar en Appwrite: $e');
          }
        },
      ),
    );
  }
}
