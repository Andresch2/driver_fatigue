import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:fatigue_control/app/constants/constants.dart';
import 'package:get/get.dart';

class AuthRepository extends GetxService {
  late final Client _client;
  late final Account _account;

  final Rxn<models.User> user = Rxn<models.User>();

  @override
  void onInit() {
    super.onInit();
    _client = Client()
      ..setEndpoint(AppwriteConstants.endpoint)
      ..setProject(AppwriteConstants.projectId)
      ..setSelfSigned(status: true);

    _account = Account(_client);
    _loadCurrentUser();
  }

  Future<models.User?> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final newUser = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );

      try {
        await _account.deleteSession(sessionId: 'current');
      } catch (_) {}

      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      final me = await _account.get();
      user.value = me;
      return newUser;
    } on AppwriteException catch (e) {
      Get.snackbar('Error al registrarse', e.message ?? e.toString());
      return null;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {

      try {
        await _account.deleteSession(sessionId: 'current');
      } catch (_) {}

      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      final me = await _account.get();
      user.value = me;
      return true;
    } on AppwriteException catch (e) {
      Get.snackbar('Error al iniciar sesión', e.message ?? e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _account.deleteSession(sessionId: 'current');
    } catch (_) {}
    user.value = null;
  }

  Future<bool> isLoggedIn() async {
    try {
      await _account.get();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _loadCurrentUser() async {
    if (await isLoggedIn()) {
      try {
        final me = await _account.get();
        user.value = me;
      } catch (_) {
        user.value = null;
      }
    }
  }
}
