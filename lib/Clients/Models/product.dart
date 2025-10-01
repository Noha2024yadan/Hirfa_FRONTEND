class Product {
  final String productId;
  final String nomProduit;
  final String description;
  final double prix;
  final int quantiteStock;
  final String categorie;
  final double? poids;
  final String? dimensions;
  final DateTime dateCreation;
  final bool statut;
  final int signalements;
  final List<String> imageUrls;
  final String cooperativeId;

  Product({
    required this.productId,
    required this.nomProduit,
    required this.description,
    required this.prix,
    required this.quantiteStock,
    required this.categorie,
    this.poids,
    this.dimensions,
    required this.dateCreation,
    required this.statut,
    required this.signalements,
    required this.imageUrls,
    required this.cooperativeId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['product_id'] ?? '',
      nomProduit: json['nom_produit'] ?? '',
      description: json['description'] ?? '',
      prix: (json['prix'] ?? 0).toDouble(),
      quantiteStock: json['quantite_stock'] ?? 0,
      categorie: json['categorie'] ?? '',
      poids: json['poids']?.toDouble(),
      dimensions: json['dimensions'],
      dateCreation: DateTime.parse(
        json['date_creation'] ?? DateTime.now().toString(),
      ),
      statut: json['statut'] ?? false,
      signalements: json['signalements'] ?? 0,
      imageUrls: List<String>.from(json['image_urls'] ?? []),
      cooperativeId: json['cooperative_id'] ?? '',
    );
  }
}
