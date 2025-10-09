import 'dart:io';
import 'package:hirfa_frontend/Cooperative/ServicesCooperatives/chat_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class DiscussionPage extends StatefulWidget {
  final String otherUserId;
  final String otherUsername;
  final String otherProfile;
  final String otherUserType;
  final VoidCallback? onBack;

  const DiscussionPage({
    required this.otherUserId,
    required this.otherUsername,
    required this.otherProfile,
    required this.otherUserType,
    this.onBack,
    super.key,
  });

  @override
  _DiscussionPageState createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  final TextEditingController _controller = TextEditingController();
  late final String currentUserId = 'current_user_mock_id';
  List<Map<String, dynamic>> messages = [];
  final _scrollController = ScrollController();
  bool _showEmojiPicker = false;
  final FocusNode _textFieldFocus = FocusNode();
  String? _editingMessageId;
  TextEditingController _editController = TextEditingController();
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller.dispose();
    _scrollController.dispose();
    _editController.dispose();
    super.dispose();
  }

  void _toggleEmojiPicker() {
    if (_isDisposed) return;
    setState(() {
      _showEmojiPicker = !_showEmojiPicker;
      if (_showEmojiPicker) {
        FocusScope.of(context).unfocus();
      } else {
        FocusScope.of(context).requestFocus(_textFieldFocus);
      }
    });
  }

  Widget _buildEmojiPicker() {
    return EmojiPicker(
      onEmojiSelected: (Category? category, Emoji emoji) {
        final text =
            _editingMessageId != null ? _editController.text : _controller.text;
        final currentController =
            _editingMessageId != null ? _editController : _controller;

        int cursorPos = currentController.selection.base.offset;
        if (cursorPos < 0) cursorPos = text.length;

        final newText = text.replaceRange(cursorPos, cursorPos, emoji.emoji);
        if (!mounted || _isDisposed) return;
        setState(() {
          currentController.text = newText;
          currentController.selection = TextSelection.fromPosition(
            TextPosition(offset: cursorPos + emoji.emoji.length),
          );
        });
      },
      onBackspacePressed: () {
        final text =
            _editingMessageId != null ? _editController.text : _controller.text;
        final currentController =
            _editingMessageId != null ? _editController : _controller;

        int cursorPos = currentController.selection.base.offset;
        if (cursorPos <= 0) return;

        final newText = text.replaceRange(cursorPos - 1, cursorPos, '');
        if (!mounted || _isDisposed) return;
        setState(() {
          currentController.text = newText;
          currentController.selection = TextSelection.fromPosition(
            TextPosition(offset: cursorPos - 1),
          );
        });
      },
      config: Config(
        height: 250,
        emojiViewConfig: EmojiViewConfig(emojiSizeMax: 32, columns: 7),
        categoryViewConfig: CategoryViewConfig(
          iconColorSelected: Color(0xFF2D6723),
          indicatorColor: Color(0xFF2D6723),
          iconColor: Colors.black54,
          dividerColor: Colors.black45,
        ),
        bottomActionBarConfig: BottomActionBarConfig(
          backgroundColor: Color(0xFFD5B694),
        ),
        skinToneConfig: const SkinToneConfig(),
        viewOrderConfig: const ViewOrderConfig(
          top: EmojiPickerItem.categoryBar,
          middle: EmojiPickerItem.emojiView,
          bottom: EmojiPickerItem.searchBar,
        ),
      ),
    );
  }

  Future<void> fetchMessages() async {
    try {
      final mockMessages = await ChatService.getMessages(widget.otherUserId);
      if (!mounted || _isDisposed) return;
      setState(() {
        messages = mockMessages;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !_isDisposed) {
            _scrollToBottom();
          }
        });
      });
    } catch (e) {
      debugPrint('Error fetching messages: $e');
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients && mounted && !_isDisposed) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // CRUD Operations
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    try {
      // Create temporary message
      final tempMessage = {
        'id': 'temp_${DateTime.now().millisecondsSinceEpoch}',
        'sender_id': currentUserId,
        'receiver_id': widget.otherUserId,
        'content': text.trim(),
        'created_at': DateTime.now().toIso8601String(),
        'is_read': false,
        'is_temp': true,
      };

      if (!mounted || _isDisposed) return;
      setState(() {
        messages.add(tempMessage);
        _scrollToBottom();
      });

      _controller.clear();

      // Simulate API call
      final result = await ChatService.sendMessage(
        receiverId: widget.otherUserId,
        content: text.trim(),
      );

      if (result == null) {
        // Replace temp message with permanent one
        if (!mounted || _isDisposed) return;
        setState(() {
          final index = messages.indexWhere(
            (msg) => msg['id'] == tempMessage['id'],
          );
          if (index != -1) {
            messages[index] = {
              ...tempMessage,
              'id': 'perm_${DateTime.now().millisecondsSinceEpoch}',
              'is_temp': false,
            };
          }
        });
      } else {
        // Remove temp message if failed
        if (!mounted || _isDisposed) return;
        setState(() {
          messages.removeWhere((msg) => msg['id'] == tempMessage['id']);
        });
        if (mounted && !_isDisposed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to send message: $result'),
              backgroundColor: Color(0xFF863A3A),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted && !_isDisposed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending message: $e'),
            backgroundColor: Color(0xFF863A3A),
          ),
        );
      }
    }
  }

  void _editMessage(String messageId, String currentContent) {
    _editController.text = currentContent;
    if (!mounted || _isDisposed) return;
    setState(() {
      _editingMessageId = messageId;
    });
  }

  void _updateMessage() async {
    if (_editController.text.trim().isEmpty) return;

    try {
      final messageIndex = messages.indexWhere(
        (msg) => msg['id'] == _editingMessageId,
      );
      if (messageIndex != -1) {
        if (!mounted || _isDisposed) return;
        setState(() {
          messages[messageIndex]['content'] = _editController.text.trim();
          messages[messageIndex]['is_edited'] = true;
        });

        // Simulate API call
        await ChatService.updateMessage(
          messageId: _editingMessageId!,
          content: _editController.text.trim(),
        );

        if (!mounted || _isDisposed) return;
        setState(() {
          _editingMessageId = null;
        });
        _editController.clear();
      }
    } catch (e) {
      if (mounted && !_isDisposed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating message: $e'),
            backgroundColor: Color(0xFF863A3A),
          ),
        );
      }
    }
  }

  void _cancelEdit() {
    if (!mounted || _isDisposed) return;
    setState(() {
      _editingMessageId = null;
    });
    _editController.clear();
  }

  void _deleteMessage(String messageId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Color(0xFFFDFBF7),
            title: Text(
              'Delete Message',
              style: TextStyle(
                color: Color(0xFF1A1A1A),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Are you sure you want to delete this message?',
              style: TextStyle(color: Color(0xFF555555)),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Color(0xFF2D6723)),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'Delete',
                  style: TextStyle(color: Color(0xFF863A3A)),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      try {
        if (!mounted || _isDisposed) return;
        setState(() {
          messages.removeWhere((msg) => msg['id'] == messageId);
        });

        // Simulate API call
        await ChatService.deleteMessage(messageId);
      } catch (e) {
        if (mounted && !_isDisposed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting message: $e'),
              backgroundColor: Color(0xFF863A3A),
            ),
          );
        }
        // Reload messages to restore the deleted one
        fetchMessages();
      }
    }
  }

  Future<bool> _checkAndRequestPermissions() async {
    try {
      // For Android, we need storage permission
      // For iOS, we need photos permission
      Permission permission;
      if (Platform.isAndroid) {
        // For Android 13+, use photos permission, for older use storage
        if (await Permission.storage.isRestricted) {
          permission = Permission.photos;
        } else {
          permission = Permission.storage;
        }
      } else {
        permission = Permission.photos;
      }

      // Check if we already have permission
      PermissionStatus status = await permission.status;

      if (status.isGranted) {
        return true;
      } else if (status.isDenied || status.isRestricted) {
        // Request the permission
        PermissionStatus result = await permission.request();
        if (result.isGranted) {
          return true;
        } else {
          // Show explanation and open app settings
          if (mounted && !_isDisposed) {
            await showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    backgroundColor: Color(0xFFFDFBF7),
                    title: Text(
                      'Permission Required',
                      style: TextStyle(
                        color: Color(0xFF1A1A1A),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Text(
                      'This app needs access to your photos to select images. '
                      'Please enable the permission in app settings.',
                      style: TextStyle(color: Color(0xFF555555)),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Color(0xFF2D6723)),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          openAppSettings();
                        },
                        child: Text(
                          'Open Settings',
                          style: TextStyle(color: Color(0xFF863A3A)),
                        ),
                      ),
                    ],
                  ),
            );
          }
          return false;
        }
      } else if (status.isPermanentlyDenied) {
        // Directly open app settings
        await openAppSettings();
        return false;
      }

      return false;
    } catch (e) {
      debugPrint('Permission error: $e');
      return false;
    }
  }

  Future<void> pickAndPreviewImage() async {
    // Check and request permissions first
    bool hasPermission = await _checkAndRequestPermissions();

    if (!hasPermission) {
      if (mounted && !_isDisposed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Permission denied to access photos'),
            backgroundColor: Color(0xFF863A3A),
          ),
        );
      }
      return;
    }

    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 80,
      );

      if (image != null && mounted && !_isDisposed) {
        _showImagePreviewDialog(image);
      }
    } catch (e) {
      debugPrint('Image picker error: $e');
      if (mounted && !_isDisposed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: Color(0xFF863A3A),
          ),
        );
      }
    }
  }

  void _showImagePreviewDialog(XFile imageFile) {
    if (!mounted || _isDisposed) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 100,
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(imageFile.path),
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Color(0xFF863A3A),
                        size: 30,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.check_circle,
                        color: Color(0xFF2D6723),
                        size: 30,
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        await _uploadImageAndSendMessage(imageFile);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _uploadImageAndSendMessage(XFile imageFile) async {
    try {
      if (mounted && !_isDisposed) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Sending image...')));
      }

      // Create temporary image message
      final tempMessage = {
        'id': 'temp_img_${DateTime.now().millisecondsSinceEpoch}',
        'sender_id': currentUserId,
        'receiver_id': widget.otherUserId,
        'content': 'https://example.com/uploaded-image.jpg',
        'created_at': DateTime.now().toIso8601String(),
        'is_read': false,
        'is_temp': true,
      };

      if (!mounted || _isDisposed) return;
      setState(() {
        messages.add(tempMessage);
        _scrollToBottom();
      });

      // Simulate image upload
      await Future.delayed(Duration(seconds: 2));

      final result = await ChatService.sendMessage(
        receiverId: widget.otherUserId,
        content: 'https://example.com/uploaded-image.jpg',
      );

      if (result == null) {
        // Replace temp message with permanent one
        if (!mounted || _isDisposed) return;
        setState(() {
          final index = messages.indexWhere(
            (msg) => msg['id'] == tempMessage['id'],
          );
          if (index != -1) {
            messages[index] = {
              ...tempMessage,
              'id': 'perm_img_${DateTime.now().millisecondsSinceEpoch}',
              'is_temp': false,
            };
          }
        });
      } else {
        // Remove temp message if failed
        if (!mounted || _isDisposed) return;
        setState(() {
          messages.removeWhere((msg) => msg['id'] == tempMessage['id']);
        });
        if (mounted && !_isDisposed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error sending image: $result')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error sending image: $e');
      if (mounted && !_isDisposed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending: ${e.toString()}')),
        );
      }
    }
  }

  bool isImage(String content) {
    return content.startsWith('https://') &&
        (content.endsWith('.png') ||
            content.endsWith('.jpg') ||
            content.endsWith('.jpeg') ||
            content.contains('chat-images') ||
            content.contains('storage/v1/object/public/chat-images'));
  }

  String _getUserTypeBadge(String userType) {
    switch (userType.toLowerCase()) {
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

  String _getUserTypeFullName(String userType) {
    switch (userType.toLowerCase()) {
      case 'designer':
        return 'Designer';
      case 'cooperative':
        return 'Cooperative';
      case 'client':
        return 'Client';
      default:
        return 'User';
    }
  }

  Color _getUserTypeColor(String userType) {
    switch (userType.toLowerCase()) {
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

  Widget buildMessage(Map<String, dynamic> msg) {
    final isMe = msg['sender_id'] == currentUserId;
    final content = msg['content'];
    final isImageMsg = isImage(content);
    final isTemp = msg['is_temp'] == true;
    final isEdited = msg['is_edited'] == true;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            // Removed report button for received messages
            SizedBox(width: 4),
          ],
          Flexible(
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        isMe
                            ? Color(0xFF2D6723).withOpacity(0.1)
                            : Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        isTemp
                            ? Border.all(color: Color(0xFFD5B694), width: 1)
                            : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isImageMsg)
                        Image.network(
                          content,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return SizedBox(
                              width: 200,
                              height: 200,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF2D6723),
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes!
                                          : null,
                                ),
                              ),
                            );
                          },
                        )
                      else
                        Text(
                          content,
                          style: TextStyle(
                            color: isMe ? Color(0xFF1A1A1A) : Color(0xFF1A1A1A),
                          ),
                        ),
                      if (isEdited || isTemp) ...[
                        SizedBox(height: 4),
                        Text(
                          isTemp ? 'Sending...' : 'Edited',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFF777777),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (isMe && !isTemp)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: PopupMenuButton<String>(
                      color: Colors.white,
                      onSelected: (value) {
                        if (value == 'edit') {
                          _editMessage(msg['id'], content);
                        } else if (value == 'delete') {
                          _deleteMessage(msg['id']);
                        }
                      },
                      itemBuilder:
                          (context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit,
                                    color: Color(0xFF2D6723),
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Edit',
                                    style: TextStyle(color: Color(0xFF2D6723)),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: Color(0xFF863A3A),
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Delete',
                                    style: TextStyle(color: Color(0xFF863A3A)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.more_vert,
                          color: Color(0xFF555555),
                          size: 14,
                        ),
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

  Widget _buildEditMessageInput() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFFDFBF7),
        border: Border(top: BorderSide(color: Color(0xFFD5B694))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _editController,
              decoration: InputDecoration(
                hintText: "Edit message...",
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(width: 1.8, color: Color(0xFF2D6723)),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.check, color: Color(0xFF2D6723)),
            onPressed: _updateMessage,
          ),
          IconButton(
            icon: Icon(Icons.close, color: Color(0xFF863A3A)),
            onPressed: _cancelEdit,
          ),
        ],
      ),
    );
  }

  // Handle back button press
  Future<bool> _onWillPop() async {
    if (_showEmojiPicker) {
      setState(() => _showEmojiPicker = false);
      return false;
    }

    if (_editingMessageId != null) {
      _cancelEdit();
      return false;
    }

    // Navigate back to chat list - call onBack before returning
    if (widget.onBack != null) {
      widget.onBack!();
      return false; // Return false to prevent default Navigator pop
    }

    // Only allow default pop behavior if there's no onBack callback
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final hasProfileImage = widget.otherProfile.toString().isNotEmpty;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Color(0xFFFDFBF7),
        appBar: AppBar(
          title: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor:
                        hasProfileImage
                            ? Colors.transparent
                            : Color(0xFFD5B694),
                    child:
                        !hasProfileImage
                            ? const Icon(
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
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getUserTypeColor(widget.otherUserType),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getUserTypeBadge(widget.otherUserType),
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
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.otherUsername,
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    _getUserTypeFullName(widget.otherUserType),
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          backgroundColor: Color(0xFF2D6723),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              if (widget.onBack != null) {
                widget.onBack!();
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            if (_showEmojiPicker) {
              setState(() => _showEmojiPicker = false);
            }
          },
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder:
                      (context, index) => buildMessage(messages[index]),
                  padding: const EdgeInsets.all(8),
                ),
              ),
              if (_editingMessageId != null) _buildEditMessageInput(),
              if (_showEmojiPicker)
                SizedBox(height: 250, child: _buildEmojiPicker()),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24.0,
                  horizontal: 8.0,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.image, color: Color(0xFF2D6723)),
                      onPressed: pickAndPreviewImage,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.emoji_emotions,
                        color: Color(0xFF2D6723),
                      ),
                      onPressed: _toggleEmojiPicker,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _textFieldFocus,
                        decoration: InputDecoration(
                          hintText: "Type a message...",
                          contentPadding: const EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(
                              width: 1.8,
                              color: Color(0xFF2D6723),
                            ),
                          ),
                        ),
                        onSubmitted: sendMessage,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Color(0xFF2D6723)),
                      onPressed: () => sendMessage(_controller.text),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
