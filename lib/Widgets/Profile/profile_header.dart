import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String? nom;
  final String prenom;
  final String description;
  const ProfileHeader({
    super.key,
    required this.nom,
    required this.prenom,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: const Color(0xFFF0E8E2),
            child: Text(
              nom != null ? '${prenom[0]}${nom?[0]}' : prenom[0],
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF863a3a),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            nom != null ? '$prenom $nom' : prenom,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xff1a1a1a),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
