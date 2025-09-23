import 'package:flutter/material.dart';
import 'package:hirfa_frontend/Widgets/bottom_navigation.dart';

class Homedesigner extends StatefulWidget {
  const Homedesigner({super.key});

  @override
  State<Homedesigner> createState() => _HomedesignerState();
}

class _HomedesignerState extends State<Homedesigner> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hirfa - Designer'),
        backgroundColor: const Color(0xFF863a3a),
        foregroundColor: Colors.white,
      ),
      body: _getCurrentPage(),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 3) {
            // Profile tab
            navigateToProfile(context);
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
      ),
    );
  }

  Widget _getCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return _buildDiscoverPage();
      case 2:
        return _buildOrdersPage();
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Welcome Designer!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              navigateToProfile(context);
            },
            child: const Text('Go to Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscoverPage() {
    return const Center(
      child: Text('Discover Page', style: TextStyle(fontSize: 24)),
    );
  }

  Widget _buildOrdersPage() {
    return const Center(
      child: Text('Orders Page', style: TextStyle(fontSize: 24)),
    );
  }
}
