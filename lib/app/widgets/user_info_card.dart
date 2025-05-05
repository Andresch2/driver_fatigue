import 'package:flutter/material.dart';

class UserInfoCard extends StatelessWidget {
  final String? avatarUrl;
  final String name;
  final String email;
  final VoidCallback onEdit;

  const UserInfoCard({
    super.key,
    this.avatarUrl,
    required this.name,
    required this.email,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      shadowColor: theme.colorScheme.primary.withOpacity(0.25),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          children: [

            CircleAvatar(
              radius: 56,
              backgroundColor: theme.colorScheme.secondary.withOpacity(0.2),
              backgroundImage:
                  avatarUrl != null ? NetworkImage(avatarUrl!) : null,
              child: avatarUrl == null
                  ? Icon(Icons.person, size: 56, color: theme.colorScheme.onSecondary)
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.email, size: 18, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Text(
                  email,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: onEdit,
              icon: Icon(Icons.edit, color: theme.colorScheme.primary),
              label: Text('Editar perfil',
                  style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.primary)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: theme.colorScheme.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
