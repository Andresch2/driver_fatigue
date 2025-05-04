import 'package:appwrite/appwrite.dart';
import 'package:fatigue_control/app/constants/constants.dart';
import 'package:fatigue_control/app/controllers/auth_controller.dart';
import 'package:fatigue_control/app/controllers/user_controller.dart';
import 'package:fatigue_control/app/data/repositories/user_repository.dart';
import 'package:fatigue_control/app/services/appwrite_client.dart';
import 'package:fatigue_control/app/widgets/custom_background.dart';
import 'package:fatigue_control/app/widgets/custom_button.dart';
import 'package:fatigue_control/app/widgets/user_info_card.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _repo = UserRepository();
  final _userC = Get.find<UserController>();
  final _authC = Get.find<AuthController>();

  Map<String, dynamic>? userData;
  bool isLoading = true;

  late final Account _account;
  late final Storage _storage;

  @override
  void initState() {
    super.initState();
    _account = Account(client);
    _storage = Storage(client);
    _loadUserFromDB();
  }

  Future<void> _loadUserFromDB() async {
    setState(() => isLoading = true);
    try {
      final doc = await _repo.getUserById(_userC.userId.value);
      userData = doc?.data;
    } catch (e) {
      Get.snackbar('Error', 'No se pudo cargar perfil: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _updateProfilePicture() async {
    final type = XTypeGroup(label: 'Images', extensions: ['png', 'jpg', 'jpeg']);
    final file = await openFile(acceptedTypeGroups: [type]);
    if (file == null) return;

    setState(() => isLoading = true);
    try {
      final uploaded = await _storage.createFile(
        bucketId: AppwriteConstants.bucketId,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: file.path),
      );

      final url = '${AppwriteConstants.endpoint}/storage/buckets/'
          '${AppwriteConstants.bucketId}/files/${uploaded.$id}/view'
          '?project=${AppwriteConstants.projectId}';

      await _repo.updateUserProfilePicture(_userC.userId.value, url);
      await _loadUserFromDB();
      Get.snackbar('Éxito', 'Foto de perfil actualizada');
    } catch (e) {
      Get.snackbar('Error', 'No se pudo subir imagen: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _updateName() async {
    final ctrl = TextEditingController(text: userData?['name'] ?? '');
    final newName = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar nombre'),
        content: TextField(controller: ctrl, decoration: const InputDecoration(labelText: 'Nombre completo')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, ctrl.text.trim()), child: const Text('Guardar')),
        ],
      ),
    );
    if (newName == null || newName.isEmpty) return;

    setState(() => isLoading = true);
    try {
      await _repo.updateUserName(_userC.userId.value, newName);
      _userC.nombre.value = newName;
      await _loadUserFromDB();
      Get.snackbar('Éxito', 'Nombre actualizado');
    } catch (e) {
      Get.snackbar('Error', 'No se pudo actualizar nombre: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _changePassword() async {
    final newPass = await showDialog<String>(
      context: context,
      builder: (_) {
        String pwd = '';
        return AlertDialog(
          title: const Text('Nueva contraseña'),
          content: TextField(
            onChanged: (v) => pwd = v,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Mínimo 6 caracteres'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            TextButton(onPressed: () => Navigator.pop(context, pwd), child: const Text('Aceptar')),
          ],
        );
      },
    );
    if (newPass == null || newPass.length < 6) return;
    try {
      await _account.updatePassword(password: newPass);
      Get.snackbar('Éxito', 'Contraseña actualizada');
    } on AppwriteException catch (e) {
      Get.snackbar('Error', e.message ?? e.toString());
    }
  }

  Future<void> _logout() async {
    await _authC.logout();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (userData == null) return const Scaffold(body: Center(child: Text('Perfil no encontrado')));

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: CustomBackground(
        showIcons: true,
        iconOpacity: 0.07,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              UserInfoCard(
                avatarUrl: userData!['profilePicture'] as String? ?? '',
                name: userData!['name'] as String? ?? '—',
                email: userData!['email'] as String? ?? '—',
                onEdit: _updateName,
              ),
              const SizedBox(height: 24),
              CustomButton(text: 'Cambiar Foto', icon: Icons.photo_camera, onPressed: _updateProfilePicture),
              const SizedBox(height: 16),
              CustomButton(text: 'Cambiar Contraseña', icon: Icons.lock, onPressed: _changePassword, backgroundColor: Colors.indigo),
              const SizedBox(height: 16),
              CustomButton(text: 'Cerrar sesión', icon: Icons.logout, onPressed: _logout, backgroundColor: Colors.red),
            ],
          ),
        ),
      ),
    );
  }
}
