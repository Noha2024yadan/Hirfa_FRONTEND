import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hirfa_frontend/Widgets/Profile/info_card.dart';
import 'package:hirfa_frontend/Widgets/Profile/info_row.dart';
import 'package:hirfa_frontend/Widgets/Profile/logout_button.dart';
import 'package:hirfa_frontend/Widgets/Profile/profile_header.dart';
import 'package:hirfa_frontend/Widgets/Profile/section_title.dart';
import 'package:hirfa_frontend/edit_profile.dart';
import 'package:hirfa_frontend/Clients/ServicesClients/profile_client.dart';

class ClientProfileScreen extends StatefulWidget {
  const ClientProfileScreen({super.key});

  @override
  State<ClientProfileScreen> createState() => _ClientProfileScreenState();
}

class _ClientProfileScreenState extends State<ClientProfileScreen> {
  Map<String, dynamic> _clientData = {};
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final profileData = await ProfileClient.getProfile();
      setState(() {
        _clientData = profileData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load profile: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Profile'),
        backgroundColor: const Color(0xFF863a3a),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 24.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header
                    ProfileHeader(
                      prenom: _clientData['prenom'] ?? 'John',
                      nom: _clientData['nom'] ?? 'Doe',
                      description: _clientData['email'] ?? ' ',
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
                                      userData: _clientData,
                                      userType: 'client',
                                    ),
                              ),
                            ).then((updatedData) {
                              if (updatedData != null) {
                                _loadProfileData(); // Reload profile data
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
                          value: _clientData['prenom'] ?? 'Not specified',
                        ),
                        InfoRow(
                          label: 'Last Name',
                          value: _clientData['nom'] ?? 'Not specified',
                        ),
                        InfoRow(
                          label: 'Email',
                          value: _clientData['email'] ?? 'Not provided',
                        ),
                        InfoRow(
                          label: 'Phone',
                          value: _clientData['telephone'] ?? 'Not provided',
                        ),
                        InfoRow(
                          label: 'Address',
                          value: _clientData['adresse'] ?? 'Not provided',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Account Information
                    SectionTitle(title: 'Account Information'),
                    const SizedBox(height: 10),
                    InfoCard(
                      children: [
                        InfoRow(
                          label: 'Member Since',
                          value: _formatDate(_clientData['date_creation']),
                        ),
                        InfoRow(
                          label: 'Last Login',
                          value: _formatDate(_clientData['derniere_connexion']),
                        ),
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
