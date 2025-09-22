import 'package:flutter/material.dart';
import 'package:hirfa_frontend/Clients/Loginclient.dart';
import 'package:hirfa_frontend/Clients/ServicesClients/auth_client.dart';

class Registerclient extends StatefulWidget {
  const Registerclient({super.key});

  @override
  State<Registerclient> createState() => _RegisterclientState();
}

class _RegisterclientState extends State<Registerclient> {
  String? first_name;
  String? last_name;
  String? address;
  String? email;
  String? password;
  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _lastController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Future<void> _handleLogin() async {
    first_name = _firstController.text.trim();
    last_name = _lastController.text.trim();
    email = _emailController.text.trim();
    password = _passwordController.text.trim();
    address = _addressController.text.trim();
    if (first_name == null || first_name!.isEmpty) {
      _showError("First Name is required");
      return;
    }
    if (last_name == null || last_name!.isEmpty) {
      _showError("Last Name is required");
      return;
    }
    if (address == null || address!.isEmpty) {
      _showError("Address is required");
      return;
    }
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

    print(
      "✅ First Name: $first_name last Name : $last_name address: $address Email: $email | Password: $password",
    );
    //appel api
    final errorMessage = await AuthClient.registerClient(
      firstName: first_name!,
      lastName: last_name!,
      address: address!,
      email: email!,
      password: password!,
    );
    if (errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("✅ Inscription réussie. Vérifie ton email."),
          backgroundColor: Colors.green,
        ),
      );
      // Optionnel : rediriger vers une page de confirmation
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
  Widget InputText({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFFA0A0A0), // Couleur du texte hint
          fontSize: 14,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
        ),
        prefixIcon: Icon(icon, color: Color(0xFF555555)),
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
    );
  }

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
              const SizedBox(height: 40),
              const SizedBox(height: 8),
              const Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD5B694),
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 50),
              const SizedBox(height: 8),
              InputText(
                hint: "Client First Name",
                icon: Icons.person_3,
                controller: _firstController,
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 8),
              InputText(
                hint: "Client Last Name",
                icon: Icons.person_4,
                controller: _lastController,
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 8),
              InputText(
                hint: "Client Address",
                icon: Icons.location_on,
                controller: _addressController,
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 8),
              InputText(
                hint: "Client Email",
                icon: Icons.email,
                controller: _emailController,
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                textAlign: TextAlign.center,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Client Password",
                  hintStyle: const TextStyle(
                    color: Color(0xFFA0A0A0), // Couleur du texte hint
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                  prefixIcon: Icon(Icons.lock, color: Color(0xFF555555)),
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
                  'Sign Up',
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),

              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Do you have already an account ? ",
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
                        MaterialPageRoute(builder: (context) => Loginclient()),
                      );
                    },
                    child: const Text(
                      'Sign In',
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
