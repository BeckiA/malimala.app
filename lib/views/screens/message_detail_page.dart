import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waloma/constant/app_color.dart';
import 'package:waloma/core/model/Message.dart';
import 'package:waloma/core/model/message_models/ChatUser.dart';
import 'package:waloma/core/providers/message_providers.dart';
import 'package:waloma/core/services/message_services/message_services.dart';
import 'package:waloma/core/services/user_auth_services/user_shared_services.dart';

import 'package:provider/provider.dart';
import 'package:waloma/helpers/profile_image_initals.dart'; // Assuming you're using Provider for state management

class MessageDetailPage extends StatefulWidget {
  final Message initialData;
  final ChatUser chatUser;

  const MessageDetailPage({
    Key? key,
    required this.initialData,
    required this.chatUser,
  }) : super(key: key);

  @override
  _MessageDetailPageState createState() => _MessageDetailPageState();
}

class _MessageDetailPageState extends State<MessageDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  int? _userId;
  late final int _currentUserId;
  Future<void> _initializeChat() async {
    try {
      final response = await SharedService.loginDetails();

      if (response?.success == true) {
        final userId = response?.user?.id;
        _currentUserId = int.parse(userId.toString());
        if (userId != null) {
          print("USER ID: $userId");
          print('Initializing chat...');
          final messageProvider =
              Provider.of<MessageProvider>(context, listen: false);
          ChatService chatService =
              ChatService(messageProvider: messageProvider);

          chatService.initializeSocket(userId, authToken: '');
          print('Socket initialized for userId: $userId');

          messageProvider.initializeSocket(userId, authToken: '');

          // Wait for a few seconds to ensure users are fetched
          await Future.delayed(Duration(seconds: 2));
          print(
              "Chat users after delay: ${Provider.of<MessageProvider>(context, listen: false).chatUsers}");
        } else {
          _redirectToLogin();
        }
      } else {
        _redirectToLogin();
      }
    } catch (error) {
      print("Error initializing chat: $error");
      _redirectToLogin();
    }
  }

  void _redirectToLogin() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _initializeChat();
  }

  Future<void> _loadUserData() async {
    final response = await SharedService.loginDetails();

    if (response?.success == true) {
      final userId = response?.user?.id;
      if (userId != null) {
        _userId = userId;
        final receiverId = widget.initialData.receiverId == userId
            ? widget.initialData.senderId
            : widget.initialData.receiverId;

        Provider.of<MessageProvider>(context, listen: false)
            .fetchMessages(userId, receiverId);
      }
    } else {
      print("Unable to load user data");
    }
  }

  void _sendMessage() {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty || _userId == null) return;

    final receiverId = widget.initialData.receiverId == _userId
        ? widget.initialData.senderId
        : widget.initialData.receiverId;

    final newMessage = Message(
      senderId: _userId!,
      receiverId: receiverId,
      content: messageText,
      isRead: false,
      timestamp: DateTime.now(),
    );

    Provider.of<MessageProvider>(context, listen: false).addMessage(newMessage);

    _messageController.clear();
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final isSameDay = now.year == timestamp.year &&
        now.month == timestamp.month &&
        now.day == timestamp.day;

    if (isSameDay) {
      // Format time in 12-hour format with AM/PM
      final hour = timestamp.hour > 12 ? timestamp.hour - 12 : timestamp.hour;
      final amPm = timestamp.hour >= 12 ? "PM" : "AM";
      return "${hour == 0 ? 12 : hour}:${timestamp.minute.toString().padLeft(2, '0')} $amPm";
    } else {
      // Return the name of the day (e.g., Monday, Tuesday, etc.)
      return _getDayOfWeek(timestamp.weekday);
    }
  }

  String _getDayOfWeek(int weekday) {
    const daysOfWeek = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];
    return daysOfWeek[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            _buildProfileAvatar(),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.chatUser.firstName} ${widget.chatUser.lastName}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    widget.chatUser.status == 'online' ? "Online" : "Offline",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Provider.of<MessageProvider>(context, listen: false)
                .disconnectSocket();

            return Navigator.of(context).pop();
          },
          icon: SvgPicture.asset('assets/icons/Arrow-left.svg'),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            width: MediaQuery.of(context).size.width,
            color: AppColor.primarySoft,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Consumer<MessageProvider>(
        builder: (context, messageProvider, _) {
          // Ensure messages are sorted by timestamp in ascending order
          final messages = messageProvider.messages
            ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMyMessage = message.senderId == _userId;

                    return isMyMessage
                        ? MyBubbleChatWidget(
                            chat: message.content,
                            time: _formatTimestamp(message.timestamp),
                          )
                        : SenderBubbleChatWidget(
                            chat: message.content,
                            time: _formatTimestamp(message.timestamp),
                          );
                  },
                ),
              ),
              _buildMessageInput(),
              Container(
                height: MediaQuery.of(context).viewInsets.bottom,
                color: Colors.transparent,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileAvatar() {
    final avatar = widget.chatUser.profileDetails?['avatar'];
    final initialsColor = ProfileInitals.getBackgroundColorForInitials(
      widget.chatUser.firstName,
      widget.chatUser.lastName,
    );

    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: avatar == null || avatar.isEmpty ? initialsColor : null,
        image: avatar != null && avatar.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(avatar),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: avatar == null || avatar.isEmpty
          ? Center(
              child: Text(
                ProfileInitals.getInitials(
                  widget.chatUser.firstName,
                  widget.chatUser.lastName,
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildMessageInput() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColor.border, width: 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              maxLines: null,
              controller: _messageController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon:
                      Icon(Icons.camera_alt_outlined, color: AppColor.primary),
                ),
                hintText: 'Type a message here...',
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 14,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.border, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.border, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 42,
            height: 42,
            child: ElevatedButton(
              onPressed: _sendMessage,
              child:
                  const Icon(Icons.send_rounded, color: Colors.white, size: 18),
              style: ElevatedButton.styleFrom(
                onPrimary: AppColor.primary,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyBubbleChatWidget extends StatelessWidget {
  final String chat;
  final String time;

  MyBubbleChatWidget({
    required this.chat,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '$time',
            style: TextStyle(color: AppColor.secondary.withOpacity(0.5)),
          ),
          Container(
            margin: EdgeInsets.only(left: 16),
            width: MediaQuery.of(context).size.width * 65 / 100,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              '$chat',
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.white, height: 150 / 100),
            ),
            decoration: BoxDecoration(
              color: AppColor.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                topLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SenderBubbleChatWidget extends StatelessWidget {
  final String chat;
  final String time;

  SenderBubbleChatWidget({
    required this.chat,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(right: 16),
            width: MediaQuery.of(context).size.width * 65 / 100,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              '$chat',
              textAlign: TextAlign.left,
              style: TextStyle(color: AppColor.secondary, height: 150 / 100),
            ),
            decoration: BoxDecoration(
              color: AppColor.primarySoft,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
          ),
          Text(
            '$time',
            style: TextStyle(color: AppColor.secondary.withOpacity(0.5)),
          ),
        ],
      ),
    );
  }
}
