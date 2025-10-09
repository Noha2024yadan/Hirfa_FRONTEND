class Order {
  final String orderId;
  final String cooperativeId;
  final String cooperativeName;
  final String clientId;
  final String clientName;
  final double totalAmount;
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final String
  status; // 'pending', 'approved', 'preparing', 'shipped', 'delivered', 'cancelled'
  final String deliveryAddress;
  final String? clientNotes;
  final List<OrderItem> items;

  Order({
    required this.orderId,
    required this.cooperativeId,
    required this.cooperativeName,
    required this.clientId,
    required this.clientName,
    required this.totalAmount,
    required this.orderDate,
    this.deliveryDate,
    required this.status,
    required this.deliveryAddress,
    this.clientNotes,
    required this.items,
  });
}

class OrderItem {
  final String productId;
  final String productName;
  final double unitPrice;
  final int quantity;
  final String? imageUrl;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
    this.imageUrl,
  });

  double get subtotal => unitPrice * quantity;
}
