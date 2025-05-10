import 'package:appwrite/appwrite.dart';
import 'package:fatigue_control/app/constants/constants.dart';
import 'package:fatigue_control/app/data/models/user_model.dart';
import 'package:fatigue_control/app/services/appwrite_client.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class UserController extends GetxController {
  final RxString userId = ''.obs;
  final RxString nombre = ''.obs;
  final RxString email = ''.obs;

  final Databases _db = Databases(client);
  late final Box<UserModel> _userBox;

  final String databaseId   = AppwriteConstants.databaseId;
  final String collectionId = AppwriteConstants.usersCollectionId;

  @override
  void onInit() {
    super.onInit();
    _userBox = Hive.box<UserModel>('userBox');
  }

  void setUser({
    required String id,
    required String nombreUsuario,
    required String correo,
  }) {
    userId.value = id;
    nombre.value = nombreUsuario;
    email.value  = correo;
    _cacheProfileLocally();
    print('User actualizado: id=$id, nombre=$nombreUsuario, correo=$correo');
  }

  void clearUser() {
    userId.value = '';
    nombre.value  = '';
    email.value   = '';
  }

  Future<void> _fetchAndCacheProfile() async {
    if (userId.value.isEmpty) return;
    try {
      final doc = await _db.getDocument(
        databaseId:   databaseId,
        collectionId: collectionId,
        documentId:   userId.value,
      );
      final profile = UserModel.fromMap(doc.data);
      nombre.value = profile.name;
      email.value  = profile.email;
      await _userBox.put(profile.id, profile);
      print('Perfil remoto obtenido y cacheado');
    } on AppwriteException catch (e) {
      print('No se pudo obtener perfil remoto (offline?): ${e.message}');
    }
  }

  Future<UserModel?> cargarPerfil() async {
    await _fetchAndCacheProfile();

    if (_userBox.containsKey(userId.value)) {
      final cached = _userBox.get(userId.value)!;
      nombre.value = cached.name;
      email.value  = cached.email;
      return cached;
    } else {
      print('Perfil no encontrado en caché para userId=${userId.value}');
      return null;
    }
  }

  Future<void> _cacheProfileLocally() async {
    if (userId.value.isEmpty) return;
    final profile = UserModel(
      id: userId.value,
      name: nombre.value,
      email: email.value,
    );
    await _userBox.put(profile.id, profile);
  }
}
