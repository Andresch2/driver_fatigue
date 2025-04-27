class Validators {

  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$',
    );
    return passwordRegex.hasMatch(password);
  }

  static bool isNotEmpty(String text) {
    return text.trim().isNotEmpty;
  }

  static bool isValidName(String name) {
    final nameRegex = RegExp(r'^[a-zA-Z\s]{2,50}$');
    return nameRegex.hasMatch(name);
  }
}
