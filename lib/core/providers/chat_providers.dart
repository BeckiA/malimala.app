// import 'package:flutter/material.dart';
// import 'package:waloma/core/model/MyMessages.dart';
// import 'package:waloma/core/model/UserModel.dart';
// import 'package:waloma/core/services/message_services/message_services.dart';

// class ChatProvider extends ChangeNotifier {
//   List<MessageModel> _messages = [];
//   List<UserModel> _chatUsers = [];
//   bool _isLoading = false;
//   int? _currentUserId;

//   List<MessageModel> get messages => _messages;
//   List<UserModel> get chatUsers => _chatUsers;
//   bool get isLoading => _isLoading;

//   UserModel getUserById(int id) {
//     return chatUsers.firstWhere((user) => user.id == id);
//   }

//   /// Initialize the chat provider with a user ID
//   Future<void> initialize(int userId, String authToken) async {
//     _currentUserId = userId;
//     _isLoading = true;
//     notifyListeners();

//     // Initialize WebSocket connection
//     ChatService.initializeSocket(userId, authToken: authToken);

//     // Listen for real-time messages
//     ChatService.listenForMessages((data) {
//       final newMessage = MessageModel.fromJson(data);
//       _messages.add(newMessage);
//       notifyListeners();
//     });

//     // Fetch initial chat users
//     await fetchChatUsers();
//     _isLoading = false;
//     notifyListeners();
//   }

//   /// Fetch chat users via REST API
//   Future<void> fetchChatUsers() async {
//     if (_currentUserId == null) return;

//     try {
//       _isLoading = true;
//       notifyListeners();
//       final users = await ChatService.fetchUserChats(_currentUserId!);
//       _chatUsers = users.map((user) => UserModel.fromJson(user)).toList();
//     } catch (e) {
//       debugPrint('Error fetching chat users: $e');
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   /// Fetch messages between two users via REST API
//   Future<void> fetchMessages(int receiverId) async {
//     if (_currentUserId == null) return;

//     try {
//       _isLoading = true;
//       notifyListeners();
//       final messages =
//           await ChatService.fetchMessages(_currentUserId!, receiverId);
//       _messages =
//           messages.map((message) => MessageModel.fromJson(message)).toList();
//     } catch (e) {
//       debugPrint('Error fetching messages: $e');
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   /// Send a message via WebSocket
//   void sendMessage(int receiverId, String text) {
//     if (_currentUserId == null) return;

//     final newMessage = MessageModel(
//       senderId: _currentUserId!,
//       receiverId: receiverId,
//       text: text,
//       timestamp: DateTime.now(),
//     );

//     // Optimistically add the message to the list
//     _messages.add(newMessage);
//     notifyListeners();

//     // Send the message to the server
//     ChatService.sendMessage(_currentUserId!, receiverId, text);
//   }

//   /// Handle WebSocket disconnection
//   void disconnect() {
//     ChatService.disconnectSocket();
//     _messages.clear();
//     _chatUsers.clear();
//     notifyListeners();
//   }
// }
