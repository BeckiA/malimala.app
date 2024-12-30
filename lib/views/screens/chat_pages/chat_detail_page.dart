// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:waloma/core/model/MyMessages.dart';
// import 'package:waloma/core/model/UserModel.dart';
// import 'package:waloma/core/providers/chat_providers.dart';

// class ChatDetailPage extends StatefulWidget {
//   final int currentUserId;
//   final int chatUserId;

//   const ChatDetailPage({
//     Key? key,
//     required this.currentUserId,
//     required this.chatUserId,
//   }) : super(key: key);

//   @override
//   State<ChatDetailPage> createState() => _ChatDetailPageState();
// }

// class _ChatDetailPageState extends State<ChatDetailPage> {
//   late UserModel currentUser;
//   late UserModel chatUser;

//   final List<MessageModel> _messages = [];
//   final TextEditingController _messageController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration.zero, () {
//       _fetchUsers();
//     });
//   }

//   void _fetchUsers() {
//     final chatProvider = Provider.of<ChatProvider>(context, listen: false);

//     // Get current user and chat user by IDs
//     currentUser = chatProvider.getUserById(widget.currentUserId);
//     chatUser = chatProvider.getUserById(widget.chatUserId);
//   }

//   void _sendMessage() {
//     if (_messageController.text.trim().isEmpty) return;

//     final newMessage = MessageModel(
//       senderId: currentUser.id,
//       receiverId: chatUser.id,
//       text: _messageController.text.trim(),
//       timestamp: DateTime.now(),
//     );

//     setState(() {
//       _messages.add(newMessage);
//     });

//     _messageController.clear();

//     // Emit the message using the chat provider or WebSocket service
//     // Example:
//     // Provider.of<ChatProvider>(context, listen: false).sendMessage(newMessage);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           children: [
//             CircleAvatar(
//               backgroundImage: NetworkImage(chatUser.avatar),
//             ),
//             const SizedBox(width: 10),
//             Text(chatUser.firstName),
//           ],
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               reverse: true,
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final message = _messages[index];
//                 final isCurrentUser = message.senderId == currentUser.id;

//                 return Align(
//                   alignment: isCurrentUser
//                       ? Alignment.centerRight
//                       : Alignment.centerLeft,
//                   child: Container(
//                     margin:
//                         const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color:
//                           isCurrentUser ? Colors.blue[100] : Colors.grey[200],
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Text(
//                       message.text,
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//             decoration: BoxDecoration(
//               border: Border(
//                 top: BorderSide(color: Colors.grey.shade300),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(
//                       hintText: "Type a message...",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(20),
//                         borderSide: BorderSide.none,
//                       ),
//                       filled: true,
//                       fillColor: Colors.grey[200],
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 20, vertical: 10),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 GestureDetector(
//                   onTap: _sendMessage,
//                   child: CircleAvatar(
//                     radius: 25,
//                     backgroundColor: Colors.blue,
//                     child: const Icon(Icons.send, color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
