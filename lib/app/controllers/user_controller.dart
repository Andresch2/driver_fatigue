import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:fatigue_control/app/constants/constants.dart';
import 'package:fatigue_control/app/services/appwrite_client.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final RxString userId = ''.obs;
  final RxString nombre = ''.obs;
  final RxString email = ''.obs;

  final Databases _db = Databases(client);

  final String databaseId   = AppwriteConstants.databaseId;
  final String collectionId = AppwriteConstants.usersCollectionId;

  void setUser({
    required String id,
    required String nombreUsuario,
    required String correo,
  }) {
    userId.value = id;
    nombre.value = nombreUsuario;
    email.value  = correo;
    print('User actualizado: id=$id, nombre=$nombreUsuario, correo=$correo');
  }

  void clearUser() {
    userId.value = '';
    nombre.value  = '';
    email.value   = '';
  }

  Future<Document?> cargarPerfilDesdeDB() async {
    if (userId.isEmpty) return null;
    try {
      return await _db.getDocument(
        databaseId:   databaseId,
        collectionId: collectionId,
        documentId:   userId.value,
      );
    } on AppwriteException catch (e) {
      print('Error al obtener perfil: ${e.message}');
      return null;
    }
  }
}
