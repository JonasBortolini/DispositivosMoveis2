import 'package:flutter/material.dart';

class AuthenticationPage extends StatelessWidget {
  final VoidCallback onAuthenticated;
  final VoidCallback onAuthenticate;

  const AuthenticationPage({
    Key? key,
    required this.onAuthenticated,
    required this.onAuthenticate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Construindo AuthenticationPage');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Autenticação'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Autenticação necessária para acessar o aplicativo.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onAuthenticate,
              child: const Text('Autenticar'),
            ),
          ],
        ),
      ),
    );
  }
}