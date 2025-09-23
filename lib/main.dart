import 'package:flutter/material.dart';
import 'package:hirfa_frontend/Intro_screens/splash_screen.dart';
import 'package:hirfa_frontend/Intro_screens/intro_screen.dart';
import 'package:hirfa_frontend/Intro_screens/role_selection_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hirfa',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFfdfbf7),
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff863a3a)),
        fontFamily: 'Poppins',
      ),
      home: SplashScreen(),
      routes: {
        '/intro': (context) => const IntroScreen(),
        '/role': (context) => const RoleSelectionScreen(),
        // '/register': (context) => const RegisterScreen(),
        // '/login': (context) => const LoginScreen(),
        // '/home': (context) => const HomeScreen(),
      },
    );
  }
}
