import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hirfa_frontend/Cooperative/ServicesCooperatives/profile_cooperative.dart';
import 'package:hirfa_frontend/Widgets/Profile/info_card.dart';
import 'package:hirfa_frontend/Widgets/Profile/info_row.dart';
import 'package:hirfa_frontend/Widgets/Profile/logout_button.dart';
import 'package:hirfa_frontend/Widgets/Profile/profile_header.dart';
import 'package:hirfa_frontend/Widgets/Profile/section_title.dart';
import 'package:hirfa_frontend/edit_profile.dart';

class CooperativeProfileScreen extends StatefulWidget {
  const CooperativeProfileScreen({super.key});

  @override
  State<CooperativeProfileScreen> createState() =>
      _CooperativeProfileScreenState();
}

class _CooperativeProfileScreenState extends State<CooperativeProfileScreen> {
  Map<String, dynamic> _cooperativeData = {};
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final profileData = await ProfileCooperative.getProfile();
      setState(() {
        _cooperativeData = profileData;
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
                      prenom: _cooperativeData['brand'] ?? 'Cooperative',
                      description:
                          _cooperativeData['description'] ??
                          'Artisan Cooperative',
                      nom: null,
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
                                      userData: _cooperativeData,
                                      userType: 'cooperative',
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
                    // Cooperative Information
                    SectionTitle(title: 'Cooperative Information'),
                    const SizedBox(height: 10),
                    InfoCard(
                      children: [
                        InfoRow(
                          label: 'Cooperative Name',
                          value: _cooperativeData['brand'] ?? 'Not provided',
                        ),
                        InfoRow(
                          label: 'Description',
                          value:
                              _cooperativeData['description'] ??
                              'No description',
                        ),
                        InfoRow(
                          label: 'License',
                          value: _cooperativeData['licence'] ?? 'Not provided',
                        ),
                        InfoRow(
                          label: 'Address',
                          value: _cooperativeData['adresse'] ?? 'Not provided',
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
                          value: _cooperativeData['email'] ?? 'Not provided',
                        ),
                        InfoRow(
                          label: 'Phone',
                          value:
                              _cooperativeData['telephone'] ?? 'Not provided',
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
                          value: _formatDate(_cooperativeData['date_creation']),
                        ),
                        InfoRow(
                          label: 'Last Login',
                          value: _formatDate(
                            _cooperativeData['derniere_connexion'],
                          ),
                        ),
                        InfoRow(
                          label: 'Verification',
                          value:
                              _cooperativeData['statut_verification'] == true
                                  ? 'Verified'
                                  : 'Not Verified',
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
