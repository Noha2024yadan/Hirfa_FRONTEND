import 'package:flutter/material.dart';
import 'package:hirfa_frontend/Designers/ServicesDesigners/crud_design.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class DesignAdd extends StatefulWidget {
  const DesignAdd({super.key});

  @override
  State<DesignAdd> createState() => _DesignAddState();
}

class _DesignAddState extends State<DesignAdd> {
  String? nom_design;
  String? description;
  double? prix;
  bool statut = false;
  List<XFile> _selectedImages = [];
  bool _hasUnsavedChanges = false;

  final TextEditingController _nomdesignController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _prixController = TextEditingController();

  Future<void> _pickImages() async {
    final List<XFile> images = await ImagePicker().pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images);
        _hasUnsavedChanges = true;
      });
    }
  }

  Future<void> _handleDesign() async {
    final nom = _nomdesignController.text.trim();
    final desc = _descriptionController.text.trim();
    final prixText = _prixController.text.trim();

    // Vérifications avant conversion
    if (nom.isEmpty) {
      _showError("Design name is required.");
      return;
    }
    if (desc.isEmpty) {
      _showError("Description is required.");
      return;
    }
    if (prixText.isEmpty) {
      _showError("price is required.");
      return;
    }

    // Conversions sécurisées
    try {
      prix = double.parse(prixText);
    } catch (e) {
      _showError("Veuillez entrer des valeurs numériques valides.");
      return;
    }

    nom_design = nom;
    description = desc;

    // Appel API
    final errorMessage = await CrudDesign.addDesign(
      nom_design: nom_design!,
      description: description!,
      prix: prix!,
      statut: statut,
      images: _selectedImages,
    );

    if (errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("✅ Design added with success."),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      _showError(errorMessage);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Widget InputText({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
            fontFamily: 'Poppins',
          ),
          prefixIcon: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFFD5B694).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Color(0xFF2D6723), size: 20),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
        style: TextStyle(
          color: Colors.black87,
          fontSize: 16,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Color(0xFF2D6723)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Add New Design',
          style: TextStyle(
            color: Color(0xFF2D6723),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Color(0xFF2D6723).withOpacity(0.1),
              child: Icon(
                Icons.shopping_bag_rounded,
                color: Color(0xFF2D6723),
                size: 20,
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header Illustration
              Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.only(bottom: 30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF2D6723).withOpacity(0.8),
                      Color(0xFFD5B694).withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add_photo_alternate_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create New Design',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Share your amazing Design with the world!',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Form Fields
              InputText(
                hint: "Design Name",
                icon: Icons.shopping_bag_outlined,
                controller: _nomdesignController,
              ),
              SizedBox(height: 16),

              InputText(
                hint: "Design Description",
                icon: Icons.description_outlined,
                controller: _descriptionController,
              ),
              SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: InputText(
                      hint: "Price",
                      icon: Icons.attach_money,
                      controller: _prixController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Statut",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF555555),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<bool>(
                          title: const Text(
                            "Available",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                            ),
                          ),
                          value: true,
                          groupValue: statut,
                          activeColor: Color(0xFF2D6723),
                          onChanged: (value) {
                            setState(() => statut = value!);
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<bool>(
                          title: const Text(
                            "Unavailable",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                            ),
                          ),
                          value: false,
                          groupValue: statut,
                          activeColor: Color(0xFF863A3A),
                          onChanged: (value) {
                            setState(() => statut = value!);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 24),

              // Add Images Button
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFD5B694).withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: _pickImages,
                  icon: Icon(Icons.photo_camera_rounded, size: 22),
                  label: Text(
                    "Add Design Images",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF2D6723),
                    minimumSize: Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    side: BorderSide(color: Color(0xFFD5B694), width: 2),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Selected Images Preview
              if (_selectedImages.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.photo_library_rounded,
                            color: Color(0xFF2D6723),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Selected Images (${_selectedImages.length})',
                            style: TextStyle(
                              color: Color(0xFF2D6723),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      SizedBox(
                        height: 100,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children:
                                _selectedImages.map((image) {
                                  final index = _selectedImages.indexOf(image);
                                  return Container(
                                    margin: EdgeInsets.only(right: 12),
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            image: DecorationImage(
                                              image: FileImage(
                                                File(image.path),
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 5,
                                          right: 5,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _selectedImages.removeAt(index);
                                              });
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.close_rounded,
                                                size: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              SizedBox(height: 30),

              // Submit Button
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF2D6723).withOpacity(0.3),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _handleDesign,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2D6723),
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_rounded, size: 22),
                      SizedBox(width: 8),
                      Text(
                        'Create Design',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
