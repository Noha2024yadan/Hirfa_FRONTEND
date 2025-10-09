import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ChatService {
  static const String baseUrl = 'http://your-api-url.com/api';
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Get JWT token
  static Future<String?> _getToken() async {
    // For simulation, return a mock token or null
    return await _storage.read(key: 'jwt_token');
  }

  // Get conversations for current user
  static Future<List<Map<String, dynamic>>> getConversations() async {
    try {
      final token = await _getToken();

      // Simulate API call
      await Future.delayed(Duration(milliseconds: 500));

      return _getMockConversations();
    } catch (e) {
      return _getMockConversations();
    }
  }

  // Send message
  static Future<String?> sendMessage({
    required String receiverId,
    required String content,
  }) async {
    try {
      final token = await _getToken();

      // Simulate API call
      await Future.delayed(Duration(milliseconds: 300));

      // For simulation, always return success
      return null;
    } catch (e) {
      return "Network or server error";
    }
  }

  // Update message
  static Future<String?> updateMessage({
    required String messageId,
    required String content,
  }) async {
    try {
      final token = await _getToken();

      // Simulate API call
      await Future.delayed(Duration(milliseconds: 300));

      // For simulation, always return success
      return null;
    } catch (e) {
      return "Network or server error";
    }
  }

  // Delete message
  static Future<String?> deleteMessage(String messageId) async {
    try {
      final token = await _getToken();

      // Simulate API call
      await Future.delayed(Duration(milliseconds: 300));

      // For simulation, always return success
      return null;
    } catch (e) {
      return "Network or server error";
    }
  }

  // Get messages between users
  static Future<List<Map<String, dynamic>>> getMessages(
    String otherUserId,
  ) async {
    try {
      final token = await _getToken();

      // Simulate API call
      await Future.delayed(Duration(milliseconds: 500));

      return _getMockMessages(otherUserId);
    } catch (e) {
      return _getMockMessages(otherUserId);
    }
  }

  // Mock data for conversations
  static List<Map<String, dynamic>> _getMockConversations() {
    final now = DateTime.now();
    return [
      {
        "user": {
          "id": "1",
          "username": "Eco Crafts Collective",
          "profile_img": "",
          "user_type": "cooperative",
        },
        "message": "Hi! I'm interested in your design services",
        "isImage": false,
        "timestamp": now.subtract(Duration(minutes: 5)).toIso8601String(),
      },
      {
        "user": {
          "id": "2",
          "username": "Creative Designs Co",
          "profile_img": "",
          "user_type": "designer",
        },
        "message": "Let's discuss the product specifications",
        "isImage": false,
        "timestamp": now.subtract(Duration(hours: 2)).toIso8601String(),
      },
      {
        "user": {
          "id": "3",
          "username": "Atlas Artisans",
          "profile_img": "",
          "user_type": "cooperative",
        },
        "message": "Thanks for the collaboration!",
        "isImage": false,
        "timestamp": now.subtract(Duration(days: 1)).toIso8601String(),
      },
      {
        "user": {
          "id": "4",
          "username": "Modern Design Studio",
          "profile_img": "",
          "user_type": "designer",
        },
        "message": "I have some design concepts to share",
        "isImage": false,
        "timestamp": now.subtract(Duration(hours: 3)).toIso8601String(),
      },
    ];
  }

  // Mock data for messages
  static List<Map<String, dynamic>> _getMockMessages(String otherUserId) {
    final now = DateTime.now();
    return [
      {
        "id": "1",
        "sender_id": otherUserId,
        "receiver_id": "current_user_mock_id",
        "content": "Hello! I'm interested in collaborating with you",
        "created_at": now.subtract(Duration(hours: 3)).toIso8601String(),
        "is_read": true,
      },
      {
        "id": "2",
        "sender_id": "current_user_mock_id",
        "receiver_id": otherUserId,
        "content": "Hi! I'd love to hear more about your project",
        "created_at":
            now.subtract(Duration(hours: 2, minutes: 45)).toIso8601String(),
        "is_read": true,
      },
      {
        "id": "3",
        "sender_id": otherUserId,
        "receiver_id": "current_user_mock_id",
        "content": "We need designs for our new product line",
        "created_at":
            now.subtract(Duration(hours: 2, minutes: 30)).toIso8601String(),
        "is_read": true,
      },
      {
        "id": "4",
        "sender_id": "current_user_mock_id",
        "receiver_id": otherUserId,
        "content": "Can you share more details about the requirements?",
        "created_at": now.subtract(Duration(minutes: 5)).toIso8601String(),
        "is_read": false,
      },
    ];
  }
}
