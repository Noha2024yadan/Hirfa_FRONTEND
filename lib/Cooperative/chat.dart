import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatList extends StatefulWidget {
  final String currentUserId;
  final String? currentUserRole;
  final Function(Map<String, dynamic> user)? onDiscussionSelected;

  const ChatList({
    required this.currentUserId,
    this.currentUserRole,
    this.onDiscussionSelected,
    super.key,
  });

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  List<Map<String, dynamic>> _conversations = [];
  bool _loading = true;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    fetchConversations();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  bool isImage(String content) {
    return content.startsWith('https://') &&
        (content.endsWith('.png') ||
            content.endsWith('.jpg') ||
            content.endsWith('.jpeg') ||
            content.contains('chat-images') ||
            content.contains('storage/v1/object/public/chat-images'));
  }

  // Check if current user can contact this user type
  bool _canContactUser(String otherUserType) {
    final currentUserRole = widget.currentUserRole?.toLowerCase();
    final otherType = otherUserType.toLowerCase();

    // Cooperatives can contact designers
    if (currentUserRole == 'cooperative' && otherType == 'designer') {
      return true;
    }

    // Designers can contact cooperatives
    if (currentUserRole == 'designer' && otherType == 'cooperative') {
      return true;
    }

    // Cooperatives cannot contact other cooperatives
    if (currentUserRole == 'cooperative' && otherType == 'cooperative') {
      return false;
    }

    // Designers cannot contact other designers
    if (currentUserRole == 'designer' && otherType == 'designer') {
      return false;
    }

    // Clients cannot contact anyone in this system
    if (currentUserRole == 'client') {
      return false;
    }

    return false;
  }

  // Check if user can access chat feature
  bool _canAccessChat() {
    final currentUserRole = widget.currentUserRole?.toLowerCase();
    return currentUserRole == 'cooperative' || currentUserRole == 'designer';
  }

  Future<void> fetchConversations() async {
    try {
      // Simulate API delay
      await Future.delayed(Duration(milliseconds: 1000));

      // Check if widget is still mounted before proceeding
      if (_isDisposed || !mounted) {
        return;
      }

      // Mock conversations data
      final allMockConversations = [
        {
          'user': {
            'id': '1',
            'username': 'Eco Crafts Collective',
            'profile_img': '',
            'user_type': 'cooperative',
          },
          'message': 'Hi! I\'m interested in your design services',
          'isImage': false,
          'timestamp':
              DateTime.now().subtract(Duration(minutes: 5)).toIso8601String(),
        },
        {
          'user': {
            'id': '2',
            'username': 'Creative Designs Co',
            'profile_img': '',
            'user_type': 'designer',
          },
          'message': 'Let\'s discuss the product specifications',
          'isImage': false,
          'timestamp':
              DateTime.now().subtract(Duration(hours: 2)).toIso8601String(),
        },
        {
          'user': {
            'id': '3',
            'username': 'Atlas Artisans',
            'profile_img': '',
            'user_type': 'cooperative',
          },
          'message': 'Thanks for the collaboration!',
          'isImage': false,
          'timestamp':
              DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
        },
        {
          'user': {
            'id': '4',
            'username': 'Modern Design Studio',
            'profile_img': '',
            'user_type': 'designer',
          },
          'message': 'I have some design concepts to share',
          'isImage': false,
          'timestamp':
              DateTime.now().subtract(Duration(hours: 3)).toIso8601String(),
        },
      ];

      // Filter conversations based on contact rules
      final filteredConversations =
          allMockConversations.where((convo) {
            final user = convo['user'] as Map<String, dynamic>?;
            final userType = user?['user_type'] as String?;
            return userType != null && _canContactUser(userType);
          }).toList();

      // Check mounted again before setState
      if (!mounted || _isDisposed) return;

      setState(() {
        _conversations = filteredConversations;
        _loading = false;
      });
    } catch (e) {
      debugPrint('Error fetching conversations: $e');

      // Check mounted before setState in error case
      if (!mounted || _isDisposed) return;

      setState(() {
        _loading = false;
      });

      // Check mounted before showing snackbar
      if (mounted && !_isDisposed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load conversations'),
            backgroundColor: Color(0xFF863A3A),
          ),
        );
      }
    }
  }

  String _getUserTypeBadge(String? userType) {
    switch (userType?.toLowerCase()) {
      case 'designer':
        return 'Designer';
      case 'cooperative':
        return 'Coop';
      case 'client':
        return 'Client';
      default:
        return 'User';
    }
  }

  Color _getUserTypeColor(String? userType) {
    switch (userType?.toLowerCase()) {
      case 'designer':
        return Color(0xFF2D6723);
      case 'cooperative':
        return Color(0xFFD5B694);
      case 'client':
        return Color(0xFF1A1A1A);
      default:
        return Color(0xFF555555);
    }
  }

  Widget _buildAccessRestrictedMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.group_off, size: 80, color: Color(0xFFD5B694)),
          SizedBox(height: 16),
          Text(
            'Chat Access Restricted',
            style: TextStyle(
              color: Color(0xFF555555),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'Chat feature is only available for Cooperatives and Designers.\n\n'
              'If you are a Client, please contact support for assistance.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF777777),
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRestrictionMessage() {
    final currentUserRole = widget.currentUserRole?.toUpperCase() ?? 'Unknown';

    String message = '';
    if (currentUserRole == 'COOPERATIVE') {
      message = 'Hello Cooperative!';
    } else if (currentUserRole == 'DESIGNER') {
      message = 'Hello Designer!';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_outlined, size: 80, color: Color(0xFFD5B694)),
          SizedBox(height: 16),
          Text(
            'No conversations yet',
            style: TextStyle(
              color: Color(0xFF555555),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              '$message\nStart a conversation now!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF777777),
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check if user can access chat at all
    if (!_canAccessChat()) {
      return _buildAccessRestrictedMessage();
    }

    if (_loading) {
      return Center(child: CircularProgressIndicator(color: Color(0xFF2D6723)));
    }

    // Show restriction message if no conversations are allowed
    if (_conversations.isEmpty) {
      return _buildContactRestrictionMessage();
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListView.builder(
          itemCount: _conversations.length,
          itemBuilder: (context, index) {
            final convo = _conversations[index];
            final user = convo['user'];
            final isImageMsg = convo['isImage'];
            final msg = convo['message'];
            final timestamp = convo['timestamp'];
            final hasProfileImage =
                user['profile_img'] != null &&
                user['profile_img'].toString().isNotEmpty;

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              color: Color(0xFFFDFBF7),
              elevation: 1,
              child: InkWell(
                borderRadius: BorderRadius.circular(12.0),
                onTap: () {
                  if (widget.onDiscussionSelected != null) {
                    widget.onDiscussionSelected!(user);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor:
                                hasProfileImage
                                    ? Colors.transparent
                                    : Color(0xFFD5B694),
                            child:
                                !hasProfileImage
                                    ? Icon(
                                      Icons.person,
                                      size: 24,
                                      color: Colors.white,
                                    )
                                    : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _getUserTypeColor(user['user_type']),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _getUserTypeBadge(user['user_type']),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  user['username'] ?? 'Unknown User',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFF1A1A1A),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                if (isImageMsg) ...[
                                  Icon(
                                    Icons.image,
                                    size: 16,
                                    color: Color(0xFF4A5568),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Image',
                                    style: TextStyle(color: Color(0xFF4A5568)),
                                  ),
                                ] else
                                  Flexible(
                                    child: Text(
                                      msg,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: Color(0xFF4A5568),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _formatTimestamp(timestamp),
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF4A5568),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatTimestamp(String timestamp) {
    try {
      final messageLocal = DateTime.parse(timestamp);
      final nowLocal = DateTime.now();
      final difference = nowLocal.difference(messageLocal);

      if (difference.isNegative) return 'Just now';

      if (difference.inDays > 7) {
        return DateFormat('d/M/yyyy').format(messageLocal);
      } else if (difference.inDays >= 1) {
        return '${difference.inDays}d';
      } else if (difference.inHours >= 1) {
        return '${difference.inHours}h';
      } else if (difference.inMinutes >= 1) {
        return '${difference.inMinutes}m';
      } else {
        return 'Now';
      }
    } catch (e) {
      debugPrint('Error formatting timestamp: $e');
      return '';
    }
  }
}
