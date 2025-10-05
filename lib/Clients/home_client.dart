import 'dart:async';

import 'package:flutter/material.dart';
import "package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart";
import 'package:hirfa_frontend/Clients/Models/product.dart';
import 'package:hirfa_frontend/Clients/ServicesClients/crud_shopping.dart';
import 'package:hirfa_frontend/Clients/ServicesClients/product_service.dart';
import 'package:hirfa_frontend/Clients/client_profile.dart';
import 'package:hirfa_frontend/Clients/shopping_cart.dart';
import 'package:hirfa_frontend/Clients/product_detail_screen.dart';
import 'package:hirfa_frontend/Widgets/bottom_navigation.dart';

class HomeClient extends StatefulWidget {
  const HomeClient({super.key});

  @override
  State<HomeClient> createState() => _HomeClientState();
}

class _HomeClientState extends State<HomeClient> {
  int _currentIndex = 0;
  List<Product> _products = [];
  List<Product> _recommendedProducts = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  final Map<String, Size> _imageSizeCache = {};

  // Filter variables
  double? _minPrice;
  double? _maxPrice;
  double? _minWeight;
  double? _maxWeight;
  String? _dimensionsFilter;

  final List<String> _categories = [
    'All',
    'Crafts',
    'Food',
    'Textiles',
    'Cosmetics',
    'Decoration',
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _loadRecommendedProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final products = await ProductService.getProducts(
        category: _selectedCategory == 'All' ? null : _selectedCategory,
        searchQuery:
            _searchController.text.isEmpty ? null : _searchController.text,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
        // Add more filters when implemented in ProductService
      );
      setState(() {
        _products = products.cast<Product>();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadRecommendedProducts() async {
    // This will be empty if user is not authenticated
    // The AI recommendation system can work based on browsing behavior
    // even without authentication (using local storage)
  }

  void _navigateToProductDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }

  void _showFilterDialog() {
    TextEditingController minPriceController = TextEditingController(
      text: _minPrice?.toString(),
    );
    TextEditingController maxPriceController = TextEditingController(
      text: _maxPrice?.toString(),
    );
    TextEditingController minWeightController = TextEditingController(
      text: _minWeight?.toString(),
    );
    TextEditingController maxWeightController = TextEditingController(
      text: _maxWeight?.toString(),
    );
    TextEditingController dimensionsController = TextEditingController(
      text: _dimensionsFilter,
    );

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: const Text(
                  'Filter products',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Price Range
                      const Text(
                        'Price (DH)',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: minPriceController,
                              decoration: const InputDecoration(
                                hintText: 'Min',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: maxPriceController,
                              decoration: const InputDecoration(
                                hintText: 'Max',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Weight Range
                      const Text(
                        'Weight (kg)',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: minWeightController,
                              decoration: const InputDecoration(
                                hintText: 'Min',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: maxWeightController,
                              decoration: const InputDecoration(
                                hintText: 'Max',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Dimensions Filter
                      const Text(
                        'Dimensions',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: dimensionsController,
                        decoration: const InputDecoration(
                          hintText: 'Ex: 10x20x30',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Reset Filters
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            minPriceController.clear();
                            maxPriceController.clear();
                            minWeightController.clear();
                            maxWeightController.clear();
                            dimensionsController.clear();
                            setState(() {
                              _minPrice = null;
                              _maxPrice = null;
                              _minWeight = null;
                              _maxWeight = null;
                              _dimensionsFilter = null;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF2d6723),
                            side: const BorderSide(color: Color(0xFF2d6723)),
                          ),
                          child: const Text('Reset filters'),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Color(0xFFd5b694)),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _minPrice = double.tryParse(minPriceController.text);
                        _maxPrice = double.tryParse(maxPriceController.text);
                        _minWeight = double.tryParse(minWeightController.text);
                        _maxWeight = double.tryParse(maxWeightController.text);
                        _dimensionsFilter =
                            dimensionsController.text.isEmpty
                                ? null
                                : dimensionsController.text;
                      });
                      _loadProducts();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2d6723),
                    ),
                    child: const Text(
                      'Apply',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
    );
  }

  void _clearFilters() {
    setState(() {
      _minPrice = null;
      _maxPrice = null;
      _minWeight = null;
      _maxWeight = null;
      _dimensionsFilter = null;
      _searchController.clear();
    });
    _loadProducts();
  }

  Future<Size> _fetchImageSize(String url) async {
    if (_imageSizeCache.containsKey(url)) return _imageSizeCache[url]!;

    final completer = Completer<Size>();
    final image = NetworkImage(url);
    final stream = image.resolve(const ImageConfiguration());
    final listener = ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(
        Size(info.image.width.toDouble(), info.image.height.toDouble()),
      );
    });
    stream.addListener(listener);
    final size = await completer.future;
    _imageSizeCache[url] = size;
    return size;
  }

  Widget _buildProductGrid() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF2d6723)),
      );
    }

    if (_products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 60,
              color: const Color(0xFFd5b694),
            ),
            const SizedBox(height: 16),
            const Text(
              'No products found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try changing your filters or your search',
              style: TextStyle(color: Color(0xFF666666)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (_minPrice != null ||
                _maxPrice != null ||
                _searchController.text.isNotEmpty)
              ElevatedButton(
                onPressed: _clearFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2d6723),
                ),
                child: const Text(
                  'Reset filters',
                  style: TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
      );
    }

    return MasonryGridView.count(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 8,
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Product product) {
    final imageUrl =
        product.imageUrls.isNotEmpty ? product.imageUrls.first : null;

    return Card(
      color: const Color(0xFFfdfbf7),
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _navigateToProductDetail(product),
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imageUrl != null)
                  FutureBuilder<Size>(
                    future: _fetchImageSize(imageUrl),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          height: 150,
                          decoration: BoxDecoration(
                            color: const Color(0xFFf5f5f5),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                              color: Color(0xFF2d6723),
                            ),
                          ),
                        );
                      }
                      final aspectRatio =
                          snapshot.data!.width / snapshot.data!.height;
                      return AspectRatio(
                        aspectRatio: aspectRatio,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: const Color(0xFFf5f5f5),
                                child: const Icon(
                                  Icons.image_not_supported_rounded,
                                  color: Color(0xFFd5b694),
                                  size: 40,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  )
                else
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: const Color(0xFFf5f5f5),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.image_rounded,
                        size: 40,
                        color: Color(0xFFd5b694),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.nomProduit,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF1A1A1A),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${product.prix} DH',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2d6723),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.inventory_2,
                            size: 12,
                            color:
                                product.quantiteStock > 0
                                    ? const Color(0xFF2d6723)
                                    : const Color(0xFF863a3a),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Stock: ${product.quantiteStock}',
                            style: TextStyle(
                              fontSize: 10,
                              color:
                                  product.quantiteStock > 0
                                      ? const Color(0xFF2d6723)
                                      : const Color(0xFF863a3a),
                            ),
                          ),
                        ],
                      ),
                      if (product.categorie.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        // Row avec catégorie et icône panier
                        Row(
                          children: [
                            // Catégorie
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2d6723).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                product.categorie,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF2d6723),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const Spacer(),
                            // Icône panier
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2d6723),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF2d6723,
                                    ).withOpacity(0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                onPressed: () => _showAddToCartDialog(product),
                                icon: const Icon(
                                  Icons.shopping_cart_rounded,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.zero,
                                splashRadius: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            // Icône de signalement en haut à droite
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () => _reportProduct(product),
                  icon: const Icon(
                    Icons.report_outlined,
                    size: 16,
                    color: Color.fromARGB(255, 245, 11, 11),
                  ),
                  padding: EdgeInsets.zero,
                  splashRadius: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Méthodes pour les actions des boutons
  // Function to show quantity dialog
  void _showAddToCartDialog(Product product) {
    TextEditingController quantityController = TextEditingController(text: '1');

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Add to Cart',
              style: TextStyle(
                color: Color(0xFF1A1A1A),
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${product.nomProduit}',
                  style: const TextStyle(
                    color: Color(0xFF555555),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Price: ${product.prix} DH',
                  style: const TextStyle(
                    color: Color(0xFF2D6723),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    labelStyle: const TextStyle(
                      color: Color(0xFF555555),
                      fontFamily: 'Poppins',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFD5B694)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF2D6723)),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF555555),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final quantity =
                      int.tryParse(quantityController.text.trim()) ?? 0;
                  if (quantity <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid quantity'),
                        backgroundColor: Color(0xFF863A3A),
                      ),
                    );
                    return;
                  }

                  Navigator.pop(context);
                  _addProductToCart(product, quantity);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D6723),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Add to Cart',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  // Function to add product to cart
  Future<void> _addProductToCart(Product product, int quantity) async {
    try {
      final success = await CrudShopping.addProductToPanier(
        productId: product.productId,
        quantity: quantity,
        unitPrice: product.prix,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$quantity x ${product.nomProduit} added to cart'),
            backgroundColor: const Color(0xFF2D6723),
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add product to cart'),
            backgroundColor: Color(0xFF863A3A),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: const Color(0xFF863A3A),
        ),
      );
    }
  }

  void _reportProduct(Product product) {
    TextEditingController reportController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              'Report Product',
              style: TextStyle(
                color: Color(0xFF1A1A1A),
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Why do you want to report "${product.nomProduit}"?',
                  style: const TextStyle(
                    color: Color(0xFF555555),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: reportController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Please describe the reason for reporting...',
                    hintStyle: const TextStyle(
                      color: Color(0xFFA0A0A0),
                      fontSize: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFD5B694)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF2D6723)),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Color(0xFF555555),
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final reason = reportController.text.trim();
                  if (reason.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please provide a reason for reporting'),
                        backgroundColor: Color(0xFF863A3A),
                      ),
                    );
                    return;
                  }

                  // Logique de signalement avec la raison
                  _submitReport(product, reason);
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '"${product.nomProduit}" has been reported',
                      ),
                      backgroundColor: const Color(0xFF863A3A),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFFFFF),
                  foregroundColor: const Color(0xFF863A3A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Submit Report',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  // Méthode pour soumettre le signalement
  void _submitReport(Product product, String reason) async {
    final success = await ProductService.reportProduct(
      productId: product.productId,
      reason: reason,
    );

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to send report. Please try again.'),
          backgroundColor: Color(0xFF863A3A),
        ),
      );
    }
  }

  Widget _buildRecommendedSection() {
    if (_recommendedProducts.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Recommanded for you',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _recommendedProducts.length,
            itemBuilder: (context, index) {
              final product = _recommendedProducts[index];
              return _buildRecommendedProductCard(product);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedProductCard(Product product) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () => _navigateToProductDetail(product),
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    image:
                        product.imageUrls.isNotEmpty
                            ? DecorationImage(
                              image: NetworkImage(product.imageUrls.first),
                              fit: BoxFit.cover,
                            )
                            : null,
                    color: const Color(0xFFf5f5f5),
                  ),
                  child:
                      product.imageUrls.isEmpty
                          ? const Icon(
                            Icons.image_rounded,
                            color: Color(0xFFd5b694),
                            size: 40,
                          )
                          : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Text(
                      product.nomProduit,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    Text(
                      '${product.prix} DH',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2d6723),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          _currentIndex != 0
              ? null
              : AppBar(
                automaticallyImplyLeading: false,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 10),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: Image.asset(
                        'images/hirfalogo.png',
                        fit: BoxFit.cover,
                        width: 60,
                        height: 60,
                      ),
                    ),
                  ),
                ),
                titleSpacing: 8,
                backgroundColor: const Color(0xFFfdfbf7),
                surfaceTintColor: const Color(0xFFfdfbf7),
                actions: [
                  // Filter button with badge if filters are active
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.filter_list_rounded),
                        onPressed: _showFilterDialog,
                        color: const Color(0xFF1A1A1A),
                      ),
                      if (_minPrice != null ||
                          _maxPrice != null ||
                          _minWeight != null ||
                          _maxWeight != null ||
                          _dimensionsFilter != null)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Color(0xFF863a3a),
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 12,
                              minHeight: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
                actionsPadding: const EdgeInsets.only(right: 10, top: 8),
                toolbarHeight: MediaQuery.of(context).size.height * 0.10,
                centerTitle: true,
                title: Container(
                  padding: const EdgeInsets.only(top: 10),
                  height: 45,
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8),
                      hintText: 'Search a product...',
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: Color(0xFF2d6723),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Color(0xffCCCCCC)),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Color(0xffCCCCCC)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Color(0xffCCCCCC)),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(color: Color(0xFF2d6723)),
                      ),
                    ),
                    onSubmitted: (value) => _loadProducts(),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(50),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 12,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        // Category Chips - Now functional
                        Container(
                          color: Colors.transparent,
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _categories.length,
                            itemBuilder: (context, index) {
                              final category = _categories[index];
                              final isSelected = _selectedCategory == category;
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: FilterChip(
                                  label: Text(
                                    category,
                                    style: TextStyle(
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : const Color(0xFF1A1A1A),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedCategory =
                                          selected ? category : 'All';
                                    });
                                    _loadProducts();
                                  },
                                  selectedColor: const Color(0xFF2d6723),
                                  checkmarkColor: Colors.white,
                                  backgroundColor: const Color(0xFFf5f5f5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      body: _getCurrentPage(),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _getCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return RefreshIndicator(
          onRefresh: _loadProducts,
          color: const Color(0xFF2d6723),
          child: Column(
            children: [
              _buildRecommendedSection(),
              Expanded(child: _buildProductGrid()),
            ],
          ),
        );
      case 1:
        return const Center(child: Text('Discover Page'));
      case 2:
        return ShoppingCart();
      case 3:
        return ClientProfileScreen();
      default:
        return RefreshIndicator(
          onRefresh: _loadProducts,
          child: _buildProductGrid(),
        );
    }
  }
}
