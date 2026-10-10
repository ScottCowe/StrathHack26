import 'package:flutter/material.dart';

class AuditView extends StatelessWidget {
  const AuditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audit'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Audit'),
      ),
    );
  }
}
