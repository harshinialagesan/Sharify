import 'package:flutter/material.dart';
import 'package:my_app/models/auth_service_class.dart';

class LogoutTile extends StatelessWidget {
  final AuthService _authService = AuthService();

  LogoutTile({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      await _authService.logout();
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        leading: const Icon(Icons.logout),
        title: const Text("Logout"),
        onTap: () {
          _logout(context);
        },
      ),
    );
  }
}
