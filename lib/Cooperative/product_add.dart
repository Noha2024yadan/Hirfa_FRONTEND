import 'package:flutter/material.dart';
import 'package:hirfa_frontend/Cooperative/ServicesCooperatives/crud_produit.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProductAdd extends StatefulWidget {
  const ProductAdd({super.key});

  @override
  State<ProductAdd> createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {
  String? nom_produit;
  String? description;
  double? prix;
  int? quantite_stock;
  String? categorie;
  double? poids;
  String? dimensions;
  List<XFile> _selectedImages = [];
  bool _hasUnsavedChanges = false;

  final List<String> _CategorieTypes = [
    'Crafts',
    'Textiles',
    'Cosmetics',
    'Food',
    'Other',
  ];
  //pour stocker la selection
  String? selectedCategorie;

  final TextEditingController _nomproduitController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _prixController = TextEditingController();
  final TextEditingController _quantiteController = TextEditingController();
  final TextEditingController _categorieController = TextEditingController();
  final TextEditingController _poidsController = TextEditingController();
  final TextEditingController _dimensionsController = TextEditingController();
  Future<void> _pickImages() async {
    final List<XFile> images = await ImagePicker().pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images);
        _hasUnsavedChanges = true;
      });
    }
  }

  Future<void> _handleProduct() async {
    final nom = _nomproduitController.text.trim();
    final desc = _descriptionController.text.trim();
    final prixText = _prixController.text.trim();
    final quantiteText = _quantiteController.text.trim();
    final cat = selectedCategorie ?? _categorieController.text.trim();
    final poidsText = _poidsController.text.trim();
    final dim = _dimensionsController.text.trim();

    // Vérifications avant conversion
    if (nom.isEmpty) {
      _showError("Product name is required.");
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
    if (quantiteText.isEmpty) {
      _showError("Quantity is required.");
      return;
    }
    if (cat.isEmpty) {
      _showError("Category is required.");
      return;
    }
    if (poidsText.isEmpty) {
      _showError("Weight is required.");
      return;
    }
    if (dim.isEmpty) {
      _showError("Dimensions is required.");
      return;
    }

    // Conversions sécurisées
    try {
      prix = double.parse(prixText);
      quantite_stock = int.parse(quantiteText);
      poids = double.parse(poidsText);
    } catch (e) {
      _showError("Veuillez entrer des valeurs numériques valides.");
      return;
    }

    nom_produit = nom;
    description = desc;
    categorie = cat;
    dimensions = dim;

    // Appel API
    final errorMessage = await CrudProduit.addProduct(
      nom_produit: nom_produit!,
      description: description!,
      prix: prix!,
      quantite_stock: quantite_stock!,
      categorie: categorie!,
      poids: poids!,
      dimensions: dimensions!,
      images: _selectedImages,
    );

    if (errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("✅ Produit ajouté avec succès."),
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
          'Add New Product',
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
                            'Create New Product',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Share your amazing product with the world!',
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
                hint: "Product Name",
                icon: Icons.shopping_bag_outlined,
                controller: _nomproduitController,
              ),
              SizedBox(height: 16),

              InputText(
                hint: "Product Description",
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
                  SizedBox(width: 12),
                  Expanded(
                    child: InputText(
                      hint: "Quantity",
                      icon: Icons.inventory_2,
                      controller: _quantiteController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Category Dropdown
              Container(
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
                      _categorieController.text = newValue ?? '';
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Product Category",
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
                      child: Icon(
                        Icons.category_rounded,
                        color: Color(0xFF2D6723),
                        size: 20,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: InputText(
                      hint: "Weight (kg)",
                      icon: Icons.scale,
                      controller: _poidsController,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: InputText(
                      hint: "Dimensions",
                      icon: Icons.aspect_ratio,
                      controller: _dimensionsController,
                    ),
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
                    "Add Product Images",
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
                                      borderRadius: BorderRadius.circular(12),
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
                          },
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
                  onPressed: _handleProduct,
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
                        'Create Product',
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
