import 'package:flutter/material.dart';
import 'package:hirfa_frontend/Clients/ServicesClients/profile_client.dart';
import 'package:hirfa_frontend/Cooperative/ServicesCooperatives/profile_cooperative.dart';
import 'package:hirfa_frontend/Designers/ServicesDesigners/profile_designer.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String userType; // 'client', 'cooperative', or 'designer'

  const EditProfileScreen({
    super.key,
    required this.userData,
    required this.userType,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _descriptionController;
  late TextEditingController _specialtiesController;
  late TextEditingController _hourlyRateController;
  late TextEditingController _portfolioController;
  late TextEditingController _licenseController;
  late TextEditingController _usernameController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current values
    _firstNameController = TextEditingController(
      text: widget.userData['prenom'] ?? '',
    );
    _lastNameController = TextEditingController(
      text: widget.userData['nom'] ?? '',
    );
    _emailController = TextEditingController(
      text: widget.userData['email'] ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.userData['telephone'] ?? '',
    );
    _addressController = TextEditingController(
      text: widget.userData['adresse'] ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.userData['description'] ?? '',
    );
    _specialtiesController = TextEditingController(
      text: widget.userData['specialites'] ?? '',
    );
    _hourlyRateController = TextEditingController(
      text: widget.userData['tarifs']?.toString() ?? '',
    );
    _portfolioController = TextEditingController(
      text: widget.userData['portfolio'] ?? '',
    );
    _licenseController = TextEditingController(
      text: widget.userData['licence'] ?? '',
    );
    _usernameController = TextEditingController(
      text: widget.userData['username'] ?? '',
    );
  }

  @override
  void dispose() {
    // Dispose all controllers
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _specialtiesController.dispose();
    _hourlyRateController.dispose();
    _portfolioController.dispose();
    _licenseController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: const Color(0xFF863a3a),
        foregroundColor: Colors.white,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Personal Information Section
              if (widget.userType == 'client' ||
                  widget.userType == 'designer') ...[
                _buildSectionTitle('Personal Information'),
                const SizedBox(height: 16),
                if (widget.userType == 'client' ||
                    widget.userType == 'designer')
                  _buildTextField('First Name', _firstNameController),
                if (widget.userType == 'client' ||
                    widget.userType == 'designer')
                  _buildTextField('Last Name', _lastNameController),
                _buildTextField('Email', _emailController, isEmail: true),
                _buildTextField('Phone', _phoneController, isNumeric: true),
                if (widget.userType != 'designer')
                  _buildTextField('Address', _addressController),
                const SizedBox(height: 24),
              ],

              // Professional Information Section
              if (widget.userType == 'designer') ...[
                _buildSectionTitle('Professional Information'),
                const SizedBox(height: 16),
                _buildTextField('Specialties', _specialtiesController),
                _buildTextField(
                  'Hourly Rate',
                  _hourlyRateController,
                  isNumeric: true,
                ),
                _buildTextField('Portfolio URL', _portfolioController),
                const SizedBox(height: 24),
              ],

              // Cooperative Information Section
              if (widget.userType == 'cooperative') ...[
                _buildSectionTitle('Cooperative Information'),
                const SizedBox(height: 16),
                _buildTextField('Cooperative Name', _usernameController),
                _buildTextField(
                  'Description',
                  _descriptionController,
                  maxLines: 3,
                ),
                _buildTextField('License', _licenseController),
                _buildTextField('Address', _addressController),
                const SizedBox(height: 16),

                // Contact Information for Cooperative
                _buildSectionTitle('Contact Information'),
                const SizedBox(height: 16),
                _buildTextField('Email', _emailController, isEmail: true),
                _buildTextField('Phone', _phoneController, isNumeric: true),
                const SizedBox(height: 24),
              ],
              // Buttons Section
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed:
                          _isSaving
                              ? null
                              : () {
                                Navigator.pop(context);
                              },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: Color(0xFF863a3a)),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color(0xFF863a3a),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2d6723),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:
                          _isSaving
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                              : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Save',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFF863a3a),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isNumeric = false,
    bool isEmail = false,
    int maxLines = 1,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF5C4B4B),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType:
                isNumeric
                    ? TextInputType.number
                    : isEmail
                    ? TextInputType.emailAddress
                    : TextInputType.text,
            maxLines: maxLines,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF5C4B4B)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF5C4B4B)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF2d6723)),
              ),
              filled: true,
              fillColor: const Color(0xFFF9F5F0),
            ),
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              color: Color(0xff1a1a1a),
            ),
          ),
        ],
      ),
    );
  }

  void _saveChanges() async {
    setState(() {
      _isSaving = true;
    });

    // Prepare the updated data
    Map<String, dynamic> updatedData = {};

    if (widget.userType == 'client' || widget.userType == 'designer') {
      updatedData['prenom'] = _firstNameController.text;
      updatedData['nom'] = _lastNameController.text;
    }

    updatedData['email'] = _emailController.text;
    updatedData['telephone'] = _phoneController.text;
    updatedData['adresse'] = _addressController.text;

    if (widget.userType == 'cooperative') {
      updatedData['username'] = _usernameController.text;
      updatedData['description'] = _descriptionController.text;
      updatedData['licence'] = _licenseController.text;
    }

    if (widget.userType == 'designer') {
      updatedData['specialites'] = _specialtiesController.text;
      updatedData['tarifs'] = double.tryParse(_hourlyRateController.text);
      updatedData['portfolio'] = _portfolioController.text;
    }

    String? errorMessage;

    try {
      switch (widget.userType) {
        case 'client':
          errorMessage = await ProfileClient.updateProfile(updatedData);
          break;
        case 'cooperative':
          errorMessage = await ProfileCooperative.updateProfile(updatedData);
          break;
        case 'designer':
          errorMessage = await ProfileDesigner.updateProfile(updatedData);
          break;
        default:
          errorMessage = 'Invalid user type';
      }
    } catch (e) {
      errorMessage = 'Network error occurred';
    }

    setState(() {
      _isSaving = false;
    });

    if (errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, updatedData);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }
  }
}
