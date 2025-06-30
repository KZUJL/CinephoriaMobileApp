import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'screens/home_page.dart';
import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.badCertificateCallback = (cert, host, port) => true;
    return client;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const CinephoriaApp());
}

class CinephoriaApp extends StatefulWidget {
  const CinephoriaApp({super.key});

  @override
  State<CinephoriaApp> createState() => _CinephoriaAppState();
}

class _CinephoriaAppState extends State<CinephoriaApp> {
  bool _isLoggedIn = false;
  int? _userId;

  void _onLoginSuccess(int userId) {
    setState(() {
      _isLoggedIn = true;
      _userId = userId;
    });
  }

@override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cinephoria',
      theme: ThemeData(
        primaryColor: const Color(0xFF073FA0),
        scaffoldBackgroundColor: const Color(0xFF1C2350),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1C2350),
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1C2350),
          primary: const Color(0xFF1C2350),
          background: const Color(0xFF1C2350),
          brightness: Brightness.dark,
        ),
      ),
      home: _isLoggedIn
          ? HomePage(
              userId: _userId!,
              onLogout: () {
                setState(() {
                  _isLoggedIn = false;
                  _userId = null;
                });
              },
            )
          : LoginPage(onLoginSuccess: _onLoginSuccess),
    );
  }

}
