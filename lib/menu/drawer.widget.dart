import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/global.params.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  Future<void> _deconnexion(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final disconnected = await prefs.setBool('connecte', false);

      if (!context.mounted) return;

      if (!disconnected) {
        _showError(context, 'Impossible de fermer la session.');
        return;
      }

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/authentification',
        (route) => false,
      );
    } catch (error) {
      debugPrint('Erreur lors de la déconnexion: $error');
      if (context.mounted) {
        _showError(context, 'Une erreur est survenue lors de la déconnexion.');
      }
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    return Drawer(
      backgroundColor: const Color(0xFFFFF8FF),
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 76,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF8BC2FF), Color(0xFF4A91F5)],
                ),
              ),
              child: Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'images/profile.png',
                      key: const ValueKey('drawer-profile-image'),
                      width: 66,
                      height: 66,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            ...GlobalParams.menu.map((item) {
              final route = item['route'] as String?;
              final title = item['title'] as String;

              return ListTile(
                leading: Icon(item['icon'] as IconData),
                title: Text(title),
                dense: true,
                visualDensity: const VisualDensity(vertical: -1),
                minVerticalPadding: 0,
                minTileHeight: 36,
                horizontalTitleGap: 12,
                minLeadingWidth: 18,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                selectedTileColor: const Color(0xFFE3F0FF),
                iconColor: const Color(0xFF2699F5),
                selectedColor: const Color(0xFF2699F5),
                shape: const Border(
                  bottom: BorderSide(color: Color(0xFFD8DCE6)),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF2699F5),
                  size: 18,
                ),
                selected: route != null && route == currentRoute,
                onTap: () {
                  Navigator.pop(context);
                  if (route == null) {
                    _deconnexion(context);
                  } else if (route != currentRoute) {
                    Navigator.pushNamed(context, route);
                  }
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
