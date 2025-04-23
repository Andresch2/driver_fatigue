// lib/app/services/user_database_service.dart
import 'package:appwrite/appwrite.dart';

import '../constants/constants.dart';

class UserDatabaseService {
  final Client _client = Client()
    ..setEndpoint(AppwriteConstants.endpoint)
    ..setProject(AppwriteConstants.projectId)
    ..setSelfSigned(status: true);

  late final Databases _db = Databases(_client);

  Future<void> createProfile({
    required String userId,
    required String name,
    required String email,
  }) {
    return _db.createDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.usersCollection,
      documentId: userId,
      data: {
        'name': name,
        'email': email,
      },
    );
  }

  Future<Map<String, dynamic>?> getProfile(String userId) async {
    try {
      final doc = await _db.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollection,
        documentId: userId,
      );
      return doc.data;
    } catch (_) {
      return null;
    }
  }
}
