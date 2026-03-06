import 'package:flutter/material.dart';
import 'package:food_order/components/drawer_tile.dart';
import 'package:food_order/constants/style.dart';
import 'package:food_order/pages/settings.dart';
import 'package:food_order/services/auth/auth_service.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.asset(
                'images/avatar.jpg',
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Divider(color: mainYellow),
            DrawerTile(
              title: "Trang chủ",
              icon: Icons.home,
              onTap: () => Navigator.pop(context),
            ),
            DrawerTile(
              title: "Cài đặt",
              icon: Icons.settings,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              },
            ),
            const Spacer(),
            DrawerTile(
              title: "Đăng xuất",
              icon: Icons.logout,
              onTap: () async {
                final authServices = AuthService();
                try {
                  await authServices.signOut();
                } catch (e) {
                  if (!context.mounted) {
                    return;
                  }
                  final String message =
                      e.toString().replaceFirst('Exception: ', '').trim();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        message.isEmpty
                            ? 'Đăng xuất thất bại. Vui lòng thử lại.'
                            : message,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
