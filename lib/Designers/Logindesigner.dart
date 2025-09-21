import 'package:flutter/material.dart';
import 'package:hirfa_frontend/Designers/Registerdesigner.dart';
import 'package:hirfa_frontend/Designers/ServicesDesigners/auth_designer.dart';
import 'package:hirfa_frontend/Designers/homedesigner.dart';

class Logindesigner extends StatefulWidget {
  const Logindesigner({super.key});

  @override
  State<Logindesigner> createState() => _LogindesignerState();
}

class _LogindesignerState extends State<Logindesigner> {
  String? email;
  String? password;
  // Controllers pour récupérer le texte des champs
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _handleLogin() async {
    email = _emailController.text.trim();
    password = _passwordController.text.trim();

    if (email == null || email!.isEmpty) {
      _showError("Email is required");
      return;
    }

    if (password == null || password!.isEmpty) {
      _showError("Password is required");
      return;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email!)) {
      _showError("Invalid email format");
    }
    if (password!.length < 7) {
      _showError("Password must be at least 7 characters");
    }

    print("✅ Email: $email | Password: $password");
    // appel api
    final errorMessage = await AuthDesigner.loginDesigner(
      email: email!,
      password: password!,
    );
    if (errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("✅ Connexion réussie."),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homedesigner()),
      );
    } else {
      _showError(errorMessage);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 90),
              const SizedBox(height: 8),
              const Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD5B694),
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 50),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Enter your Email',
                  hintStyle: const TextStyle(
                    color: Color(0xFFA0A0A0), // Couleur du texte hint
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                  prefixIcon: const Icon(
                    Icons.email,
                    color: Color(0xFF555555), // Couleur de l’icône
                  ),
                  filled: true,
                  fillColor: const Color(0xFFFFFFFF), // Fond du champ
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(
                  color: Color(0xFF555555), // Couleur du texte saisi
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                textAlign: TextAlign.center,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  hintStyle: const TextStyle(
                    color: Color(0xFFA0A0A0), // Couleur du texte hint
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: Color(0xFF555555), // Couleur de l’icône
                  ),

                  filled: true,
                  fillColor: const Color(0xFFFFFFFF), // Fond du champ
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(
                  color: Color(0xFF555555), // Couleur du texte saisi
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  _handleLogin();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD5B694),
                  minimumSize: const Size(400, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Coins arrondis
                  ),
                ),
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  // Action d'inscription ici
                },
                child: const Text(
                  'Forgot your Password ?',
                  style: TextStyle(
                    color: Color(0xFFA0A0A0),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              const SizedBox(height: 150),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have a Hirfa account ?",
                    style: TextStyle(
                      color: Color(0xFFA0A0A0),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Registerdesigner(),
                        ),
                      );
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000000),
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
