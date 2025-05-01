import 'package:appwrite/models.dart' as models;
import 'package:fatigue_control/app/controllers/analysis_controller.dart';
import 'package:fatigue_control/app/controllers/user_controller.dart';
import 'package:fatigue_control/app/data/repositories/auth_repository.dart';
import 'package:fatigue_control/app/routes/app_routes.dart';
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

        final uc = Get.find<UserController>();
        uc.setUser(
          id:     u.$id,
          nombreUsuario: u.name,
          correo: u.email,
        );

        final ac = Get.find<AnalysisController>();
        ac.setUserId(u.$id);
        Get.offAllNamed(AppRoutes.home);
      }
    });
  }

  Future<bool> register({
    required String email,
    required String password,
    required String name,
  }) async {
    isLoading.value = true;
    final me = await _repo.register(email: email, password: password, name: name);
    isLoading.value = false;
    return me != null;
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
    Get.find<UserController>().clearUser();
    Get.find<AnalysisController>().historial.clear();
    Get.offAllNamed(AppRoutes.login);
  }

  Future<bool> checkAuth() async {
    final loggedIn = await _repo.isLoggedIn();
    if (loggedIn) {
      _repo.user.refresh();
    }
    return loggedIn;
  }
}
