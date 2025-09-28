import 'package:flutter/material.dart';
import 'package:hirfa_frontend/Designers/ServicesDesigners/crud_design.dart';
import 'package:hirfa_frontend/Designers/update_design.dart';

class HomeDesigner extends StatefulWidget {
  const HomeDesigner({super.key});

  @override
  State<HomeDesigner> createState() => _HomeDesignerState();
}

class _HomeDesignerState extends State<HomeDesigner> {
  List<Map<String, dynamic>> _designs = [];
  bool _isLoading = true;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _loadDesigns();
  }

  Future<void> _loadDesigns() async {
    try {
      setState(() {
        _isLoading = true;
        _isError = false;
      });

      final designs = await CrudDesign.getDesigns();
      setState(() {
        _designs = designs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isError = true;
      });
    }
  }

  void _deleteDesign(int index) async {
    print("🟢 Delete triggered for index $index");

    final design = _designs[index];
    print("🟢 Design ID: ${design['design_id']}");

    bool? confirm = await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Delete Design',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Are you sure you want to delete "${design['nom_design']}"?',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Color(0xFF555555),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  'Delete',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
    );
    print("🟢 Confirmation result: $confirm");

    if (confirm == true) {
      final result = await CrudDesign.deleteDesign(
        design['design_id'].toString(),
      );
      print("🟢 Delete result: $result");

      if (result == null) {
        setState(() {
          _designs.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("✅ Design deleted successfully."),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("❌ Error: $result"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _editDesign(int index) {
    final design = _designs[index];

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdateDesign(design: design)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _isLoading
              ? _buildLoadingState()
              : _isError
              ? _buildErrorState()
              : _designs.isEmpty
              ? _buildEmptyState()
              : _buildDesignsList(),
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
            'Loading your designs...',
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
            'Failed to load designs',
            style: TextStyle(
              color: Color(0xFF555555),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Please check your connection and try again',
            style: TextStyle(
              color: Color(0xFF777777),
              fontSize: 14,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _loadDesigns,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2D6723),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Retry',
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 80, color: Color(0xFFD5B694)),
          SizedBox(height: 16),
          Text(
            'No designs Yet',
            style: TextStyle(
              color: Color(0xFF555555),
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Start by adding your first design',
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

  Widget _buildDesignsList() {
    return RefreshIndicator(
      onRefresh: _loadDesigns,
      color: Color(0xFF2D6723),
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _designs.length,
        itemBuilder: (context, index) {
          final design = _designs[index];
          return _buildDesignCard(design, index);
        },
      ),
    );
  }

  Widget _buildDesignCard(Map<String, dynamic> design, int index) {
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
          // Design Image and Info
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Design Image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xFFF5F5F5),
                    image:
                        (design['images'] != null &&
                                design['images'].isNotEmpty &&
                                design['images'][0] != null)
                            ? DecorationImage(
                              image:
                                  (design['images'][0].toString().startsWith(
                                        'http',
                                      ))
                                      ? NetworkImage(design['images'][0])
                                      : AssetImage(design['images'][0])
                                          as ImageProvider,
                              fit: BoxFit.cover,
                            )
                            : null,
                  ),
                  child:
                      (design['images'] == null ||
                              design['images'].isEmpty ||
                              design['images'][0] == null)
                          ? Icon(
                            Icons.photo,
                            color: Color(0xFFD5B694),
                            size: 30,
                          )
                          : null,
                ),
                SizedBox(width: 12),

                // Design Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        design['nom_design'] ?? 'No Name',
                        style: TextStyle(
                          color: Color(0xFF1A1A1A),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        design['description'] ?? 'No description',
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
                            '${(design['prix'] is num ? (design['prix'] as num).toStringAsFixed(2) : '0.00')} DH',

                            Icons.attach_money,
                          ),
                          SizedBox(width: 8),
                          _buildInfoChip(
                            design['statut'] == true
                                ? "Available"
                                : "Unavailable",
                            Icons.check_circle,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Action Buttons
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
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _editDesign(index),
                    icon: Icon(Icons.edit, size: 18),
                    label: Text(
                      'Edit',
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
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _deleteDesign(index),
                    icon: Icon(Icons.delete_outline, size: 18),
                    label: Text(
                      'Delete',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Colors.red, // border color
                          width: 1, // border thickness
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
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
}
