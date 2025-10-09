import '../Models/order.dart';

class OrderService {
  static final List<Order> _mockOrders = [
    Order(
      orderId: '1',
      cooperativeId: 'coop1',
      cooperativeName: 'Eco Crafts Collective',
      clientId: 'client1',
      clientName: 'John Doe',
      totalAmount: 150.0,
      orderDate: DateTime.now().subtract(Duration(days: 2)),
      status: 'approved',
      deliveryAddress: '123 Main St, Casablanca',
      clientNotes: 'Please deliver before 5 PM',
      items: [
        OrderItem(
          productId: '1',
          productName: 'Organic Argan Oil',
          unitPrice: 75.0,
          quantity: 2,
          imageUrl: 'https://picsum.photos/id/33/300/700',
        ),
      ],
    ),
    Order(
      orderId: '2',
      cooperativeId: 'coop1',
      cooperativeName: 'Eco Crafts Collective',
      clientId: 'client1',
      clientName: 'John Doe',
      totalAmount: 85.0,
      orderDate: DateTime.now().subtract(Duration(days: 1)),
      status: 'preparing',
      deliveryAddress: '123 Main St, Casablanca',
      items: [
        OrderItem(
          productId: '2',
          productName: 'Natural Black Soap',
          unitPrice: 35.0,
          quantity: 2,
          imageUrl: 'https://picsum.photos/id/34/300/700',
        ),
        OrderItem(
          productId: '3',
          productName: 'Rose Water',
          unitPrice: 15.0,
          quantity: 1,
          imageUrl: 'https://picsum.photos/id/35/300/700',
        ),
      ],
    ),
    Order(
      orderId: '3',
      cooperativeId: 'coop2',
      cooperativeName: 'Atlas Artisans',
      clientId: 'client1',
      clientName: 'John Doe',
      totalAmount: 200.0,
      orderDate: DateTime.now().subtract(Duration(days: 5)),
      deliveryDate: DateTime.now().subtract(Duration(days: 1)),
      status: 'delivered',
      deliveryAddress: '123 Main St, Casablanca',
      items: [
        OrderItem(
          productId: '4',
          productName: 'Handwoven Rug',
          unitPrice: 200.0,
          quantity: 1,
          imageUrl: 'https://picsum.photos/id/36/300/700',
        ),
      ],
    ),
    Order(
      orderId: '4',
      cooperativeId: 'coop1',
      cooperativeName: 'Eco Crafts Collective',
      clientId: 'client2',
      clientName: 'Sarah Smith',
      totalAmount: 120.0,
      orderDate: DateTime.now().subtract(Duration(hours: 12)),
      status: 'pending',
      deliveryAddress: '456 Oak Ave, Rabat',
      items: [
        OrderItem(
          productId: '5',
          productName: 'Olive Oil Soap',
          unitPrice: 25.0,
          quantity: 4,
          imageUrl: 'https://picsum.photos/id/37/300/700',
        ),
        OrderItem(
          productId: '6',
          productName: 'Dried Figs',
          unitPrice: 20.0,
          quantity: 1,
          imageUrl: 'https://picsum.photos/id/38/300/700',
        ),
      ],
    ),
  ];

  // Get orders for a specific client
  static Future<List<Order>> getClientOrders(String clientId) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate API delay
    return _mockOrders.where((order) => order.clientId == clientId).toList();
  }

  // Get orders for a specific cooperative
  static Future<List<Order>> getCooperativeOrders(String cooperativeId) async {
    await Future.delayed(Duration(seconds: 1));
    return _mockOrders
        .where((order) => order.cooperativeId == cooperativeId)
        .toList();
  }

  // Update order status
  static Future<bool> updateOrderStatus(
    String orderId,
    String newStatus,
  ) async {
    await Future.delayed(Duration(seconds: 1));
    final order = _mockOrders.firstWhere((order) => order.orderId == orderId);
    final index = _mockOrders.indexOf(order);

    _mockOrders[index] = Order(
      orderId: order.orderId,
      cooperativeId: order.cooperativeId,
      cooperativeName: order.cooperativeName,
      clientId: order.clientId,
      clientName: order.clientName,
      totalAmount: order.totalAmount,
      orderDate: order.orderDate,
      deliveryDate:
          newStatus == 'delivered' ? DateTime.now() : order.deliveryDate,
      status: newStatus,
      deliveryAddress: order.deliveryAddress,
      clientNotes: order.clientNotes,
      items: order.items,
    );

    return true;
  }

  // Get order by ID
  static Future<Order?> getOrderById(String orderId) async {
    await Future.delayed(Duration(milliseconds: 500));
    try {
      return _mockOrders.firstWhere((order) => order.orderId == orderId);
    } catch (e) {
      return null;
    }
  }
}
