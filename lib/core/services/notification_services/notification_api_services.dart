import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:waloma/core/config/app_configuration.dart';
import 'package:waloma/core/providers/notification_providers.dart';

class NotificationAPIService {
  static var client = http.Client();
  late IO.Socket socket;
  final NotificationProvider? notificationProvider;

  NotificationAPIService({this.notificationProvider});

  /// Initialize WebSocket connection using Socket.IO
  void initializeSocket(int userId) {
    socket = IO.io(
      'http://${AppConfiguration.apiURL}', // Ensure the URL is correct
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setQuery({'userId': userId.toString()})
          .build(),
    );

    socket.connect();

    // Connection events
    socket.onConnect((_) {
      print('Connected to WebSocket: ${socket.id}');
      socket.emit('user_connected', userId);
    });

    socket.onDisconnect((_) {
      print('Disconnected from WebSocket');
      socket.emit('user_disconnected', userId);
    });

    // Handle receiving notifications
    socket.on('receive_notification', (data) {
      print('Notification received: $data');
      // if (data is List) {
      notificationProvider?.setNotifications(data.cast<Map<String, dynamic>>());
      // } else {
      //   notificationProvider?.addNotification(data);
      // }
    });
  }

  /// Example method for marking a notification as read
  Future<void> markNotificationAsRead(int notificationId) async {
    final url = Uri.http(
        AppConfiguration.apiURL, '/notifications/$notificationId/mark-as-read');
    final response = await client.put(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to mark notification as read');
    }
  }

  /// Example method for marking all notifications as read
  Future<void> markAllNotificationsAsRead(int userId) async {
    final url = Uri.http(
        AppConfiguration.apiURL, '/notifications/$userId/mark-all-as-read');
    final response = await client.put(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to mark all notifications as read');
    }
  }
}
