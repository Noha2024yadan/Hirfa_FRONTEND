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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildNavItem(0, Icons.home, 'Home'),
          _buildNavItem(1, Icons.search, 'Order\nTracking'),
          _buildNavItem(2, Icons.shopping_cart, 'Shopping\nCart'),
          _buildNavItem(3, Icons.person, 'Profile'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = currentIndex == index;
    final color = isSelected ? const Color(0xFF2d6723) : Colors.grey;
    final fontWeight = isSelected ? FontWeight.w600 : FontWeight.w500;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap(index),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(height: 4),
                Text(
                  label,
                  textAlign: TextAlign.center, // This centers the text
                  style: TextStyle(
                    color: color,
                    fontWeight: fontWeight,
                    fontSize: 12, // Keep your original font size
                    height: 1.2, // Controls line height for multi-line text
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Alternative: If you want to keep using BottomNavigationBar with centered labels
class CenteredBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CenteredBottomNavigationBar({
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
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF2d6723),
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12, // Your original font size
        height: 1.2,
      ),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 12, // Your original font size
        height: 1.2,
      ),
      items: [
        _buildBottomNavItem(Icons.home, 'Home'),
        _buildBottomNavItem(Icons.search, 'Order\nTracking'),
        _buildBottomNavItem(Icons.shopping_cart, 'Shopping\nCart'),
        _buildBottomNavItem(Icons.person, 'Profile'),
      ],
    );
  }

  BottomNavigationBarItem _buildBottomNavItem(IconData icon, String label) {
    return BottomNavigationBarItem(icon: Icon(icon), label: label);
  }
}

// Profile navigation function (unchanged)
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
