import 'package:flutter/material.dart';
import 'package:hirfa_frontend/Cooperative/ServicesCooperatives/designs_service.dart';
import 'package:hirfa_frontend/Cooperative/design_detail_screen.dart';
import 'package:hirfa_frontend/Designers/ServicesDesigners/crud_design.dart';

class DiscoverCooperative extends StatefulWidget {
  const DiscoverCooperative({super.key});

  @override
  State<DiscoverCooperative> createState() => _DiscoverCooperativeState();
}

class _DiscoverCooperativeState extends State<DiscoverCooperative> {
  List<Map<String, dynamic>> _designs = [];
  bool _isLoading = true;
  bool _isError = false;
  final TextEditingController _searchController = TextEditingController();

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

      final designs = await CrudDesign.getAllDesigns();
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

  void _navigateToDesignDetail(Map<String, dynamic> design) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DesignDetailScreen(design: design),
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredDesigns {
    var filtered = _designs;

    // Filter by search
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered =
          filtered
              .where(
                (design) =>
                    design['nom_design'].toLowerCase().contains(query) ||
                    design['description'].toLowerCase().contains(query) ||
                    design['designer_name'].toLowerCase().contains(query),
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
            'Loading designs...',
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
          Icon(Icons.design_services, size: 80, color: Color(0xFFD5B694)),
          SizedBox(height: 16),
          Text(
            'No Designs Found',
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

  Widget _buildDesignGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: _filteredDesigns.length,
      itemBuilder: (context, index) {
        final design = _filteredDesigns[index];
        return _buildDesignCard(design);
      },
    );
  }

  Widget _buildDesignCard(Map<String, dynamic> design) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _navigateToDesignDetail(design),
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Design Image
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      color: Color(0xFFF5F5F5),
                      image:
                          design['images'] != null &&
                                  design['images'].isNotEmpty
                              ? DecorationImage(
                                image: NetworkImage(design['images'][0]),
                                fit: BoxFit.cover,
                              )
                              : null,
                    ),
                    child:
                        design['images'] == null || design['images'].isEmpty
                            ? Icon(
                              Icons.design_services,
                              color: Color(0xFFD5B694),
                              size: 40,
                            )
                            : null,
                  ),
                ),

                // Design Info
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        design['nom_design'] ?? 'No Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF1A1A1A),
                          fontFamily: 'Poppins',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${design['prix']?.toStringAsFixed(2) ?? '0.00'} DH',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D6723),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        design['designer_name'] ?? 'Unknown Designer',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF666666),
                          fontFamily: 'Poppins',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),

            // Icône de signalement discrète en haut à droite
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed:
                      () => _reportDesign(
                        design['design_id'],
                        design['nom_design'],
                      ),

                  icon: Icon(
                    Icons.report_outlined,
                    size: 16,
                    color: Color.fromARGB(255, 245, 11, 11), //0xFF863A3A
                  ),
                  padding: EdgeInsets.zero,
                  splashRadius: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _reportDesign(String designId, String designName) {
    TextEditingController reportController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              'Report Design',
              style: TextStyle(
                color: Color(0xFF1A1A1A),
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Why do you want to report "$designName"?',
                  style: const TextStyle(
                    color: Color(0xFF555555),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: reportController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Please describe the reason for reporting...',
                    hintStyle: const TextStyle(
                      color: Color(0xFFA0A0A0),
                      fontSize: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFD5B694)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF2D6723)),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Color(0xFF555555),
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final reason = reportController.text.trim();
                  if (reason.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please provide a reason for reporting'),
                        backgroundColor: Color(0xFF863A3A),
                      ),
                    );
                    return;
                  }

                  // Logique de signalement avec la raison
                  _submitReport(designId, reason);
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('"$designName" has been reported'),
                      backgroundColor: const Color(0xFF863A3A),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFFFFF),
                  foregroundColor: const Color(0xFF863A3A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Submit Report',
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

  // Méthode pour soumettre le signalement
  void _submitReport(String designId, String reason) async {
    final success = await DesignsService.reportDesign(
      designId: designId,
      reason: reason,
    );

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to send report. Please try again.'),
          backgroundColor: Color(0xFF863A3A),
        ),
      );
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
            'Discover Designs',
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
                delegate: DesignSearchDelegate(_designs),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Designs Grid
          Expanded(
            child:
                _isLoading
                    ? _buildLoadingState()
                    : _isError
                    ? _buildErrorState()
                    : _filteredDesigns.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                      onRefresh: _loadDesigns,
                      color: Color(0xFF2D6723),
                      child: _buildDesignGrid(),
                    ),
          ),
        ],
      ),
    );
  }
}

class DesignSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> designs;

  DesignSearchDelegate(this.designs);

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
        designs
            .where(
              (design) =>
                  design['nom_design'].toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
                  design['description'].toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
                  design['designer_name'].toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
            .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final design = results[index];
        return ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image:
                  design['images'] != null && design['images'].isNotEmpty
                      ? DecorationImage(
                        image: NetworkImage(design['images'][0]),
                        fit: BoxFit.cover,
                      )
                      : null,
              color: Color(0xFFF5F5F5),
            ),
            child:
                design['images'] == null || design['images'].isEmpty
                    ? Icon(Icons.design_services, color: Color(0xFFD5B694))
                    : null,
          ),
          title: Text(design['nom_design']),
          subtitle: Text('${design['prix']} DH • ${design['designer_name']}'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DesignDetailScreen(design: design),
              ),
            );
          },
        );
      },
    );
  }
}
