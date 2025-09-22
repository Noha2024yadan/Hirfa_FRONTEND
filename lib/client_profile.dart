import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hirfa_frontend/Widgets/Profile/info_card.dart';
import 'package:hirfa_frontend/Widgets/Profile/info_row.dart';
import 'package:hirfa_frontend/Widgets/Profile/logout_button.dart';
import 'package:hirfa_frontend/Widgets/Profile/profile_header.dart';
import 'package:hirfa_frontend/Widgets/Profile/section_title.dart';
import 'package:hirfa_frontend/edit_profile.dart';

class ClientProfileScreen extends StatefulWidget {
  final Map<String, dynamic> clientData;

  const ClientProfileScreen({super.key, required this.clientData});

  @override
  State<ClientProfileScreen> createState() => _ClientProfileScreenState();
}

class _ClientProfileScreenState extends State<ClientProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Profile'),
        backgroundColor: const Color(0xFF863a3a),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            ProfileHeader(
              prenom: widget.clientData['prenom'] ?? 'John',
              nom: widget.clientData['nom'] ?? 'Doe',
              description: widget.clientData['email'] ?? ' ',
            ),
            const SizedBox(height: 16),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => EditProfileScreen(
                              userData: widget.clientData,
                              userType: 'client',
                            ),
                      ),
                    ).then((updatedData) {
                      if (updatedData != null) {
                        // Update your local state with the new data
                        setState(() {
                          // Update the relevant fields from updatedData
                        });
                      }
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    side: const BorderSide(color: Color(0xFF2d6723)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.pen,
                        size: 14,
                        color: Color(0xff2d6723),
                      ),
                      SizedBox(width: 12),
                      const Text(
                        'Edit profile',
                        style: TextStyle(color: Color(0xFF2d6723)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Personal Information
            SectionTitle(title: 'Personal Information'),
            const SizedBox(height: 10),
            InfoCard(
              children: [
                InfoRow(
                  label: 'First Name',
                  value: widget.clientData['prenom'],
                ),
                InfoRow(label: 'Last Name', value: widget.clientData['nom']),
                InfoRow(
                  label: 'Email',
                  value: widget.clientData['email'] ?? 'Not provided',
                ),
                InfoRow(
                  label: 'Phone',
                  value: widget.clientData['telephone'] ?? 'Not provided',
                ),
                InfoRow(
                  label: 'Address',
                  value: widget.clientData['adresse'] ?? 'Not provided',
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Account Information
            SectionTitle(title: 'Account Information'),
            const SizedBox(height: 10),
            InfoCard(
              children: [
                // InfoRow(
                //   label: 'Username',
                //   value: widget.clientData['username'] ?? 'Not provided',
                // ),
                InfoRow(
                  label: 'Member Since',
                  value: _formatDate(widget.clientData['date_creation']),
                ),
                InfoRow(
                  label: 'Last Login',
                  value: _formatDate(widget.clientData['derniere_connexion']),
                ),
                // InfoRow(
                //  label: 'Status',
                //  value: widget.clientData['statut'] == true ? 'Active' : 'Inactive',
                // ),
              ],
            ),

            const SizedBox(height: 32),

            // Logout Button
            LogoutButton(),
          ],
        ),
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'Not available';
    try {
      final DateTime dateTime = DateTime.parse(date.toString());
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return 'Invalid date';
    }
  }
}
