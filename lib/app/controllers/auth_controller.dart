import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:fatigue_control/app/constants/constants.dart';
import 'package:fatigue_control/app/controllers/analysis_controller.dart';
import 'package:fatigue_control/app/controllers/user_controller.dart';
import 'package:fatigue_control/app/data/repositories/auth_repository.dart';
import 'package:fatigue_control/app/routes/app_routes.dart';
import 'package:fatigue_control/app/services/appwrite_client.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  final AuthRepository _repo   = Get.find<AuthRepository>();
  final GetStorage _storage    = GetStorage();
  late final Databases _db;

  Rxn<models.User> get user    => _repo.user;
  final RxBool isLoading       = false.obs;

  @override
  void onInit() {
    super.onInit();
    _db = Databases(client);

    ever<models.User?>(_repo.user, (u) {
      if (u != null) {
        final uc = Get.find<UserController>();
        uc.setUser(
          id:            u.$id,
          nombreUsuario: u.name ?? '',
          correo:        u.email,
        );

        _storage.write('userId',    u.$id);
        _storage.write('userName',  u.name   ?? '');
        _storage.write('userEmail', u.email);

        final ac = Get.find<AnalysisController>();
        ac.setUserId(u.$id);

        Get.offAllNamed(AppRoutes.home);
      }
    });
  }

  bool get hasLocalSession {
    final id = _storage.read('userId');
    return id is String && id.isNotEmpty;
  }

  String get storedUserId    => _storage.read('userId')    as String? ?? '';
  String get storedUserName  => _storage.read('userName')  as String? ?? '';
  String get storedUserEmail => _storage.read('userEmail') as String? ?? '';

  Future<bool> register({
    required String email,
    required String password,
    required String name,
  }) async {
    isLoading.value = true;
    final u = await _repo.register(email: email, password: password, name: name);
    isLoading.value = false;
    return u != null;
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    final ok = await _repo.login(email: email, password: password);
    isLoading.value = false;
    return ok;
  }

  Future<void> logout() async {
    await _repo.logout();
    _storage.remove('userId');
    _storage.remove('userName');
    _storage.remove('userEmail');
    Get.find<UserController>().clearUser();
    Get.find<AnalysisController>().historial.clear();
    Get.offAllNamed(AppRoutes.login);
  }

  Future<bool> checkAuth() async {
    if (hasLocalSession) return true;
    final logged = await _repo.isLoggedIn();
    if (logged) _repo.user.refresh();
    return logged;
  }

  Future<bool> checkUserProfileExists() async {
    final id = storedUserId;
    if (id.isEmpty) return false;
    try {
      final doc = await _db.getDocument(
        databaseId:   AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId:   id,
      );
      return doc.$id.isNotEmpty;
    } on AppwriteException {
      return false;
    }
  }
}
