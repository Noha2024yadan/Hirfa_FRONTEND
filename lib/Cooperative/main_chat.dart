import 'package:flutter/material.dart';
import 'package:hirfa_frontend/Cooperative/chat.dart';
import 'package:hirfa_frontend/Cooperative/discussion_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainChat extends StatefulWidget {
  const MainChat({super.key});

  @override
  State<MainChat> createState() => _MainChatState();
}

class _MainChatState extends State<MainChat> {
  String? _selectedUserId;
  String? _selectedUsername;
  String? _selectedProfile;
  String? _selectedUserType;
  String? _currentUserRole;

  @override
  void initState() {
    super.initState();
    _getCurrentUserRole();
  }

  void _getCurrentUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUserRole = prefs.getString('user_role');
    });
  }

  void _onDiscussionSelected(Map<String, dynamic> user) {
    setState(() {
      _selectedUserId = user['id'];
      _selectedUsername = user['username'];
      _selectedProfile = user['profile_img'];
      _selectedUserType = user['user_type'];
    });
  }

  void _onBackFromDiscussion() {
    setState(() {
      _selectedUserId = null;
      _selectedUsername = null;
      _selectedProfile = null;
      _selectedUserType = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedUserId != null) {
      return DiscussionPage(
        otherUserId: _selectedUserId!,
        otherUsername: _selectedUsername!,
        otherProfile: _selectedProfile ?? '',
        otherUserType: _selectedUserType ?? 'user',
        onBack: _onBackFromDiscussion,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Messages',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF2D6723),
        foregroundColor: Colors.white,
      ),
      body: ChatList(
        currentUserId: 'current_user_mock_id',
        currentUserRole: _currentUserRole,
        onDiscussionSelected: _onDiscussionSelected,
      ),
    );
  }
}
