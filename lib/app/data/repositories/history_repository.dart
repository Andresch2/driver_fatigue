import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:fatigue_control/app/constants/constants.dart';
import 'package:fatigue_control/app/services/appwrite_client.dart';
import 'package:hive/hive.dart';

import '../models/analysis_record.dart';

class HistoryRepository {
  final Databases _db  = Databases(client);
  final Box<AnalysisRecord> _box = Hive.box<AnalysisRecord>('history');

  Future<List<AnalysisRecord>> getHistory(String userId) async {
    try {
      await _refreshRemote(userId);
    } catch (e) {
      print('Error al refrescar el historial: $e');
      return [];
    }

    final local = _box.values
      .where((r) => r.userId == userId)
      .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
    return local;
  }

  Future<void> _refreshRemote(String userId) async {
    final models.DocumentList remote = await _db.listDocuments(
      databaseId:   AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.historyCollectionId,
      queries: [
        Query.equal('user_id', userId),
        Query.orderDesc('date'),
      ],
    );

    final List<AnalysisRecord> temp = remote.documents.map((doc) {
      return AnalysisRecord.fromMap({
        ...doc.data,
        r'$id': doc.$id,
      });
    }).toList();

    await _box.clear();
    for (final record in temp) {
      await _box.put(record.id, record);
    }
  }

  Future<models.Document> saveToHistory({
    required String userId,
    required String status,
    required String date,
    required String observations,
    double? eyeProbability,
    bool? yawnDetected,
    double? headTilt,
    double? fatigueScore,
  }) async {
    return await _db.createDocument(
      databaseId:   AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.historyCollectionId,
      documentId:   ID.unique(),
      data: {
        'user_id':         userId,
        'status':          status,
        'date':            date,
        'observations':    observations,
        'eye_probability': eyeProbability  ?? 1.0,
        'yawn_detected':   yawnDetected    ?? false,
        'head_tilt':       headTilt        ?? 0.0,
        'fatigue_score':   fatigueScore    ?? 0.0,
      },
    );
  }

  Future<void> deleteFromHistory({ required String documentId }) async {
    await _db.deleteDocument(
      databaseId:   AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.historyCollectionId,
      documentId:   documentId,
    );
    await _box.delete(documentId);
  }
}
