import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hirfa_frontend/Cooperative/ServicesCooperatives/crud_produit.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProduct extends StatefulWidget {
  final Map<String, dynamic> product;

  const UpdateProduct({super.key, required this.product});

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  final TextEditingController _nomproduitController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _prixController = TextEditingController();
  final TextEditingController _quantiteController = TextEditingController();
  final TextEditingController _poidsController = TextEditingController();
  final TextEditingController _dimensionsController = TextEditingController();

  final List<String> _CategorieTypes = [
    'Crafts',
    'Textiles',
    'Cosmetics',
    'Food',
    'Other',
  ];
  String? selectedCategorie;

  List<XFile> _selectedImages = [];
  List<String> _existingImages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    final product = widget.product;

    _nomproduitController.text = product['nom'] ?? '';
    _descriptionController.text = product['description'] ?? '';
    _prixController.text = (product['prix'] ?? 0.0).toString();
    _quantiteController.text = (product['quantite'] ?? 0).toString();
    _poidsController.text = (product['poids'] ?? 0.0).toString();
    _dimensionsController.text = product['dimensions'] ?? '';

    selectedCategorie = product['categorie'];
    _existingImages = List<String>.from(product['images'] ?? []);
  }

  Future<void> _pickImages() async {
    final List<XFile> images = await ImagePicker().pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images);
      });
    }
  }

  void _removeExistingImage(int index) {
    setState(() {
      _existingImages.removeAt(index);
    });
  }

  void _removeNewImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _updateProduct() async {
    if (_validateForm()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final errorMessage = await CrudProduit.updateCooperativeProduct(
          productId: widget.product['id'].toString(),
          nom_produit: _nomproduitController.text.trim(),
          description: _descriptionController.text.trim(),
          prix: double.parse(_prixController.text.trim()),
          quantite_stock: int.parse(_quantiteController.text.trim()),
          categorie: selectedCategorie!,
          poids: double.parse(_poidsController.text.trim()),
          dimensions: _dimensionsController.text.trim(),
          images: _selectedImages,
        );

        if (errorMessage == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ Product updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true); // Return success
        } else {
          _showError(errorMessage);
        }
      } catch (e) {
        _showError('Error updating product: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  bool _validateForm() {
    if (_nomproduitController.text.trim().isEmpty) {
      _showError('Product name is required');
      return false;
    }
    if (_descriptionController.text.trim().isEmpty) {
      _showError('Description is required');
      return false;
    }
    if (_prixController.text.trim().isEmpty ||
        double.tryParse(_prixController.text.trim()) == null) {
      _showError('Valid price is required');
      return false;
    }
    if (_quantiteController.text.trim().isEmpty ||
        int.tryParse(_quantiteController.text.trim()) == null) {
      _showError('Valid quantity is required');
      return false;
    }
    if (selectedCategorie == null || selectedCategorie!.isEmpty) {
      _showError('Category is required');
      return false;
    }
    if (_poidsController.text.trim().isEmpty ||
        double.tryParse(_poidsController.text.trim()) == null) {
      _showError('Valid weight is required');
      return false;
    }
    if (_dimensionsController.text.trim().isEmpty) {
      _showError('Dimensions are required');
      return false;
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Widget _buildInputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
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
            keyboardType: keyboardType,
            decoration: InputDecoration(
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
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
            ),
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
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
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Update Product',
          style: TextStyle(
            color: Color(0xFF2D6723),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
      ),
      body:
          _isLoading
              ? Center(
                child: CircularProgressIndicator(color: Color(0xFF2D6723)),
              )
              : SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Existing Images
                    if (_existingImages.isNotEmpty) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Images',
                            style: TextStyle(
                              color: Color(0xFF1A1A1A),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(height: 8),
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _existingImages.length,
                              itemBuilder: (context, index) {
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
                                          color: Color(0xFFF5F5F5),
                                          image: DecorationImage(
                                            image: AssetImage(
                                              _existingImages[index],
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 5,
                                        right: 5,
                                        child: GestureDetector(
                                          onTap:
                                              () => _removeExistingImage(index),
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
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ],

                    // Form Fields
                    _buildInputField(
                      label: 'Product Name',
                      icon: Icons.shopping_bag_outlined,
                      controller: _nomproduitController,
                    ),

                    _buildInputField(
                      label: 'Description',
                      icon: Icons.description_outlined,
                      controller: _descriptionController,
                      keyboardType: TextInputType.multiline,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: _buildInputField(
                            label: 'Price (DH)',
                            icon: Icons.attach_money,
                            controller: _prixController,
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildInputField(
                            label: 'Quantity',
                            icon: Icons.inventory_2,
                            controller: _quantiteController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),

                    // Category Dropdown
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Category',
                          style: TextStyle(
                            color: Color(0xFF1A1A1A),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: DropdownButtonFormField<String>(
                            value: selectedCategorie,
                            items:
                                _CategorieTypes.map((String category) {
                                  return DropdownMenuItem<String>(
                                    value: category,
                                    child: Text(
                                      category,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  );
                                }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedCategorie = newValue;
                              });
                            },
                            decoration: InputDecoration(
                              prefixIcon: Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Color(0xFFD5B694).withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.category_rounded,
                                  color: Color(0xFF2D6723),
                                  size: 20,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: _buildInputField(
                            label: 'Weight (kg)',
                            icon: Icons.scale,
                            controller: _poidsController,
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildInputField(
                            label: 'Dimensions',
                            icon: Icons.aspect_ratio,
                            controller: _dimensionsController,
                          ),
                        ),
                      ],
                    ),

                    // Add New Images Button
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
                          "Add New Images",
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
                          side: BorderSide(color: Color(0xFF2D6723), width: 2),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // New Images Preview
                    if (_selectedImages.isNotEmpty) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'New Images to Add',
                            style: TextStyle(
                              color: Color(0xFF1A1A1A),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(height: 8),
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _selectedImages.length,
                              itemBuilder: (context, index) {
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
                                              File(_selectedImages[index].path),
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 5,
                                        right: 5,
                                        child: GestureDetector(
                                          onTap: () => _removeNewImage(index),
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
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ],

                    // Update Button
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
                        onPressed: _updateProduct,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2D6723),
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Update Product',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
