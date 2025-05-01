import 'package:appwrite/appwrite.dart';
import 'package:fatigue_control/app/constants/constants.dart';
import 'package:fatigue_control/app/data/repositories/user_repository.dart';
import 'package:fatigue_control/app/routes/app_routes.dart';
import 'package:fatigue_control/app/services/appwrite_client.dart';
import 'package:fatigue_control/app/widgets/custom_background.dart';
import 'package:fatigue_control/app/widgets/custom_button.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserRepository _repo = UserRepository();

  Map<String, dynamic>? userData;
  bool isLoading = true;
  late final String userId;

  late final Account _account;
  late final Storage _storage;

  @override
  void initState() {
    super.initState();
    _account = Account(client);
    _storage = Storage(client);

    final arg = Get.arguments;
    if (arg is! String || arg.isEmpty) {
      Future.microtask(() {
        Get.snackbar('Error', 'ID de usuario inválido');
        Get.offAllNamed(AppRoutes.login);
      });
    } else {
      userId = arg;
      _loadUser();
    }
  }

  Future<void> _loadUser() async {
    try {
      final doc = await _repo.getUserById(userId);
      setState(() {
        userData = doc?.data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      Get.snackbar('Error', 'No se pudo cargar perfil: $e');
    }
  }

  Future<void> _updateName() async {
    final ctrl = TextEditingController(text: userData!['name'] as String? ?? '');
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
      await _repo.updateUserName(userId, newName);
      setState(() {
        userData!['name'] = newName;
        isLoading = false;
      });
      Get.snackbar('Éxito', 'Nombre actualizado');
    } catch (e) {
      setState(() => isLoading = false);
      Get.snackbar('Error', 'No se pudo actualizar nombre: $e');
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
      final url = '${AppwriteConstants.endpoint.replaceFirst('/v1','')}/storage/buckets/'
          '${AppwriteConstants.bucketId}/files/${uploaded.$id}/view?project=${AppwriteConstants.projectId}';

      await _repo.updateUserProfilePicture(userId, url);
      setState(() {
        userData!['profilePicture'] = url;
        isLoading = false;
      });
      Get.snackbar('Éxito', 'Foto de perfil actualizada');
    } catch (e) {
      setState(() => isLoading = false);
      Get.snackbar('Error', 'No se pudo subir imagen: $e');
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
            decoration: const InputDecoration(labelText: 'Mínimo 6 caracteres'),
            obscureText: true,
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
    try {
      await _account.deleteSession(sessionId: 'current');
    } catch (_) {}
    Get.offAllNamed(AppRoutes.login);
  }

  Widget _buildAvatar() {
    final picUrl = userData!['profilePicture'] as String?;
    if (picUrl == null || picUrl.isEmpty) {
      return const Icon(Icons.person, size: 70, color: Colors.white);
    }
    return CircleAvatar(
      radius: 70,
      backgroundColor: Colors.grey.shade200,
      backgroundImage: NetworkImage(picUrl),
      onBackgroundImageError: (_, __) {
        setState(() => userData!['profilePicture'] = null);
      },
    );
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
              const SizedBox(height: 16),
              Center(child: _buildAvatar()),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Cambiar Foto',
                icon: Icons.photo_camera,
                onPressed: _updateProfilePicture,
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(userData!['email'] as String? ?? '—'),
                      const SizedBox(height: 8),
                      Text(
                        userData!['name'] as String? ?? '—',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      CustomButton(
                        text: 'Editar nombre',
                        icon: Icons.edit,
                        onPressed: _updateName,
                        backgroundColor: Colors.green,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Cambiar Contraseña',
                icon: Icons.lock,
                onPressed: _changePassword,
                backgroundColor: Colors.indigo,
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Cerrar sesión',
                icon: Icons.logout,
                onPressed: _logout,
                backgroundColor: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
