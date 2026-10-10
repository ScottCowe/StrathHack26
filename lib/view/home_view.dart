import 'package:flutter/material.dart';
import 'package:strathclean/models/roles.dart';
import 'package:strathclean/models/user.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Strath Clean'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Hello, ${user.username}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (user.role == Role.supervisor)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        '/audit',
                        arguments: user,
                      ),
                      child: const Text('Audit'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        '/add-room',
                        arguments: user,
                      ),
                      child: const Text('Add new room'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
