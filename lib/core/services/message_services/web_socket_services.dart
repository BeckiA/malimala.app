// import 'dart:convert';
// import 'package:waloma/core/config/app_configuration.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:web_socket_channel/status.dart' as status;

// class WebSocketService {
//   static WebSocketChannel? _channel;
//   static Function(Map<String, dynamic>)? _onMessageCallback;

//   /// Connect to the WebSocket server
//   static void connect(int userId) {
//     try {
//       // Replace this URL with your WebSocket server's URL
//       final url = 'ws://192.168.0.101:3030/ws?userId=$userId';
//       // final url = 'ws://${AppConfiguration.apiURL}';
//       _channel = WebSocketChannel.connect(Uri.parse(url));

//       print('WebSocket connected for userId: $userId');

//       // Listen for messages from the server
//       _channel!.stream.listen(
//         (event) {
//           final data = jsonDecode(event);
//           print('Message received: $data');

//           // Notify the application if a message callback is set
//           if (_onMessageCallback != null) {
//             _onMessageCallback!(data);
//           }
//         },
//         onDone: () {
//           print('WebSocket connection closed.');
//         },
//         onError: (error) {
//           print('WebSocket error: $error');
//         },
//       );
//     } catch (error) {
//       print('Error connecting to WebSocket: $error');
//     }
//   }

//   /// Disconnect the WebSocket connection
//   static void disconnect() {
//     try {
//       if (_channel != null) {
//         _channel!.sink.close(status.normalClosure);
//         _channel = null;
//         print('WebSocket disconnected');
//       }
//     } catch (error) {
//       print('Error disconnecting WebSocket: $error');
//     }
//   }

//   /// Send a message via WebSocket
//   static void sendMessage(Map<String, dynamic> messageData) {
//     try {
//       if (_channel != null) {
//         final message = jsonEncode(messageData);
//         _channel!.sink.add(message);
//         print('Message sent: $message');
//       } else {
//         print('WebSocket is not connected. Unable to send message.');
//       }
//     } catch (error) {
//       print('Error sending message: $error');
//     }
//   }

//   /// Set a callback to handle incoming messages
//   static void onMessageReceived(Function(Map<String, dynamic>) callback) {
//     _onMessageCallback = callback;
//   }
// }
