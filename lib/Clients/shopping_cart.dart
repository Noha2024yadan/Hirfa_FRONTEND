import 'package:flutter/material.dart';
import 'package:hirfa_frontend/Clients/ServicesClients/crud_shopping.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  List<Map<String, dynamic>> _cartProducts = [];
  bool _isLoading = true;
  bool _isError = false;
  double _totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCartProducts();
  }

  Future<void> _loadCartProducts() async {
    try {
      setState(() {
        _isLoading = true;
        _isError = false;
      });

      final products = await CrudShopping.getPanierProducts();
      setState(() {
        _cartProducts = products;
        _calculateTotal();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isError = true;
        _isLoading = false;
      });
    }
  }

  void _calculateTotal() {
    double total = 0.0;
    for (var product in _cartProducts) {
      final quantity = product['quantite'] ?? 0;
      final price = product['prix_unitaire'] ?? 0.0;
      total += quantity * price;
    }
    setState(() {
      _totalAmount = total;
    });
  }

  Future<void> _deleteProduct(int itemId) async {
    bool? confirm = await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('Remove Product'),
            content: const Text(
              'Are you sure you want to remove this product from your cart?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[700], // couleur du texte
                ),

                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Remove',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirm == true) {
      bool success = await CrudShopping.deletePanierItem(itemId);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product removed from cart'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _cartProducts.removeWhere((item) => item['panier_item_id'] == itemId);
          _calculateTotal();
        });
      } else {
        print('Failed to delete item');
      }
    }
  }

  void _updateProductQuantity(int itemId, int currentQuantity) {
    TextEditingController quantityController = TextEditingController(
      text: currentQuantity.toString(),
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('Update Quantity'),
            content: TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[700], // couleur du texte
                ),

                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final newQuantity =
                      int.tryParse(quantityController.text.trim()) ?? 0;
                  if (newQuantity <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid quantity'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  bool success = await CrudShopping.updatePanierItemQuantite(
                    panierItemId: itemId,
                    quantite: newQuantity,
                  );
                  if (success) {
                    setState(() {
                      final product = _cartProducts.firstWhere(
                        (p) => p['panier_item_id'] == itemId,
                      );
                      product['quantite'] = newQuantity;
                      _calculateTotal();
                    });

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Quantity updated successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    print('Failed to update item');
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      8,
                    ), // coins arrondis si tu veux
                  ),
                  backgroundColor: Colors.white, // fond du bouton
                ),
                child: const Text('Update'),
              ),
            ],
          ),
    );
  }

  void _validateCart() {
    if (_cartProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Order'),
            content: Text(
              'Total amount: ${_totalAmount.toStringAsFixed(2)} DH\n\nProceed with checkout?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Call your checkout API here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Order placed successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text('Confirm'),
              ),
            ],
          ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFF2D6723)),
          SizedBox(height: 16),
          Text(
            'Loading cart...',
            style: TextStyle(
              color: Color(0xFF555555),
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
          Icon(Icons.error_outline, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text(
            'Failed to load cart',
            style: TextStyle(
              color: Color(0xFF555555),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _loadCartProducts,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2D6723),
              foregroundColor: Colors.white,
            ),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Color(0xFFD5B694),
          ),
          SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: TextStyle(
              color: Color(0xFF555555),
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add some products to get started',
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

  Widget _buildCartItem(Map<String, dynamic> product) {
    final itemId = product['panier_item_id'];
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 60,
              height: 60,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(0xFFF5F5F5),
                image:
                    product['images'] != null && product['images'].isNotEmpty
                        ? DecorationImage(
                          image: NetworkImage(product['images'][0]),
                          fit: BoxFit.cover,
                        )
                        : null,
              ),
              child:
                  product['images'] == null || product['images'].isEmpty
                      ? Icon(
                        Icons.shopping_bag,
                        color: Color.fromARGB(255, 92, 69, 44),
                      )
                      : null,
            ),
            SizedBox(width: 12),

            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['nom_produit'] ?? 'Unknown Product',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF1A1A1A),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${product['prix_unitaire']?.toStringAsFixed(2) ?? '0.00'} DH',
                    style: TextStyle(
                      color: Color(0xFF2D6723),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Quantity: ${product['quantite'] ?? 0}',
                    style: TextStyle(color: Color(0xFF666666), fontSize: 12),
                  ),
                ],
              ),
            ),

            // Action Buttons
            Column(
              children: [
                IconButton(
                  iconSize: 20,
                  onPressed: () => _deleteProduct(itemId),

                  icon: Icon(Icons.delete_outlined, color: Colors.black),
                  tooltip: 'Remove from cart',
                ),
                IconButton(
                  iconSize: 20,
                  onPressed:
                      () => _updateProductQuantity(
                        product['panier_item_id'],
                        product['quantite'] ?? 1,
                      ),
                  icon: Icon(
                    Icons.edit_outlined,
                    color: Colors.black,
                  ), //Color(0xFF2D6723)
                  tooltip: 'Update quantity',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shopping Cart',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body:
          _isLoading
              ? _buildLoadingState()
              : _isError
              ? _buildErrorState()
              : _cartProducts.isEmpty
              ? _buildEmptyState()
              : Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _loadCartProducts,
                      child: ListView.builder(
                        itemCount: _cartProducts.length,
                        itemBuilder: (context, index) {
                          return _buildCartItem(_cartProducts[index]);
                        },
                      ),
                    ),
                  ),

                  // Total and Checkout Button
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              '${_totalAmount.toStringAsFixed(2)} DH',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D6723),
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _validateCart,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2D6723),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Checkout',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}
