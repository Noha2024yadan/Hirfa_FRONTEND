import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hirfa_frontend/Cooperative/cooperative_profile.dart';
import 'package:hirfa_frontend/Cooperative/discover_cooperative.dart';
import 'package:hirfa_frontend/Cooperative/home_cooperative.dart';
import 'package:hirfa_frontend/Cooperative/order_cooperative.dart';
import 'package:hirfa_frontend/Cooperative/product_add.dart';

class GestionCooperative extends StatefulWidget {
  const GestionCooperative({super.key});

  @override
  State<GestionCooperative> createState() => _GestionCooperativeState();
}

class _GestionCooperativeState extends State<GestionCooperative> {
  int currentIndex = 0;
  final List<Widget> pages = const [
    Homecooperative(),
    DiscoverCooperative(),
    OrderCooperative(),
    CooperativeProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2.0,
        automaticallyImplyLeading: false,
        titleSpacing: 0, // pour coller l'image à gauche
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 👈 Image à gauche
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Image.asset(
                "images/hirfalogo.png",
                height: 100,
                fit: BoxFit.contain,
              ),
            ),

            // 👉 Icônes à droite
            Row(
              children: [
                IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.plus,
                    color: Colors.black, // couleur par défaut
                  ),
                  // ← Icône FontAwesome
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductAdd()),
                    );
                  },
                ),
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.comment, color: Colors.black),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        selectedItemColor: const Color(0xFF2d6723),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Discover'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Orders',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
