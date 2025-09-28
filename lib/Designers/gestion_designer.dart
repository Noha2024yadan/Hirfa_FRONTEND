import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hirfa_frontend/Designers/design_add.dart';
import 'package:hirfa_frontend/Designers/designer_profile.dart';
import 'package:hirfa_frontend/Designers/discover_designer.dart';
import 'package:hirfa_frontend/Designers/home_designer.dart';

class GestionDesigner extends StatefulWidget {
  const GestionDesigner({super.key});

  @override
  State<GestionDesigner> createState() => _GestionDesignerState();
}

class _GestionDesignerState extends State<GestionDesigner> {
  int currentIndex = 0;
  final List<Widget> pages = const [
    HomeDesigner(),
    DiscoverDesigner(),
    DesignerProfileScreen(),
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
                      MaterialPageRoute(builder: (context) => DesignAdd()),
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
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
