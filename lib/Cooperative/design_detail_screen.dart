import 'package:flutter/material.dart';
import 'package:hirfa_frontend/Cooperative/view_designer_profile.dart';

class DesignDetailScreen extends StatefulWidget {
  final Map<String, dynamic> design;

  const DesignDetailScreen({super.key, required this.design});

  @override
  State<DesignDetailScreen> createState() => _DesignDetailScreenState();
}

class _DesignDetailScreenState extends State<DesignDetailScreen> {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  void _navigateToDesignerProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                ViewDesignerProfile(designerId: widget.design['designer_id']),
      ),
    );
  }

  Widget _buildImageGallery() {
    final images = widget.design['images'] ?? [];

    return Container(
      height: 380,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0xFF1A1A1A).withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return ClipRRect(
                child: Image.network(
                  images[index],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Color(0xFFFDFBF7),
                      child: Center(
                        child: CircularProgressIndicator(
                          value:
                              loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                          color: Color(0xFF2D6723),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Color(0xFFFDFBF7),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported,
                              size: 60,
                              color: Color(0xFFD5B694),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Image not available',
                              style: TextStyle(
                                color: Color(0xFF863A3A),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),

          if (images.length > 1) ...[
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 3,
                children: List.generate(
                  images.length,
                  (index) => AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: _currentImageIndex == index ? 20 : 8,
                    height: 8,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(
                        _currentImageIndex == index ? 4 : 100,
                      ),
                      color:
                          _currentImageIndex == index
                              ? Color(0xFF2D6723)
                              : Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF1A1A1A).withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_currentImageIndex + 1}/${images.length}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDesignInfoCard() {
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
            widget.design['nom_design'],
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
              fontFamily: 'Poppins',
            ),
          ),

          SizedBox(height: 8),

          Text(
            '${widget.design['prix']?.toStringAsFixed(2) ?? '0.00'} DH',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D6723),
              fontFamily: 'Poppins',
            ),
          ),

          SizedBox(height: 16),

          Row(
            children: [
              Icon(
                Icons.check_circle,
                size: 18,
                color:
                    widget.design['statut'] == true
                        ? Color(0xFF2D6723)
                        : Color(0xFF863A3A),
              ),
              SizedBox(width: 8),
              Text(
                widget.design['statut'] == true ? "Available" : "Unavailable",
                style: TextStyle(
                  fontSize: 14,
                  color:
                      widget.design['statut'] == true
                          ? Color(0xFF2D6723)
                          : Color(0xFF863A3A),
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          _buildDetailGrid(),

          SizedBox(height: 20),

          Text(
            'Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 8),
          Text(
            widget.design['description'],
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Color(0xFF555555),
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailGrid() {
    return Column(
      children: [
        _buildDetailItem(
          'Designer',
          widget.design['designer_name'] ?? 'Unknown',
          Icons.person,
        ),
        SizedBox(height: 12),
        _buildDetailItem(
          'Created',
          widget.design['created_date'] ?? 'N/A',
          Icons.calendar_today,
        ),
      ],
    );
  }

  Widget _buildDetailItem(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFFDFBF7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFD5B694).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          SizedBox(width: 4),
          Icon(icon, size: 16, color: Color(0xFF2D6723)),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666666),
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1A1A1A),
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesignerSection() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Designed by',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                  fontFamily: 'Poppins',
                ),
              ),
              TextButton.icon(
                onPressed: _navigateToDesignerProfile,
                icon: Icon(
                  Icons.person_rounded,
                  color: Color(0xFF2D6723),
                  size: 16,
                ),
                label: Text(
                  'View Profile',
                  style: TextStyle(
                    color: Color(0xFF2D6723),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            widget.design['designer_name'] ?? 'Unknown Designer',
            style: TextStyle(fontSize: 16, color: Color(0xFF555555)),
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
          widget.design['nom_design'],
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
            _buildImageGallery(),
            SizedBox(height: 16),
            _buildDesignInfoCard(),
            SizedBox(height: 16),
            _buildDesignerSection(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
