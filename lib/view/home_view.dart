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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/strathlogo.png',
              width: 200,
              height: 200,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.blue),
                foregroundColor: WidgetStateProperty.all(Colors.white),
              ),
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
