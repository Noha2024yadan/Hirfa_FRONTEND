import 'package:flutter/material.dart';

class ViewCooperativeProfileDesigner extends StatefulWidget {
  final Map<String, dynamic> cooperative;

  const ViewCooperativeProfileDesigner({super.key, required this.cooperative});

  @override
  State<ViewCooperativeProfileDesigner> createState() =>
      _ViewCooperativeProfileDesignerState();
}

class _ViewCooperativeProfileDesignerState
    extends State<ViewCooperativeProfileDesigner> {
  Widget _buildProfileHeader() {
    final DateTime dateTime = DateTime.parse(
      widget.cooperative['date_creation'].toString(),
    );
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF1A1A1A).withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Cooperative Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2D6723), Color(0xFF3A7E2D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF2D6723).withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              Icons.storefront_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
          SizedBox(height: 20),

          // Cooperative Name
          Text(
            widget.cooperative['brand'] ?? 'Cooperative',
            style: TextStyle(
              color: Color(0xFF1A1A1A),
              fontSize: 24,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),

          // date_creation
          Text(
            'Since ${dateTime.day}/${dateTime.month}/${dateTime.year}',
            style: TextStyle(
              color: Color(0xFF666666),
              fontSize: 14,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 12),

          // Description
          Text(
            widget.cooperative['description'] ?? 'No description available',
            style: TextStyle(
              color: Color(0xFF666666),
              fontSize: 15,
              height: 1.4,
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),

          // Stats
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  '${widget.cooperative['products_count'] ?? 0}',
                  'Products',
                ),
                _buildStatItem(
                  '⭐ ${widget.cooperative['licence'] ?? 'Not provided'}',
                  'Licence',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D6723),
            fontFamily: 'Poppins',
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF666666),
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfo() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF1A1A1A).withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 16),
          _buildContactItem(Icons.email, widget.cooperative['email'] ?? 'N/A'),
          SizedBox(height: 12),
          _buildContactItem(
            Icons.phone,
            widget.cooperative['telephone'] ?? 'N/A',
          ),
          SizedBox(height: 12),
          _buildContactItem(
            Icons.location_on,
            widget.cooperative['adresse'] ?? 'N/A',
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.message),
            label: Text('Send Message to Cooperative'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2D6723),
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Color(0xFF2D6723)),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF555555),
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDFBF7),
      appBar: AppBar(
        title: Text(
          'Cooperative Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFF1A1A1A),
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFF1A1A1A),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            SizedBox(height: 20),
            _buildContactInfo(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
