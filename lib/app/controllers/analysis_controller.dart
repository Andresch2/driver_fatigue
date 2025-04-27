import 'package:get/get.dart';

import '../data/models/analysis_record.dart';
import '../data/repositories/history_repository.dart';

class AnalysisController extends GetxController {
  final HistoryRepository _historyService = HistoryRepository();

  final RxList<AnalysisRecord> historial = <AnalysisRecord>[].obs;

  late String userId;

  void setUserId(String id) {
    userId = id;
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final h = await _historyService.getHistory(userId);
    historial.assignAll(h);
  }

  Future<void> deleteAnalysis(String documentId, int index) async {
    await _historyService.deleteFromHistory(documentId: documentId);
    historial.removeAt(index);
  }

  void agregarAnalisis(AnalysisRecord nuevo) {
    historial.insert(0, nuevo);
  }
}
