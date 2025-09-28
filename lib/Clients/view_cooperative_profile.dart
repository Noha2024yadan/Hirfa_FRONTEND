import 'package:flutter/material.dart';
import 'package:hirfa_frontend/Clients/ServicesClients/cooperative_details.dart';

class ViewCooperativeProfile extends StatefulWidget {
  const ViewCooperativeProfile({super.key, required this.cooperativeId});

  final int cooperativeId;

  @override
  State<ViewCooperativeProfile> createState() => _ViewCooperativeProfileState();
}

class _ViewCooperativeProfileState extends State<ViewCooperativeProfile> {
  Map<String, dynamic>? _cooperativeInfo;
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _loadCooperativeData();
  }

  Future<void> _loadCooperativeData() async {
    try {
      setState(() {
        _isLoading = true;
        _isError = false;
      });

      final cooperativeInfo = await CooperativeDetails.getCooperativeInfo(
        widget.cooperativeId.toString(),
      );
      final products = await CooperativeDetails.getProductsByCooperativeId(
        widget.cooperativeId.toString(),
      );

      setState(() {
        _cooperativeInfo = cooperativeInfo;
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isError = true;
        _isLoading = false;
      });
    }
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFF2D6723)),
          SizedBox(height: 20),
          Text(
            'Loading cooperative...',
            style: TextStyle(
              color: Color(0xFF666666),
              fontSize: 16,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60, color: Colors.red),
          SizedBox(height: 16),
          Text(
            'Failed to load',
            style: TextStyle(
              color: Color(0xFF555555),
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Please try again',
            style: TextStyle(
              color: Color(0xFF777777),
              fontSize: 14,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _loadCooperativeData,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2D6723),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildCooperativeHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar circulaire
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2D6723), Color(0xFF3A7E2D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF2D6723).withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              Icons.storefront_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
          SizedBox(height: 20),

          // Nom de la coopérative
          Text(
            _cooperativeInfo?['brand_name'] ?? 'Cooperative',
            style: TextStyle(
              color: Color(0xFF1A1A1A),
              fontSize: 24,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),

          // Description
          Text(
            _cooperativeInfo?['description'] ?? 'No description available',
            style: TextStyle(
              color: Color(0xFF666666),
              fontSize: 15,
              height: 1.4,
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),

          // Informations de contact
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                _buildContactItem(
                  Icons.location_on_rounded,
                  'Address',
                  _cooperativeInfo?['address'] ?? 'N/A',
                ),
                SizedBox(height: 16),
                _buildContactItem(
                  Icons.email_rounded,
                  'Email',
                  _cooperativeInfo?['email'] ?? 'N/A',
                ),
                SizedBox(height: 16),
                _buildContactItem(
                  Icons.phone_rounded,
                  'Phone',
                  _cooperativeInfo?['phone'] ?? 'N/A',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String title, String value) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0xFF2D6723).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Color(0xFF2D6723), size: 20),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 12,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: Color(0xFF1A1A1A),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
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
        children: [
          // Product Image and Info
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xFFF5F5F5),
                    image:
                        product['images'] != null &&
                                product['images'].isNotEmpty &&
                                product['images'][0] != null
                            ? DecorationImage(
                              image: AssetImage(product['images'][0]),
                              fit: BoxFit.cover,
                            )
                            : null,
                  ),
                  child:
                      product['images'] == null ||
                              product['images'].isEmpty ||
                              product['images'][0] == null
                          ? Icon(
                            Icons.photo,
                            color: Color(0xFFD5B694),
                            size: 30,
                          )
                          : null,
                ),
                SizedBox(width: 12),

                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['nom'] ?? 'No Name',
                        style: TextStyle(
                          color: Color(0xFF1A1A1A),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        product['description'] ?? 'No description',
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 10),

                      // Price and Quantity
                      Row(
                        children: [
                          _buildInfoChip(
                            '${product['prix']?.toStringAsFixed(2) ?? '0.00'} DH',
                            Icons.attach_money,
                          ),
                          SizedBox(width: 8),
                          _buildInfoChip(
                            '${product['quantite'] ?? '0'} in stock',
                            Icons.inventory_2,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),

                      // Weight and Dimensions
                      Row(
                        children: [
                          _buildInfoChip(
                            '${product['poids'] ?? '0'} kg',
                            Icons.scale,
                          ),
                          SizedBox(width: 8),
                          _buildInfoChip(
                            product['dimensions'] ?? 'N/A',
                            Icons.aspect_ratio,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),

                      // Category
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(product['categorie']),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          product['categorie'] ?? 'Uncategorized',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Action Buttons avec icône Add to Cart
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFFF8F9FA),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                // Bouton Add to Cart avec icône
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Add to cart functionality
                    },
                    icon: Icon(Icons.shopping_cart_rounded, size: 18),
                    label: Text(
                      'Add to Cart',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2D6723),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                SizedBox(width: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xFF2D6723).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Color(0xFF2D6723)),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: Color(0xFF2D6723),
              fontSize: 10,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String? category) {
    switch (category?.toLowerCase()) {
      case 'cosmetics':
        return Color(0xFF863A3A);
      case 'food':
        return Color(0xFF2D6723);
      case 'crafts':
        return Color(0xFFD5B694);
      case 'textiles':
        return Color(0xFF1A1A1A);
      default:
        return Color(0xFF555555);
    }
  }

  Widget _buildProductsSection() {
    if (_products.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 60,
              color: Color(0xFFD5B694),
            ),
            SizedBox(height: 16),
            Text(
              'No Products Available',
              style: TextStyle(
                color: Color(0xFF555555),
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 8),
            Text(
              'This cooperative has no products yet',
              style: TextStyle(
                color: Color(0xFF777777),
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Products (${_products.length})',
            style: TextStyle(
              color: Color(0xFF1A1A1A),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 16),
          ..._products.map((product) => _buildProductCard(product)).toList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Color(0xFF2D6723)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Cooperative',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
      ),
      body:
          _isLoading
              ? _buildLoadingState()
              : _isError
              ? _buildErrorState()
              : RefreshIndicator(
                onRefresh: _loadCooperativeData,
                color: Color(0xFF2D6723),
                child: ListView(
                  children: [
                    _buildCooperativeHeader(),
                    _buildProductsSection(),
                  ],
                ),
              ),
    );
  }
}
