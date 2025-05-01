import 'package:get/get.dart';

class UserController extends GetxController {
  final RxString userId = ''.obs;
  final RxString nombre = ''.obs;
  final RxString email = ''.obs;

  void setUser({
    required String id,
    required String nombreUsuario,
    required String correo,
  }) {
    userId.value = id;
    nombre.value = nombreUsuario;
    email.value = correo;
    // ignore: avoid_print
    print('User actualizado: id=$id, nombre=$nombreUsuario, correo=$correo');
  }

  void clearUser() {
    userId.value = '';
    nombre.value = '';
    email.value = '';
  }
}
