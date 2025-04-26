import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:fatigue_control/app/constants/constants.dart';

class UserRepository {
  final Client client = Client()
    ..setEndpoint(AppwriteConstants.endpoint)
    ..setProject(AppwriteConstants.projectId)
    ..setSelfSigned(status: true);

  late final Databases databases = Databases(client);

  Future<void> registerUser({
    required String userId,
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await databases.createDocument(
        databaseId:    AppwriteConstants.databaseId,
        collectionId:  AppwriteConstants.usersCollectionId,
        documentId:    userId,
        data: {
          'userId'   : userId,
          'name'     : name,
          'email'    : email,
          'password' : password,
        },
      );
    } catch (e) {
      // ignore: avoid_print
      print('Error al registrar el usuario: $e');
      rethrow;
    }
  }

  Future<Document?> getUserByEmail(String email) async {
    try {
      final result = await databases.listDocuments(
        databaseId:   AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        queries: [ Query.equal('email', email) ],
      );
      return result.documents.isNotEmpty ? result.documents.first : null;
    } catch (e) {
      // ignore: avoid_print
      print('Error al buscar el usuario por email: $e');
      return null;
    }
  }

  Future<Document?> getUserById(String userId) async {
    try {
      final document = await databases.getDocument(
        databaseId:   AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId:   userId,
      );
      return document;
    } catch (e) {
      // ignore: avoid_print
      print('Error al obtener usuario por ID: $e');
      return null;
    }
  }

  Future<void> updateUserName(String userId, String newName) async {
    try {
      await databases.updateDocument(
        databaseId:   AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId:   userId,
        data: { 'name': newName },
      );
    } catch (e) {
      print('Error al actualizar nombre de usuario: $e');
      rethrow;
    }
  }

  Future<void> updateUserProfilePicture(String userId, String fileUrl) async {
    try {
      await databases.updateDocument(
        databaseId:   AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId:   userId,
        data: { 'profilePicture': fileUrl },
      );
    } catch (e) {
      // ignore: avoid_print
      print('Error al actualizar la foto de perfil: $e');
      rethrow;
    }
  }
}
