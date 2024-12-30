import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:waloma/core/config/app_configuration.dart';
import 'package:waloma/core/providers/message_providers.dart';

class ChatService {
  static var client = http.Client();
  late IO.Socket socket;
  final MessageProvider? messageProvider;

  ChatService({this.messageProvider});

  /// Initialize WebSocket connection using Socket.IO
  void initializeSocket(int userId, {String authToken = ''}) async {
    socket = IO.io(
      'ws://${AppConfiguration.apiURL}',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setQuery({'userId': userId.toString()})
          .build(),
    );
    // Connection events
    socket.onConnect((_) {
      print('Connected to WebSocket: ${socket.id}');
      socket.emit('user_connected', userId);
      // socket.emit('fetch_chat_users', userId);
      socket.emit('fetchUnreadCount', userId);
      socket.emit('fetch_user_by_id', userId);
      socket.emit('fetch_chat_users_with_last_message', userId);
    });

    socket.onDisconnect((_) {
      print('Disconnected from WebSocket');
      socket.emit('user_disconnected', userId);
    });

    // Listen for chat users
    socket.on('chat_users', (data) {
      print('Chat users received from WebSocket: $data');
      messageProvider?.handleChatUsers(data);
    });

    socket.on('user_by_id', ((data) {
      print("Message Reciever User: $data");
      messageProvider?.handleChatReceiver(data);
    }));
    // Listen for real-time user status updates
    socket.on('user_connected', (data) {
      print('User connected: $data');
    });

    socket.on('messages_marked_as_read', (data) {
      print('Messages marked as read for conversation: $data');
      messageProvider?.updateUnreadCount(data);
    });

    socket.on('user_disconnected', (data) {
      print('User disconnected: $data');
    });

    // Listen for real-time updates on the unread count
    socket.on('unreadCount', (data) {
      print('Unread count updated: $data');
      final unreadCount = data['unreadCount'] as int?;
      if (unreadCount != null) {
        messageProvider?.updateUnreadCount(unreadCount); // Update provider
      }
    });
  }

  /// Fetch user details (name, avatar, and status)
  static Future<Map<String, dynamic>> fetchUserDetails(int userId) async {
    try {
      final url = Uri.http(
        AppConfiguration.apiURL,
        '${AppConfiguration.userDetailsAPI}/$userId',
      );

      final response = await client.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("USER: $data");

        if (data['success'] == true && data['user'] != null) {
          return {
            'id': data['user']['id'],
            'name':
                '${data['user']['first_name']} ${data['user']['last_name']}',
            'avatar': data['user']['profile_details']?['profile_image'] ??
                '/default-avatar.jpg',
            'status': data['user']['status'],
          };
        } else {
          throw Exception(
              'Error fetching user details: Invalid response structure');
        }
      } else {
        throw Exception('Error fetching user details: ${response.statusCode}');
      }
    } catch (e) {
      print("Error in fetchUserDetails: $e");
      throw e;
    }
  }

  void sendMessage(int senderId, int receiverId, bool isRead, String text) {
    if (socket.connected) {
      final message = {
        'senderId': senderId.toString(),
        'receiverId': receiverId.toString(),
        'isRead': isRead,
        'text': text,
      };

      socket.emit('send_message', message);
      print('Message sent: $message');
    } else {
      print('Error: WebSocket is not connected.');
    }
  }

  /// Fetch messages between two users via REST API
  static Future<List<Map<String, dynamic>>> fetchMessages(
      int userId1, int userId2) async {
    try {
      // Construct the API URL
      final url = Uri.http(
        AppConfiguration.apiURL,
        '${AppConfiguration.chatUsersAPI}/$userId1/$userId2',
      );

      // Send GET request
      final response = await client.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Return the list of messages from the response
        return List<Map<String, dynamic>>.from(data['messages']);
      } else {
        // Handle non-200 status codes
        throw Exception('Error fetching messages: ${response.statusCode}');
      }
    } catch (e) {
      print("Error in fetchMessages: $e");
      throw e;
    }
  }

  // void fetchUnreadCount(int receiverId) {
  //   socket.on('unreadCount', (data) {
  //     final unreadCount = data['unreadCount'];
  //     messageProvider?.updateUnreadCount(unreadCount);
  //   });
  // }

  void markMessagesAsRead(int senderId, int receiverId) {
    if (socket.connected) {
      socket.emit('mark_messages_read', {
        'senderId': senderId,
        'receiverId': receiverId,
      });
      print(
          'Mark messages as read emitted for sender: $senderId, receiver: $receiverId');
    } else {
      print('Error: WebSocket is not connected.');
    }
  }

  /// Disconnect WebSocket connection
  void disconnectSocket() {
    if (socket.connected) {
      socket.emit('user_disconnected', null);
      socket.disconnect();
    }
  }
}
