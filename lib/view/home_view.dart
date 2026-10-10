import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Strath Clean'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          children: [
            DefaultTextStyle.merge(
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              child: Text('Greeting'),
            ),
          ],
        ),
      ),
    );
  }
}
