import 'package:fatigue_control/app/data/models/analysis_record.dart';
import 'package:fatigue_control/app/data/repositories/history_repository.dart';
import 'package:get/get.dart';

class AnalysisController extends GetxController {
  final HistoryRepository _historyService = Get.find<HistoryRepository>();

  final RxList<AnalysisRecord> historial = <AnalysisRecord>[].obs;
  final RxString userId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    ever<String>(userId, (_) => _loadHistory());
  }

  @override
  void onReady() {
    super.onReady();
    if (userId.value.isNotEmpty) {
      _loadHistory();
    }
  }

  void setUserId(String id) {
    userId.value = id;
  }

  Future<void> _loadHistory() async {
    if (userId.value.isEmpty) return;
    final List<AnalysisRecord> data =
        await _historyService.getHistory(userId.value);
    historial.assignAll(data);
  }

  Future<void> deleteAnalysis(String documentId, int index) async {
    await _historyService.deleteFromHistory(documentId: documentId);
    historial.removeAt(index);
  }

  void agregarAnalisis(AnalysisRecord nuevo) {
    historial.insert(0, nuevo);
  }
}
