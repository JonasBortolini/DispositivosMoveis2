import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'authentication_page.dart';
import 'my_home_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticated = false;
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _authenticate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _authenticate() async {
    print('Iniciando autenticação');
    if (_isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
    });

    try {
      await auth.stopAuthentication();

      bool isAuthenticated = await auth.authenticate(
        localizedReason: 'Por favor, autentique-se para acessar o aplicativo',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: false,
          biometricOnly: false,
        ),
      );
      print('Resultado da autenticação: $isAuthenticated');
      if (mounted) {
        setState(() {
          _isAuthenticated = isAuthenticated;
        });
      }
    } on PlatformException catch (e) {
      print('Erro de autenticação: $e');
      if (mounted) {
        setState(() {
          _isAuthenticated = false;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('AppLifecycleState mudou para $state');
    if (state == AppLifecycleState.resumed &&
        !_isAuthenticating &&
        !_isAuthenticated) {
      _authenticate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Produto',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      home: _isAuthenticated
          ? const MyHomePage(title: 'Lista de Produtos')
          : AuthenticationPage(
              onAuthenticated: () {
                setState(() {
                  _isAuthenticated = true;
                });
              },
              onAuthenticate: _authenticate,
            ),
    );
  }
}