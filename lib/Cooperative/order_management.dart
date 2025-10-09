import 'package:flutter/material.dart';
import 'package:hirfa_frontend/Clients/Models/order.dart';
import 'package:hirfa_frontend/Clients/ServicesClients/order_service.dart';

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({super.key});

  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  List<Order> _orders = [];
  bool _isLoading = true;
  String _selectedFilter = 'all';
  final String _currentCooperativeId = 'coop1'; // Mock cooperative ID

  final List<String> _statusFilters = [
    'all',
    'pending',
    'approved',
    'preparing',
    'shipped',
    'delivered',
    'cancelled',
  ];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final orders = await OrderService.getCooperativeOrders(
        _currentCooperativeId,
      );
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

  Future<void> _updateOrderStatus(Order order, String newStatus) async {
    final success = await OrderService.updateOrderStatus(
      order.orderId,
      newStatus,
    );
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order status updated to $newStatus'),
          backgroundColor: Color(0xFF2D6723),
        ),
      );
      _loadOrders();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update order status'),
          backgroundColor: Color(0xFF863A3A),
        ),
      );
    }
  }

  void _showStatusUpdateDialog(Order order) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Update Order Status',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Order #${order.orderId}',
                  style: TextStyle(color: Color(0xFF555555)),
                ),
                SizedBox(height: 20),
                ..._getAvailableStatuses(order.status)
                    .map(
                      (status) => ListTile(
                        leading: Icon(
                          _getStatusIcon(status),
                          color: _getStatusColor(status),
                        ),
                        title: Text(
                          status.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: _getStatusColor(status),
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          _updateOrderStatus(order, status);
                        },
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
    );
  }

  List<String> _getAvailableStatuses(String currentStatus) {
    switch (currentStatus) {
      case 'pending':
        return ['approved', 'cancelled'];
      case 'approved':
        return ['preparing', 'cancelled'];
      case 'preparing':
        return ['shipped'];
      case 'shipped':
        return ['delivered'];
      case 'delivered':
      case 'cancelled':
        return [];
      default:
        return ['approved', 'cancelled'];
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

  List<Order> get _filteredOrders {
    if (_selectedFilter == 'all') return _orders;
    return _orders.where((order) => order.status == _selectedFilter).toList();
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
            // Header
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
                      order.clientName,
                      style: TextStyle(color: Color(0xFF555555), fontSize: 14),
                    ),
                  ],
                ),
                PopupMenuButton<String>(
                  color: Colors.white,
                  onSelected: (value) {
                    if (value == 'update_status') {
                      _showStatusUpdateDialog(order);
                    }
                  },
                  itemBuilder:
                      (context) => [
                        PopupMenuItem(
                          value: 'update_status',
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit,
                                size: 20,
                                color: Color(0xFF2D6723),
                              ),
                              SizedBox(width: 8),
                              Text('Update Status'),
                            ],
                          ),
                        ),
                      ],
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFF2D6723).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.more_vert,
                      size: 18,
                      color: Color(0xFF2D6723),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),

            // Status with progress
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status:',
                  style: TextStyle(fontSize: 12, color: Color(0xFF777777)),
                ),
                SizedBox(height: 8),
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

            // Order items
            ...order.items
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
                        Text(
                          '${item.subtotal} DH',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D6723),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),

            SizedBox(height: 12),
            Divider(color: Color(0xFFD5B694).withOpacity(0.3)),
            SizedBox(height: 8),

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total: ${order.totalAmount} DH',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D6723),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Ordered: ${_formatDate(order.orderDate)}',
                      style: TextStyle(fontSize: 12, color: Color(0xFF777777)),
                    ),
                  ],
                ),
                if (order.deliveryDate != null)
                  Text(
                    'Delivered: ${_formatDate(order.deliveryDate!)}',
                    style: TextStyle(fontSize: 12, color: Color(0xFF2D6723)),
                  ),
              ],
            ),

            if (order.clientNotes != null) ...[
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.note, size: 16, color: Color(0xFFD5B694)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Client note: ${order.clientNotes!}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF555555),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
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

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: _statusFilters.length,
        itemBuilder: (context, index) {
          final filter = _statusFilters[index];
          final isSelected = _selectedFilter == filter;
          return Container(
            margin: EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                filter == 'all' ? 'All' : filter,
                style: TextStyle(
                  color: isSelected ? Colors.white : Color(0xFF1A1A1A),
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              selectedColor: Color(0xFF2D6723),
              checkmarkColor: Colors.white,
              backgroundColor: Color(0xFFF5F5F5),
            ),
          );
        },
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
            'No orders found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 8),
          Text(
            _selectedFilter == 'all'
                ? 'You don\'t have any orders yet'
                : 'No orders with status "$_selectedFilter"',
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
        automaticallyImplyLeading: false,
        title: Text(
          'Order Management',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Color(0xFF1A1A1A),
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          SizedBox(height: 8),
          Expanded(
            child:
                _isLoading
                    ? Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF2D6723),
                      ),
                    )
                    : _filteredOrders.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                      onRefresh: _loadOrders,
                      color: Color(0xFF2D6723),
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        itemCount: _filteredOrders.length,
                        itemBuilder: (context, index) {
                          return _buildOrderCard(_filteredOrders[index]);
                        },
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
