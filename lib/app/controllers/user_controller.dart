// lib/app/controllers/user_controller.dart
import 'package:get/get.dart';

class UserController extends GetxController {
  var id    = ''.obs;
  var name  = ''.obs;
  var email = ''.obs;

  void setUser({required String userId, required String userName, required String userEmail}) {
    id.value    = userId;
    name.value  = userName;
    email.value = userEmail;
  }

  void clear() {
    id.value = '';
    name.value = '';
    email.value = '';
  }
}
