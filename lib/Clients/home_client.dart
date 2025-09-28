import 'package:flutter/material.dart';
import 'package:hirfa_frontend/Clients/view_cooperative_profile.dart';
import 'package:hirfa_frontend/Widgets/bottom_navigation.dart';

class HomeClient extends StatefulWidget {
  const HomeClient({super.key});

  @override
  State<HomeClient> createState() => _HomeClientState();
}

class _HomeClientState extends State<HomeClient> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hirfa - Client'),
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
            'Welcome Client!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigate to profile directly
              navigateToProfile(context);
            },
            child: const Text('Go to Profile'),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              try {
                final cooperativeId =
                    1; // ou récupérer depuis vos données avec product['cooperative_id]
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ViewCooperativeProfile(
                          cooperativeId: cooperativeId,
                        ),
                  ),
                );
              } catch (e) {
                print('Error navigating to cooperative profile: $e');
              }
            },
            child: const Text('view cooperative'),
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
