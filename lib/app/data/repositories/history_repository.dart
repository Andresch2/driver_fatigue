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
    } catch (_) {
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

  Future<void> saveAnalysisOfflineFirst(AnalysisRecord record) async {
    if (record.id.isEmpty) {
      record.id = DateTime.now().millisecondsSinceEpoch.toString();
    }
    record.synced = false;
    await _box.put(record.id, record);

    try {
      final models.Document created = await _db.createDocument(
        databaseId:   AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.historyCollectionId,
        documentId:   ID.unique(),
        data:         record.toCreateMap(),
      );
      final syncedRecord = record.copyWith(
        id:      created.$id,
        synced:  true,
      );
      await _box.delete(record.id);
      await _box.put(syncedRecord.id, syncedRecord);
    } catch (_) {
    }
  }

  Future<void> syncPending() async {
    final pending = _box.values.where((r) => !r.synced).toList();
    for (final record in pending) {
      try {
        final models.Document created = await _db.createDocument(
          databaseId:   AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.historyCollectionId,
          documentId:   ID.unique(),
          data:         record.toCreateMap(),
        );
        final updated = record.copyWith(
          id:      created.$id,
          synced:  true,
        );
        await _box.delete(record.id);
        await _box.put(updated.id, updated);
      } catch (e) {
        print('Error sincronizando ${record.id}: $e');
      }
    }
  }

  Future<void> deleteFromHistory({ required String documentId }) async {
    try {
      await _db.deleteDocument(
        databaseId:   AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.historyCollectionId,
        documentId:   documentId,
      );
    } catch (_) {
    }
    await _box.delete(documentId);
  }
}
