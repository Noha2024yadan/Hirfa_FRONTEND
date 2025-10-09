import 'package:flutter/material.dart';
import 'package:hirfa_frontend/Clients/Models/order.dart';
import 'package:hirfa_frontend/Clients/ServicesClients/order_service.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  List<Order> _orders = [];
  bool _isLoading = true;
  final String _currentClientId = 'client1'; // Mock client ID

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final orders = await OrderService.getClientOrders(_currentClientId);
      setState(() {
        _orders = orders.cast<Order>();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Color(0xFFD5B694);
      case 'approved':
        return Color(0xFF2D6723);
      case 'preparing':
        return Color(0xFF1A1A1A);
      case 'shipped':
        return Color(0xFF2D6723);
      case 'delivered':
        return Color(0xFF2D6723);
      case 'cancelled':
        return Color(0xFF863A3A);
      default:
        return Color(0xFF555555);
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.pending_actions;
      case 'approved':
        return Icons.thumb_up;
      case 'preparing':
        return Icons.build;
      case 'shipped':
        return Icons.local_shipping;
      case 'delivered':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  Widget _buildOrderCard(Order order) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with order info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${order.orderId}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      order.cooperativeName,
                      style: TextStyle(color: Color(0xFF555555), fontSize: 14),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _getStatusColor(order.status)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getStatusIcon(order.status),
                        size: 14,
                        color: _getStatusColor(order.status),
                      ),
                      SizedBox(width: 4),
                      Text(
                        order.status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(order.status),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),

            // Order items preview
            Column(
              children:
                  order.items
                      .take(2)
                      .map(
                        (item) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Color(0xFFF5F5F5),
                                  image:
                                      item.imageUrl != null
                                          ? DecorationImage(
                                            image: NetworkImage(item.imageUrl!),
                                            fit: BoxFit.cover,
                                          )
                                          : null,
                                ),
                                child:
                                    item.imageUrl == null
                                        ? Icon(
                                          Icons.shopping_bag,
                                          color: Color(0xFFD5B694),
                                        )
                                        : null,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.productName,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF1A1A1A),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '${item.quantity} x ${item.unitPrice} DH',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF555555),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
            ),

            if (order.items.length > 2) ...[
              SizedBox(height: 8),
              Text(
                '+ ${order.items.length - 2} more items',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF777777),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],

            SizedBox(height: 12),
            Divider(color: Color(0xFFD5B694).withOpacity(0.3)),
            SizedBox(height: 8),

            // Footer with total and date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: ${order.totalAmount} DH',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D6723),
                  ),
                ),
                Text(
                  _formatDate(order.orderDate),
                  style: TextStyle(fontSize: 12, color: Color(0xFF777777)),
                ),
              ],
            ),

            if (order.deliveryDate != null) ...[
              SizedBox(height: 8),
              Text(
                'Delivered on ${_formatDate(order.deliveryDate!)}',
                style: TextStyle(fontSize: 12, color: Color(0xFF2D6723)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFF2D6723)),
          SizedBox(height: 16),
          Text(
            'Loading your orders...',
            style: TextStyle(color: Color(0xFF555555), fontSize: 16),
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
          Icon(Icons.shopping_bag_outlined, size: 80, color: Color(0xFFD5B694)),
          SizedBox(height: 16),
          Text(
            'No orders yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Your orders will appear here',
            style: TextStyle(color: Color(0xFF777777)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDFBF7),
      appBar: AppBar(
        title: Text(
          'My Orders',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Color(0xFF1A1A1A),
      ),
      body:
          _isLoading
              ? _buildLoadingState()
              : _orders.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                onRefresh: _loadOrders,
                color: Color(0xFF2D6723),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  itemCount: _orders.length,
                  itemBuilder: (context, index) {
                    return _buildOrderCard(_orders[index]);
                  },
                ),
              ),
    );
  }
}
