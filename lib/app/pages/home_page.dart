import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/user_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext c) {
    final uc = Get.find<UserController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(child: Text('Hola, ${uc.name.value}! Bienvenido.')),
    );
  }
}
