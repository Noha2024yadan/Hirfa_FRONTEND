import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hirfa_frontend/Clients/home_client.dart';
import 'package:hirfa_frontend/Cooperative/login_cooperative.dart';
import 'package:hirfa_frontend/Designers/login_designer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? _selectedRole;
  Map<String, String>? _localizedRoles = {
    'client': 'Client',
    'cooperative': 'Cooperative',
    'designer': 'Designer',
  };

  String _localizedTitle = 'Choose who you are';
  String _localizedDescription = 'Select your role to continue';

  @override
  void initState() {
    super.initState();
    _loadLocalizedContent();
  }

  Future<void> _loadLocalizedContent() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language') ?? 'en';

    setState(() {
      if (languageCode == 'fr') {
        _localizedRoles = {
          'client': 'Client',
          'cooperative': 'Coopérative',
          'designer': 'Designer',
        };
        _localizedTitle = 'Choisissez qui vous êtes';
        _localizedDescription = 'Sélectionnez votre rôle pour continuer';
      } else if (languageCode == 'ar') {
        _localizedRoles = {
          'client': 'عميل',
          'cooperative': 'تعاونية',
          'designer': 'مصمم',
        };
        _localizedTitle = 'اختر من أنت';
        _localizedDescription = 'حدد دورك للمتابعة';
      } else {
        _localizedRoles = {
          'client': 'Client',
          'cooperative': 'Cooperative',
          'designer': 'Designer',
        };
        _localizedTitle = 'Choose who you are';
        _localizedDescription = 'Select your role to continue';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _localizedTitle,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              _localizedDescription,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            // Client Option
            _buildRoleOption(
              icon: FontAwesomeIcons.solidUser,
              title: _localizedRoles!['client']!,
              value: 'client',
            ),
            const SizedBox(height: 20),
            // Cooperative Option
            _buildRoleOption(
              icon: FontAwesomeIcons.handshakeAngle,
              title: _localizedRoles!['cooperative']!,
              value: 'cooperative',
            ),
            const SizedBox(height: 20),
            // Designer Option
            _buildRoleOption(
              icon: FontAwesomeIcons.boxOpen,
              title: _localizedRoles!['designer']!,
              value: 'designer',
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    _selectedRole != null
                        ? () => _saveRoleAndContinue(_selectedRole!)
                        : null,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>((
                    Set<WidgetState> states,
                  ) {
                    if (states.contains(WidgetState.disabled)) {
                      return const Color(0xFFF0E8E2);
                    }
                    return const Color(0xFF863a3a);
                  }),
                  foregroundColor: WidgetStateProperty.resolveWith<Color>((
                    Set<WidgetState> states,
                  ) {
                    if (states.contains(WidgetState.disabled)) {
                      return const Color(0xC15C4B4B);
                    }
                    return Colors.white;
                  }),
                  minimumSize: WidgetStateProperty.all(const Size(0, 50)),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleOption({
    required IconData icon,
    required String title,
    required String value,
  }) {
    final isSelected = _selectedRole == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFF0E8E2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF863a3a) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            FaIcon(
              icon,
              color:
                  isSelected
                      ? const Color(0xFF863a3a)
                      : const Color(0xC15C4B4B),
              size: 24,
            ),
            const SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: isSelected ? const Color(0xFF863a3a) : Colors.black,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xFF863a3a)),
          ],
        ),
      ),
    );
  }

  Future<void> _saveRoleAndContinue(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_role', role);

    if (!mounted) return;

    if (role == 'client') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeClient()),
      );
    } else if (role == 'cooperative') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Logincooperative()),
      );
    } else if (role == 'designer') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Logindesigner()),
      );
    }
  }
}
