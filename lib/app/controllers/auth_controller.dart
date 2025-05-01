import 'package:appwrite/models.dart' as models;
import 'package:fatigue_control/app/data/repositories/auth_repository.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthRepository _repo = Get.find<AuthRepository>();

  Rxn<models.User> get user => _repo.user;

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    ever<models.User?>(_repo.user, (u) {
      if (u != null) {
        Get.offAllNamed('/home');
      }
    });
  }

  Future<bool> register({
    required String email,
    required String password,
    required String name,
  }) async {
    isLoading.value = true;
    final me = await _repo.register(
      email: email,
      password: password,
      name: name,
    );
    isLoading.value = false;
    return me != null;
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    final ok = await _repo.login(
      email: email,
      password: password,
    );
    isLoading.value = false;
    return ok;
  }

  Future<void> logout() => _repo.logout();

  Future<bool> checkAuth() async {
    return await _repo.isLoggedIn();
  }
}
