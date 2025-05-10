import 'package:flutter/material.dart';

class ProfileActionButtons extends StatelessWidget {
  final VoidCallback onUpdateProfilePicture;
  final VoidCallback onLogout;

  const ProfileActionButtons({
    super.key,
    required this.onUpdateProfilePicture,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: onUpdateProfilePicture,
              icon: const Icon(Icons.photo_camera_outlined),
              label: const Text(
                'Cambiar Foto de Perfil',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
              ),
            ),
          ),
          
          const SizedBox(height: 20),

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: OutlinedButton.icon(
              onPressed: () {
                
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Cerrar sesión'),
                      content: const Text('¿Estás seguro que deseas cerrar sesión?'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            onLogout();
                          },
                          child: const Text('Cerrar sesión', 
                            style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.logout_rounded),
              label: const Text(
                'Cerrar sesión',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.redAccent, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}