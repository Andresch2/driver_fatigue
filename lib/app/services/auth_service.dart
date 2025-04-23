// lib/app/services/auth_service.dart
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:get/get.dart';

import '../constants/constants.dart';

class AuthService extends GetxService {
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

      await _account.createEmailPasswordSession(email: email, password: password);
      user.value = await _account.get();
      return newUser;
    } on AppwriteException catch (e) {
      Get.snackbar('Registro fallido', e.message ?? e.toString());
      return null;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      await _account.createEmailPasswordSession(email: email, password: password);
      user.value = await _account.get();
      return true;
    } on AppwriteException catch (e) {
      Get.snackbar('Login fallido', e.message ?? e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _account.deleteSession(sessionId: 'current');
      user.value = null;
    } on AppwriteException catch (e) {
      Get.snackbar('Logout fallido', e.message ?? e.toString());
    }
  }

  Future<void> _loadCurrentUser() async {
    try {
      user.value = await _account.get();
    } catch (_) {
      user.value = null;
    }
  }
}
