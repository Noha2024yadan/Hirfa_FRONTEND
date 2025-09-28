import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hirfa_frontend/Designers/ServicesDesigners/profile_designer.dart';
import 'package:hirfa_frontend/Widgets/Profile/info_card.dart';
import 'package:hirfa_frontend/Widgets/Profile/info_row.dart';
import 'package:hirfa_frontend/Widgets/Profile/logout_button.dart';
import 'package:hirfa_frontend/Widgets/Profile/profile_header.dart';
import 'package:hirfa_frontend/Widgets/Profile/section_title.dart';
import 'package:hirfa_frontend/edit_profile.dart';

class DesignerProfileScreen extends StatefulWidget {
  const DesignerProfileScreen({super.key});

  @override
  State<DesignerProfileScreen> createState() => _DesignerProfileScreenState();
}

class _DesignerProfileScreenState extends State<DesignerProfileScreen> {
  Map<String, dynamic> _designerData = {};
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final profileData = await ProfileDesigner.getProfile();
      setState(() {
        _designerData = profileData;
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
                      prenom: _designerData['prenom'] ?? 'Jogn',
                      nom: _designerData['nom'] ?? 'Doe',
                      description: _designerData['specialites'] ?? 'Designer',
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
                                      userData: _designerData,
                                      userType: 'designer',
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
                    // Professional Information
                    SectionTitle(title: 'Professional Information'),
                    const SizedBox(height: 10),
                    InfoCard(
                      children: [
                        InfoRow(
                          label: 'First Name',
                          value: _designerData['prenom'],
                        ),
                        InfoRow(
                          label: 'Last Name',
                          value: _designerData['nom'],
                        ),
                        InfoRow(
                          label: 'Specialties',
                          value:
                              _designerData['specialites'] ?? 'Not specified',
                        ),
                        InfoRow(
                          label: 'Hourly Rate',
                          value:
                              _designerData['tarifs'] != null
                                  ? '\$${_designerData['tarifs']}'
                                  : 'Not specified',
                        ),
                        InfoRow(
                          label: 'Portfolio',
                          value: _designerData['portfolio'] ?? 'Not provided',
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Contact Information
                    SectionTitle(title: 'Contact Information'),
                    const SizedBox(height: 10),
                    InfoCard(
                      children: [
                        InfoRow(
                          label: 'Email',
                          value: _designerData['email'] ?? 'Not provided',
                        ),
                        InfoRow(
                          label: 'Phone',
                          value: _designerData['telephone'] ?? 'Not provided',
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
                        //   value: _designerData['username'] ?? 'Not provided',
                        // ),
                        InfoRow(
                          label: 'Member Since',
                          value: _formatDate(_designerData['date_creation']),
                        ),
                        InfoRow(
                          label: 'Last Login',
                          value: _formatDate(
                            _designerData['derniere_connexion'],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // logout Button
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
