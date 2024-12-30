import 'package:flutter/material.dart';
import 'package:waloma/core/model/Message.dart';
import 'package:waloma/core/model/message_models/ChatUser.dart';
import 'package:waloma/core/services/message_services/message_services.dart';

class MessageProvider extends ChangeNotifier {
  List<Message> _messages = [];
  List<Message> get messages => _messages;
  List<ChatUser> _chatUsers = [];

  // Getter with logging
  List<ChatUser> get chatUsers {
    print('Getter called: chatUsers length is ${_chatUsers.length}');
    return _chatUsers;
  }

  // Setter or update method with logging
  void updateChatUsers(List<ChatUser> users) {
    print('Updating chatUsers with ${users.length} new users.');
    _chatUsers = users;
    notifyListeners();
    print('Listeners notified after updating chatUsers.');
  }

  ChatUser _userData = ChatUser(
      id: 0,
      firstName: '',
      lastName: '',
      profileDetails: {},
      status: '',
      isRead: false);

  ChatUser get userData => _userData;
  List<Map<String, dynamic>> _chatUserIds = [];
  List<Map<String, dynamic>> get chatUserIds => _chatUserIds;

  Map<String, dynamic> _userDetails = {};
  Map<String, dynamic> get userDetails => _userDetails;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _unreadMessagesCount = 0;
  int get unreadMessagesCount => _unreadMessagesCount;

  ChatService chatService = ChatService();

  // Connect WebSocket
  Future<void> initializeSocket(int userId, {String authToken = ''}) async {
    chatService.initializeSocket(userId, authToken: authToken);
  }

  void handleChatUsers(dynamic data) {
    print('handleChatUsers called with data: $data');

    if (data == null) {
      print('Data is null.');
      return;
    }

    if (data is! List) {
      print('Invalid data type. Expected a List.');
      return;
    }

    if (data.isEmpty) {
      print('Data is empty.');
      return;
    }

    try {
      print('Before update: ${_chatUsers.length}');
      final updatedUsers = (data)
          .where((user) => user != null)
          .map((user) => ChatUser.fromJson(user as Map<String, dynamic>))
          .toList();
      _chatUsers = updatedUsers;
      print('After update: ${_chatUsers.length}');
      notifyListeners();
      print('Listeners notified.');
    } catch (e, stackTrace) {
      print('Error in handleChatUsers: $e');
      print('Stack trace: $stackTrace');
    }
  }

  void handleChatReceiver(dynamic data) {
    print('handleChatReceiver called with data: $data');

    if (data == null) {
      print('Data is null.');
      return;
    }

    if (data is! Map<String, dynamic>) {
      print('Invalid data type. Expected a Map<String, dynamic>.');
      return;
    }

    try {
      // Parse the single user data into a ChatUser object
      _userData = ChatUser.fromJson(data);

      // Notify listeners if this is part of a ChangeNotifier or similar pattern
      notifyListeners();
      print('User updated: ${_userData.firstName} ${_userData.lastName}');
      print('User latest Message: ${_userData.lastMessage}');
    } catch (e, stackTrace) {
      print('Error in handleChatReceiver: $e');
      print('Stack trace: $stackTrace');
    }
  }

  void updateUnreadCount(int? newUnreadCount) {
    if (newUnreadCount != null && newUnreadCount != _unreadMessagesCount) {
      _unreadMessagesCount = newUnreadCount;
      notifyListeners();
    }
  }

  void markReader(int senderId, int receiverId) {
    chatService.markMessagesAsRead(senderId, receiverId);
    notifyListeners();
  }

  // Fetch user details
  Future<void> fetchUserDetails(int userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final userDetails = await ChatService.fetchUserDetails(userId);
      _userDetails = userDetails;
    } catch (e) {
      print("Error in fetchUserDetails: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch messages between two users and update provider state
  Future<void> fetchMessages(int userId1, int userId2) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Fetch messages from the service
      final fetchedMessages = await ChatService.fetchMessages(userId1, userId2);

      // Parse and store the messages in chronological order
      _messages = fetchedMessages.map<Message>((msg) {
        return Message.fromJson(msg);
      }).toList();

      print("Messages successfully fetched: $_messages");
    } catch (e) {
      print("Error in MessageProvider fetchMessages: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addMessageFromMap(Map<String, dynamic> messageMap) {
    // Convert the map to a Message object
    final message = Message.fromJson(messageMap);

    // Now call addMessage with the Message object
    addMessage(message);
  }

  void addMessage(Message message) {
    _messages.insert(0, message);

    print("Message added locally: ${message.content}");
    chatService.sendMessage(
        message.senderId, message.receiverId, message.isRead, message.content);
    notifyListeners();
  }

  // Disconnect WebSocket
  void disconnectSocket() {
    chatService.disconnectSocket();
  }
}
