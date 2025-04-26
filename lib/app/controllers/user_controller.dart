import 'package:get/get.dart';

class UserController extends GetxController {
  var userId = ''.obs;
  var nombre = ''.obs;
  var email = ''.obs;

  void setUser({
    required String id,
    required String nombreUsuario,
    required String correo,
  }) {
    userId.value = id;
    nombre.value = nombreUsuario;
    email.value = correo;
  }

  void clearUser() {
    userId.value = '';
    nombre.value = '';
    email.value = '';
  }
}
