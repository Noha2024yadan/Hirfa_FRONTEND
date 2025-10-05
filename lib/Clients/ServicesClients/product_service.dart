import 'dart:convert';
import 'package:hirfa_frontend/Clients/Models/product.dart';
import 'package:http/http.dart' as http;

class ProductService {
  static const String baseUrl = 'http://ton-backend.com/api';

  // Get all products (no authentication required)
  static Future<List<Product>> getProducts({
    String? category,
    String? searchQuery,
    double? minPrice,
    double? maxPrice,
    double? minWeight,
    double? maxWeight,
    String? dimensions,
  }) async {
    try {
      final Map<String, String> queryParams = {};

      if (category != null && category != 'All') {
        queryParams['categorie'] = category;
      }
      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParams['search'] = searchQuery;
      }
      if (minPrice != null) {
        queryParams['min_price'] = minPrice.toString();
      }
      if (maxPrice != null) {
        queryParams['max_price'] = maxPrice.toString();
      }
      if (minWeight != null) {
        queryParams['min_weight'] = minWeight.toString();
      }
      if (maxWeight != null) {
        queryParams['max_weight'] = maxWeight.toString();
      }
      if (dimensions != null && dimensions.isNotEmpty) {
        queryParams['dimensions'] = dimensions;
      }

      final url = Uri.parse(
        '$baseUrl/products',
      ).replace(queryParameters: queryParams);

      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      // Return filtered mock data for development
      return _getFilteredMockProducts(
        category: category,
        searchQuery: searchQuery,
        minPrice: minPrice,
        maxPrice: maxPrice,
        minWeight: minWeight,
        maxWeight: maxWeight,
        dimensions: dimensions,
      );
    }
  }

  // Get product details
  static Future<Product> getProductDetails(String productId) async {
    try {
      final url = Uri.parse('$baseUrl/products/$productId');
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Product.fromJson(data);
      } else {
        throw Exception('Failed to load product details');
      }
    } catch (e) {
      // Return mock product for development
      return _getMockProducts().firstWhere(
        (product) => product.productId == productId,
      );
    }
  }

  // Get recommended products (requires authentication)
  static Future<List<Product>> getRecommendedProducts(String token) async {
    try {
      final url = Uri.parse('$baseUrl/products/recommended');
      final response = await http
          .get(url, headers: {'Authorization': 'Bearer $token'})
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // Filter mock data based on parameters
  static List<Product> _getFilteredMockProducts({
    String? category,
    String? searchQuery,
    double? minPrice,
    double? maxPrice,
    double? minWeight,
    double? maxWeight,
    String? dimensions,
  }) {
    List<Product> products = _getMockProducts();

    // Apply category filter
    if (category != null && category != 'All') {
      products =
          products.where((product) => product.categorie == category).toList();
    }

    // Apply search filter
    if (searchQuery != null && searchQuery.isNotEmpty) {
      products =
          products
              .where(
                (product) =>
                    product.nomProduit.toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    ) ||
                    product.description.toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    ),
              )
              .toList();
    }

    // Apply price filter
    if (minPrice != null) {
      products = products.where((product) => product.prix >= minPrice).toList();
    }
    if (maxPrice != null) {
      products = products.where((product) => product.prix <= maxPrice).toList();
    }

    // Apply weight filter
    if (minWeight != null) {
      products =
          products
              .where((product) => (product.poids ?? 0) >= minWeight)
              .toList();
    }
    if (maxWeight != null) {
      products =
          products
              .where(
                (product) => (product.poids ?? double.infinity) <= maxWeight,
              )
              .toList();
    }

    // Apply dimensions filter
    if (dimensions != null && dimensions.isNotEmpty) {
      products =
          products
              .where(
                (product) =>
                    product.dimensions?.toLowerCase().contains(
                      dimensions.toLowerCase(),
                    ) ??
                    false,
              )
              .toList();
    }

    return products;
  }

  // Mock data for development
  static List<Product> _getMockProducts() {
    return [
      Product(
        productId: 1,
        nomProduit: 'Savon Artisanal à l\'Argan',
        description: 'Savon bio naturel à base d\'huile d\'argan marocaine',
        prix: 29.99,
        quantiteStock: 10,
        categorie: 'Cosmetics',
        poids: 0.2,
        dimensions: '5x5x2 cm',
        imageUrls: [
          'https://picsum.photos/id/33/300/700',
          'https://picsum.photos/id/33/300/700',
          'https://picsum.photos/id/33/300/700',
        ],
        dateCreation: DateTime.now(),
        statut: true,
        signalements: 0,
        cooperativeId: 'coop1',
      ),
      Product(
        productId: 2,
        nomProduit: 'Huile d\'Olive Vierge',
        description: 'Huile d\'olive pressée à froid de qualité supérieure',
        prix: 89.50,
        quantiteStock: 5,
        categorie: 'Food',
        poids: 1.0,
        dimensions: '10x10x30 cm',
        imageUrls: ['https://picsum.photos/id/123/600/1000'],
        dateCreation: DateTime.now(),
        statut: true,
        signalements: 0,
        cooperativeId: 'coop2',
      ),
      Product(
        productId: 3,
        nomProduit: 'Tapis Berbère Traditionnel',
        description:
            'Tapis artisanal tissé à la main avec des motifs traditionnels',
        prix: 450.00,
        quantiteStock: 3,
        categorie: 'Textiles',
        poids: 3.5,
        dimensions: '200x150 cm',
        imageUrls: ['https://picsum.photos/id/22/400/800'],
        dateCreation: DateTime.now(),
        statut: true,
        signalements: 0,
        cooperativeId: 'coop3',
      ),
      Product(
        productId: 4,
        nomProduit: 'Poterie Marocaine',
        description: 'Pot décoratif en céramique peinte à la main',
        prix: 75.00,
        quantiteStock: 8,
        categorie: 'Decoration',
        poids: 1.2,
        dimensions: '15x15x20 cm',
        imageUrls: ['https://picsum.photos/id/964/500/900'],
        dateCreation: DateTime.now(),
        statut: true,
        signalements: 0,
        cooperativeId: 'coop2',
      ),
      Product(
        productId: 5,
        nomProduit: 'Couscous Artisanal',
        description: 'Couscous de blé dur de qualité premium',
        prix: 35.00,
        quantiteStock: 15,
        categorie: 'Food',
        poids: 2.0,
        dimensions: '25x15x8 cm',
        imageUrls: ['https://picsum.photos/id/357/500/700'],
        dateCreation: DateTime.now(),
        statut: true,
        signalements: 0,
        cooperativeId: 'coop1',
      ),
      Product(
        productId: 6,
        nomProduit: 'Broderie Traditionnelle',
        description: 'Tableau brodé main avec des motifs marocains',
        prix: 120.00,
        quantiteStock: 6,
        categorie: 'Crafts',
        poids: 0.8,
        dimensions: '30x40 cm',
        imageUrls: ['https://picsum.photos/id/259/300/700'],
        dateCreation: DateTime.now(),
        statut: true,
        signalements: 0,
        cooperativeId: 'coop2',
      ),
    ];
  }

  //Report a product
  static Future<bool> reportProduct({
    required int productId,
    required String reason,
  }) async {
    final url = Uri.parse('$baseUrl/produit/report');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'productId': productId, 'reason': reason}),
    );

    if (response.statusCode == 200) {
      // Tu peux aussi vérifier le contenu de la réponse ici
      return true;
    } else {
      print('Erreur lors du signalement: ${response.body}');
      return false;
    }
  }
}
