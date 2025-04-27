import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:fatigue_control/app/constants/constants.dart';

import '../models/analysis_record.dart';

class HistoryRepository {
  final Client client = Client()
    ..setEndpoint(AppwriteConstants.endpoint)
    ..setProject(AppwriteConstants.projectId)
    ..setSelfSigned(status: true);

  late final Databases databases = Databases(client);

  Future<Document> saveToHistory({
    required String userId,
    required String status,
    required String date,
    required String observations,
    double? eyeProbability,
    bool? yawnDetected,
    double? headTilt,
    double? fatigueScore,
  }) async {
    return await databases.createDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.historyCollectionId,
      documentId: ID.unique(),
      data: {
        'user_id': userId,
        'status': status,
        'date': date,
        'observations': observations,
        'eye_probability': eyeProbability ?? 1.0,
        'yawn_detected': yawnDetected ?? false,
        'head_tilt': headTilt ?? 0.0,
        'fatigue_score': fatigueScore ?? 0.0,
      },
    );
  }

  Future<void> deleteFromHistory({ required String documentId }) async {
    await databases.deleteDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.historyCollectionId,
      documentId: documentId,
    );
  }

  Future<List<AnalysisRecord>> getHistory(String userId) async {
    final result = await databases.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.historyCollectionId,
      queries: [
        Query.equal('user_id', userId),
        Query.orderDesc('date'),
      ],
    );

    return result.documents.map((doc) {
      final map = Map<String, dynamic>.from(doc.data)
        ..['\$id'] = doc.$id;
      return AnalysisRecord.fromMap(map);
    }).toList();
  }
}
