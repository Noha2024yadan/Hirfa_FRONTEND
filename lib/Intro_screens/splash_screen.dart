import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(seconds: 3, milliseconds: 500));

    final prefs = await SharedPreferences.getInstance();
    final introSeen = prefs.getBool('intro_seen') ?? false;
    // final roleSet = prefs.containsKey('user_role');

    if (!introSeen) {
      // First time - show intro screens (which start with language selection)
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/intro');
      return;
    }

    // Intro already seen → Always show role selection
    // The role screen itself can read the stored role and pre-select it.
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/role');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "images/hirfalogo.png",
              width: 178,
              height: 208,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF863A3A)),
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
