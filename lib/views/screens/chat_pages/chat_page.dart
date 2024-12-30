// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:waloma/core/providers/chat_providers.dart';
// import 'package:waloma/core/services/user_auth_services/user_shared_services.dart';
// import 'package:waloma/views/screens/chat_pages/chat_detail_page.dart';

// class ChatPage extends StatefulWidget {
//   @override
//   _ChatPageState createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   int? _userId;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   Future<void> _loadUserData() async {
//     final response = await SharedService.loginDetails();

//     if (response?.success == true) {
//       final userId = response?.user?.id;
//       if (userId != null) {
//         setState(() {
//           _userId = userId;
//         });

//         // Initialize ChatProvider with the user ID and auth token
//         Future.delayed(Duration.zero, () {
//           final chatProvider =
//               Provider.of<ChatProvider>(context, listen: false);
//           // chatProvider.initialize(userId, response!.authToken!);
//         });
//       }
//     } else {
//       print("Unable to load user data");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final chatProvider = Provider.of<ChatProvider>(context);

//     if (_userId == null || chatProvider.isLoading) {
//       return Scaffold(
//         appBar: AppBar(title: Text('Chats')),
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(title: Text('Chats')),
//       body: ListView.builder(
//         itemCount: chatProvider.chatUsers.length,
//         itemBuilder: (context, index) {
//           final user = chatProvider.chatUsers[index];
//           return ListTile(
//             leading: CircleAvatar(
//               backgroundImage: NetworkImage(user.avatar),
//             ),
//             title: Text(user.firstName),
//             subtitle: Text(user.status),
//             onTap: () {
//               // Navigate to ChatDetailPage with only user IDs
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => ChatDetailPage(
//                     currentUserId: _userId!,
//                     chatUserId: user.id,
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
