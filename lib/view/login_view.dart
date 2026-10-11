import 'package:flutter/material.dart';

import 'package:strathclean/viewmodel/login_view_model.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key, required this.viewModel});

  final LoginViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: const Color.fromARGB(255, 19, 8, 68),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 24),
            Image.asset(
              'assets/images/strathlogo.png',
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 8),
            const Text(
              'StrathClean',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            LoginForm(viewModel: viewModel),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key, required this.viewModel});

  final LoginViewModel viewModel;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final result = await widget.viewModel.submitLogin(
      _usernameController.text,
      _passwordController.text,
    );

    if (!mounted) {
      return;
    }

    final user = result.user;
    if (user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) {
          return;
        }
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (route) => false,
          arguments: user,
        );
      });
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result.error ?? 'Login failed')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Full name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Full name is missing';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Password',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is missing';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, _) {
                return ElevatedButton(
                  onPressed: widget.viewModel.isLoading ? null : _onSubmit,
                  child: widget.viewModel.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Submit'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
