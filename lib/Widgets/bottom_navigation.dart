import 'package:flutter/material.dart';
import 'package:hirfa_frontend/Clients/client_profile.dart';
import 'package:hirfa_frontend/Cooperative/cooperative_profile.dart';
import 'package:hirfa_frontend/Designers/designer_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFFFDFBF7),
      selectedItemColor: const Color(0xFF863a3a),
      unselectedItemColor: const Color(0xFFA0A0A0),
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
      items: [
        BottomNavigationBarItem(icon: const Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: const Icon(Icons.search),
          label: 'Discover',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.shopping_cart),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}

// Profile navigation function
Future<void> navigateToProfile(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final userRole = prefs.getString('user_role');

  if (!context.mounted) return;

  switch (userRole) {
    case 'client':
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ClientProfileScreen()),
      );
      break;
    case 'cooperative':
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CooperativeProfileScreen()),
      );
      break;
    case 'designer':
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DesignerProfileScreen()),
      );
      break;
  }
}
