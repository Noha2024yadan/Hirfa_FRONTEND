import 'package:flutter/material.dart';
import 'package:hirfa_frontend/Cooperative/design_detail_screen.dart';
import 'package:hirfa_frontend/Designers/ServicesDesigners/crud_design.dart';

class ViewDesignerProfile extends StatefulWidget {
  final String designerId;

  const ViewDesignerProfile({super.key, required this.designerId});

  @override
  State<ViewDesignerProfile> createState() => _ViewDesignerProfileState();
}

class _ViewDesignerProfileState extends State<ViewDesignerProfile> {
  Map<String, dynamic>? _designerInfo;
  List<Map<String, dynamic>> _designs = [];
  bool _isLoading = true;
  bool _isError = false;
  final TextEditingController _messageController = TextEditingController();
  bool _isContacting = false;

  @override
  void initState() {
    super.initState();
    _loadDesignerData();
  }

  Future<void> _loadDesignerData() async {
    try {
      setState(() {
        _isLoading = true;
        _isError = false;
      });

      final designerInfo = await CrudDesign.getDesignerProfile(
        widget.designerId,
      );
      final designs = await CrudDesign.getAllDesigns();

      setState(() {
        _designerInfo = designerInfo;
        _designs =
            designs
                .where((design) => design['designer_id'] == widget.designerId)
                .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isError = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _contactDesigner() async {
    if (_messageController.text.isEmpty) return;

    setState(() {
      _isContacting = true;
    });

    final result = await CrudDesign.contactDesigner(
      designerId: widget.designerId,
      message: _messageController.text,
    );

    setState(() {
      _isContacting = false;
    });

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Message sent successfully!'),
          backgroundColor: Color(0xFF2D6723),
        ),
      );
      _messageController.clear();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send message: $result'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showContactDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Contact Designer',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
                fontFamily: 'Poppins',
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Send a message to ${_designerInfo?['username'] ?? 'the designer'}',
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _messageController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Type your message here...',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Color(0xFF666666)),
                ),
              ),
              ElevatedButton(
                onPressed: _isContacting ? null : _contactDesigner,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2D6723),
                  foregroundColor: Colors.white,
                ),
                child:
                    _isContacting
                        ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : Text('Send Message'),
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
            'Loading designer profile...',
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
            'Failed to load profile',
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
            onPressed: _loadDesignerData,
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

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
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
          CircleAvatar(
            radius: 50,
            backgroundColor: Color(0xFFD5B694),
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          SizedBox(height: 16),
          Text(
            '${_designerInfo?['prenom'] ?? ''} ${_designerInfo?['nom'] ?? ''}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 4),
          Text(
            '@${_designerInfo?['username'] ?? ''}',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF666666),
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // _buildStatItem(
              //   '${_designerInfo?['projects_completed'] ?? 0}',
              //   'Projects',
              // ),
              // SizedBox(width: 20),
              // _buildStatItem('${_designerInfo?['rating'] ?? '0.0'}', 'Rating'),
              // SizedBox(width: 20),
              _buildStatItem(
                '${_designerInfo?['tarifs']?.toStringAsFixed(0) ?? '0'} DH',
                'Hourly Rate',
              ),
            ],
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
          _buildContactItem(Icons.email, _designerInfo?['email'] ?? 'N/A'),
          SizedBox(height: 12),
          _buildContactItem(Icons.phone, _designerInfo?['telephone'] ?? 'N/A'),
          SizedBox(height: 12),
          _buildContactItem(
            Icons.language,
            _designerInfo?['portfolio'] ?? 'N/A',
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _showContactDialog,
            icon: Icon(Icons.message),
            label: Text('Send Message'),
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

  Widget _buildSpecialties() {
    final raw = _designerInfo?['specialites'];
    List<String> specialties;

    if (raw == null) {
      specialties = [];
    } else if (raw is String) {
      specialties =
          raw
              .split(',')
              .map((s) => s.trim())
              .where((s) => s.isNotEmpty)
              .toList();
    } else if (raw is List) {
      specialties =
          raw
              .map((e) => e?.toString() ?? '')
              .map((s) => s.trim())
              .where((s) => s.isNotEmpty)
              .toList();
    } else {
      specialties = [];
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
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
            'Specialties',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    specialties
                        .map<Widget>(
                          (specialty) => Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Chip(
                              label: Text(
                                specialty,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              backgroundColor: Color(0xFF2D6723),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesignsSection() {
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
            'Design Portfolio',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 12),
          Text(
            '${_designs.length} designs available',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 16),
          _designs.isEmpty
              ? Container(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    Icon(
                      Icons.design_services,
                      size: 60,
                      color: Color(0xFFD5B694),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'No designs available',
                      style: TextStyle(color: Color(0xFF666666), fontSize: 16),
                    ),
                  ],
                ),
              )
              : GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                itemCount: _designs.length,
                itemBuilder: (context, index) {
                  final design = _designs[index];
                  return InkWell(
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => DesignDetailScreen(design: design),
                          ),
                        ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image:
                            design['images'] != null &&
                                    design['images'].isNotEmpty
                                ? DecorationImage(
                                  image: NetworkImage(design['images'][0]),
                                  fit: BoxFit.cover,
                                )
                                : null,
                        color: Color(0xFFF5F5F5),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        padding: EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              design['nom_design'],
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${design['prix']} DH',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
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
          'Designer Profile',
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
      body:
          _isLoading
              ? _buildLoadingState()
              : _isError
              ? _buildErrorState()
              : SingleChildScrollView(
                child: Column(
                  children: [
                    _buildProfileHeader(),
                    SizedBox(height: 20),
                    _buildContactInfo(),
                    SizedBox(height: 16),
                    _buildSpecialties(),
                    SizedBox(height: 16),
                    _buildDesignsSection(),
                    SizedBox(height: 20),
                  ],
                ),
              ),
    );
  }
}
