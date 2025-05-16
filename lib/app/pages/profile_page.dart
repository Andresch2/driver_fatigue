import 'package:appwrite/appwrite.dart';
import 'package:fatigue_control/app/constants/constants.dart';
import 'package:fatigue_control/app/controllers/auth_controller.dart';
import 'package:fatigue_control/app/controllers/user_controller.dart';
import 'package:fatigue_control/app/data/repositories/user_repository.dart';
import 'package:fatigue_control/app/services/appwrite_client.dart';
import 'package:fatigue_control/app/widgets/backgrounds/profile_background.dart';
import 'package:fatigue_control/app/widgets/profile_widgets/profile_buttons.dart';
import 'package:fatigue_control/app/widgets/profile_widgets/user_info_card.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _repo   = UserRepository();
  final _userC  = Get.find<UserController>();
  final _authC  = Get.find<AuthController>();

  Map<String, dynamic>? userData;
  bool isLoading = true;

  late final Storage _storage;

  @override
  void initState() {
    super.initState();
    _storage = Storage(client);
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() => isLoading = true);
    try {
      final model = await _userC.cargarPerfil();
      if (model != null) {
        userData = {
          'name':           model.name,
          'email':          model.email,
          'profilePicture': model.profilePicture,
        };
      } else {
        userData = null;
      }
    } catch (e) {
      userData = null;
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
        fileId:   ID.unique(),
        file:     InputFile.fromPath(path: file.path),
      );
      final url =
        '${AppwriteConstants.endpoint}/storage/buckets/${AppwriteConstants.bucketId}/files/${uploaded.$id}/view'
        '?project=${AppwriteConstants.projectId}';

      await _repo.updateUserProfilePicture(_userC.userId.value, url);
      await _userC.cargarPerfil();
      await _loadUserProfile();

      Get.snackbar('Éxito', 'Foto de perfil actualizada');
    } catch (e) {
      Get.snackbar('Error', 'No se pudo subir imagen: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _updateName() async {
    final ctrl = TextEditingController(text: userData?['name'] as String? ?? '');
    final newName = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar nombre'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: 'Nombre completo'),
        ),
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
      await _userC.cargarPerfil();
      await _loadUserProfile();

      Get.snackbar('Éxito', 'Nombre actualizado');
    } catch (e) {
      Get.snackbar('Error', 'No se pudo actualizar nombre: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _logout() async {
    await _authC.logout();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (userData == null) {
      return const Scaffold(
        body: Center(child: Text('Perfil no encontrado')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: ProfileBackground(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              UserInfoCard(
                avatarUrl: userData!['profilePicture'] as String? ?? '',
                name:      userData!['name'] as String,
                email:     userData!['email'] as String,
                onEdit:    _updateName,
              ),
              
              ProfileActionButtons(
                onUpdateProfilePicture: _updateProfilePicture,
                onLogout: _logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}