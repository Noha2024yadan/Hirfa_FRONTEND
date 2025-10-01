import 'package:flutter/material.dart';
import 'package:hirfa_frontend/Designers/ServicesDesigners/crud_cooperative.dart';
import 'package:hirfa_frontend/Designers/view_cooperative_profile_designer.dart';

class DiscoverDesigner extends StatefulWidget {
  const DiscoverDesigner({super.key});

  @override
  State<DiscoverDesigner> createState() => _DiscoverDesignerState();
}

class _DiscoverDesignerState extends State<DiscoverDesigner> {
  List<Map<String, dynamic>> _cooperatives = [];
  bool _isLoading = true;
  bool _isError = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCooperatives();
  }

  Future<void> _loadCooperatives() async {
    try {
      setState(() {
        _isLoading = true;
        _isError = false;
      });

      final cooperatives = await CrudCooperative.getAllCooperatives();
      setState(() {
        _cooperatives = cooperatives;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isError = true;
      });
    }
  }

  void _navigateToCooperativeProfile(Map<String, dynamic> cooperative) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                ViewCooperativeProfileDesigner(cooperative: cooperative),
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredCooperatives {
    var filtered = _cooperatives;

    // Filter by search
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered =
          filtered
              .where(
                (coop) =>
                    coop['brand'].toLowerCase().contains(query) ||
                    coop['description'].toLowerCase().contains(query),
              )
              .toList();
    }

    return filtered;
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFF2D6723)),
          SizedBox(height: 16),
          Text(
            'Loading cooperatives...',
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
            'Failed to load cooperatives',
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
            onPressed: _loadCooperatives,
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
          Icon(Icons.storefront_outlined, size: 80, color: Color(0xFFD5B694)),
          SizedBox(height: 16),
          Text(
            'No Cooperatives Found',
            style: TextStyle(
              color: Color(0xFF555555),
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
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

  Widget _buildCooperativeGrid() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _filteredCooperatives.length,
      itemBuilder: (context, index) {
        final cooperative = _filteredCooperatives[index];
        return _buildCooperativeCard(cooperative);
      },
    );
  }

  Widget _buildCooperativeCard(Map<String, dynamic> cooperative) {
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
          // Cooperative Image and Info
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cooperative Image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xFFF5F5F5),
                    image:
                        cooperative['images'] != null &&
                                cooperative['images'].isNotEmpty
                            ? DecorationImage(
                              image: NetworkImage(cooperative['images'][0]),
                              fit: BoxFit.cover,
                            )
                            : null,
                  ),
                  child:
                      cooperative['images'] == null ||
                              cooperative['images'].isEmpty
                          ? Icon(
                            Icons.storefront_rounded,
                            color: Color(0xFFD5B694),
                            size: 30,
                          )
                          : null,
                ),
                SizedBox(width: 12),

                // Cooperative Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cooperative['brand'] ?? 'Cooperative',
                        style: TextStyle(
                          color: Color(0xFF1A1A1A),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        cooperative['description'] ??
                            'No description available',
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 10),

                      // Stats and Location
                      Row(
                        children: [
                          _buildInfoChip(
                            '${cooperative['products_count'] ?? 0} products',
                            Icons.inventory_2,
                          ),
                          SizedBox(width: 8),
                          _buildInfoChip(
                            '⭐ ${cooperative['licence'] ?? 'Not provided'}',
                            Icons.star,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),

                      // Location
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 12,
                            color: Color(0xFF666666),
                          ),
                          SizedBox(width: 4),
                          Text(
                            cooperative['adresse'] ?? 'Location not specified',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF666666),
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),

                      // Specialties
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: _buildSpecialtyChips(
                          cooperative['specialties'],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Action Button - Contact
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
                    onPressed: () => _navigateToCooperativeProfile(cooperative),
                    icon: Icon(Icons.contact_page, size: 18),
                    label: Text(
                      'View Profile & Contact',
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSpecialtyChips(dynamic specialties) {
    if (specialties == null) return [];

    List<String> specialtyList = [];
    if (specialties is List) {
      specialtyList = specialties.cast<String>();
    } else if (specialties is String) {
      specialtyList = specialties.split(',').map((s) => s.trim()).toList();
    }

    return specialtyList.take(3).map((specialty) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _getSpecialtyColor(specialty),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          specialty,
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
      );
    }).toList();
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

  Color _getSpecialtyColor(String specialty) {
    switch (specialty.toLowerCase()) {
      case 'textiles':
        return Color(0xFF2D6723);
      case 'crafts':
        return Color(0xFFD5B694);
      case 'food':
        return Color(0xFF863A3A);
      case 'cosmetics':
        return Color(0xFF1A1A1A);
      case 'luxury':
        return Color(0xFF555555);
      case 'eco-friendly':
        return Color(0xFF2D6723);
      case 'traditional':
        return Color(0xFF863A3A);
      default:
        return Color(0xFF2D6723);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'Discover Cooperatives',
            style: TextStyle(
              color: Color(0xFF1A1A1A),
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        backgroundColor: Color(0xFFFDFBF7),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Color(0xFF1A1A1A)),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CooperativeSearchDelegate(_cooperatives),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Cooperatives List
          Expanded(
            child:
                _isLoading
                    ? _buildLoadingState()
                    : _isError
                    ? _buildErrorState()
                    : _filteredCooperatives.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                      onRefresh: _loadCooperatives,
                      color: Color(0xFF2D6723),
                      child: _buildCooperativeGrid(),
                    ),
          ),
        ],
      ),
    );
  }
}

class CooperativeSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> cooperatives;

  CooperativeSearchDelegate(this.cooperatives);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results =
        cooperatives
            .where(
              (coop) =>
                  coop['brand'].toLowerCase().contains(query.toLowerCase()) ||
                  coop['description'].toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
            .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final cooperative = results[index];
        return ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image:
                  cooperative['images'] != null &&
                          cooperative['images'].isNotEmpty
                      ? DecorationImage(
                        image: NetworkImage(cooperative['images'][0]),
                        fit: BoxFit.cover,
                      )
                      : null,
              color: Color(0xFFF5F5F5),
            ),
            child:
                cooperative['images'] == null || cooperative['images'].isEmpty
                    ? Icon(Icons.storefront_rounded, color: Color(0xFFD5B694))
                    : null,
          ),
          title: Text(cooperative['brand']),
          subtitle: Text(
            '${cooperative['products_count']} products • ${cooperative['adresse']}',
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => ViewCooperativeProfileDesigner(
                      cooperative: cooperative,
                    ),
              ),
            );
          },
        );
      },
    );
  }
}
