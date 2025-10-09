import 'package:flutter/material.dart';
import 'package:hirfa_frontend/Clients/Models/product.dart';
import 'package:hirfa_frontend/Clients/ServicesClients/crud_shopping.dart';
import 'package:hirfa_frontend/Clients/ServicesClients/product_service.dart';
import 'package:hirfa_frontend/Clients/view_cooperative_profile.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;
  List<Product> _relatedProducts = [];
  List<Product> _cooperativeProducts = [];
  bool _isLoadingRelated = true;

  @override
  void initState() {
    super.initState();
    _loadRelatedProducts();
    _loadCooperativeProducts();
  }

  Future<void> _loadRelatedProducts() async {
    try {
      final products = await ProductService.getProducts(
        category: widget.product.categorie,
      );
      setState(() {
        _relatedProducts =
            products
                .where((p) => p.productId != widget.product.productId)
                .take(4)
                .toList();
        _isLoadingRelated = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingRelated = false;
      });
    }
  }

  Future<void> _loadCooperativeProducts() async {
    try {
      final products = await ProductService.getProducts();
      setState(() {
        _cooperativeProducts =
            products
                .where(
                  (p) =>
                      p.cooperativeId == widget.product.cooperativeId &&
                      p.productId != widget.product.productId,
                )
                .take(3)
                .toList();
      });
    } catch (e) {
      // Handle error
    }
  }

  void _navigateToCooperativeProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ViewCooperativeProfile(
              cooperativeId: int.tryParse(widget.product.cooperativeId) ?? 1,
            ),
      ),
    );
  }

  void _navigateToProductDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }

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

  Widget _buildImageGallery() {
    return Container(
      height: 380,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A1A1A).withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Image PageView with infinite scroll
          PageView.builder(
            controller: _pageController,
            itemCount: widget.product.imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return ClipRRect(
                child: Image.network(
                  widget.product.imageUrls[index],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: const Color(0xFFfdfbf7),
                      child: Center(
                        child: CircularProgressIndicator(
                          value:
                              loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                          color: const Color(0xFF2d6723),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFfdfbf7),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported,
                              size: 60,
                              color: const Color(0xFFd5b694),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Image not available',
                              style: TextStyle(
                                color: const Color(0xFF863a3a),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),

          // Image Indicator Dots
          if (widget.product.imageUrls.length > 1)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 3,
                children: List.generate(
                  widget.product.imageUrls.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _currentImageIndex == index ? 20 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(
                        _currentImageIndex == index
                            ? 4
                            : 100, // 100 makes it look like a circle
                      ),
                      color:
                          _currentImageIndex == index
                              ? const Color(0xFF2d6723)
                              : Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
            ),

          // Image Counter
          if (widget.product.imageUrls.length > 1)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A).withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_currentImageIndex + 1}/${widget.product.imageUrls.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductInfoCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A1A1A).withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Name
          Text(
            widget.product.nomProduit,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),

          const SizedBox(height: 8),

          // Price
          Text(
            '${widget.product.prix} DH',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2d6723),
            ),
          ),

          const SizedBox(height: 16),

          // Stock Status
          Row(
            children: [
              Icon(
                Icons.inventory_2,
                size: 18,
                color:
                    widget.product.quantiteStock > 0
                        ? const Color(0xFF2d6723)
                        : const Color(0xFF863a3a),
              ),
              const SizedBox(width: 8),
              Text(
                widget.product.quantiteStock > 0
                    ? 'In stock (${widget.product.quantiteStock} available)'
                    : 'Out of stock',
                style: TextStyle(
                  fontSize: 14,
                  color:
                      widget.product.quantiteStock > 0
                          ? const Color(0xFF2d6723)
                          : const Color(0xFF863a3a),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Product Details Grid
          _buildDetailGrid(),

          const SizedBox(height: 20),

          // Description
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.product.description,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Color(0xFF555555),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailGrid() {
    return Column(
      children: [
        // Full width Catégorie
        _buildDetailItem('Category', widget.product.categorie, Icons.category),

        const SizedBox(height: 12),

        // Row with Poids + Dimensions
        Row(
          children: [
            Expanded(
              child: _buildDetailItem(
                'Weight',
                '${widget.product.poids ?? 'N/A'} kg',
                Icons.scale,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDetailItem(
                'Dimensions',
                widget.product.dimensions ?? 'N/A',
                Icons.aspect_ratio,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailItem(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFfdfbf7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFd5b694).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 4),
          Icon(icon, size: 16, color: const Color(0xFF2d6723)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666666),
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1A1A1A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCooperativeSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A1A1A).withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Vendu par',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              TextButton.icon(
                onPressed: _navigateToCooperativeProfile,
                icon: const Icon(
                  Icons.storefront_rounded,
                  color: Color(0xFF2d6723),
                  size: 16,
                ),
                label: const Text(
                  'Voir le profil',
                  style: TextStyle(
                    color: Color(0xFF2d6723),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Cooperative ${widget.product.cooperativeId}',
            style: const TextStyle(fontSize: 16, color: Color(0xFF555555)),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsSection(
    String title,
    List<Product> products,
    bool isLoading,
  ) {
    if (isLoading) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1A1A1A).withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Color(0xFF2d6723)),
        ),
      );
    }

    if (products.isEmpty) {
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A1A1A).withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: products.map((p) => _buildProductCard(p)).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFfdfbf7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFd5b694).withOpacity(0.3)),
      ),
      child: InkWell(
        onTap: () => _navigateToProductDetail(product),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
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

            // Product Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.nomProduit,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1A1A1A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${product.prix} DH',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2d6723),
                    ),
                  ),
                  const SizedBox(height: 4),
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
                        '${product.quantiteStock}',
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Product added to cart'),
        backgroundColor: const Color(0xFF2d6723),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfdfbf7),
      appBar: AppBar(
        title: Text(
          widget.product.nomProduit,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFF1A1A1A),
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildImageGallery(),
            const SizedBox(height: 16),
            _buildProductInfoCard(),
            const SizedBox(height: 16),
            _buildCooperativeSection(),
            const SizedBox(height: 16),
            _buildProductsSection(
              'Products of the same cooperative',
              _cooperativeProducts,
              false,
            ),
            const SizedBox(height: 16),
            _buildProductsSection(
              'Related products',
              _relatedProducts,
              _isLoadingRelated,
            ),
            const SizedBox(height: 20),

            // Add to Cart Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      widget.product.quantiteStock > 0
                          ? () {
                            _showAddToCartDialog(widget.product);
                          }
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        widget.product.quantiteStock > 0
                            ? const Color(0xFF2d6723)
                            : const Color(0xFFCCCCCC),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    widget.product.quantiteStock > 0
                        ? 'Add to cart - ${widget.product.prix} DH'
                        : 'Out of stock',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
