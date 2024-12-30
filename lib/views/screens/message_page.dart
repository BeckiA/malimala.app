import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:waloma/constant/app_color.dart';
import 'package:waloma/core/model/Message.dart';
import 'package:waloma/core/providers/message_providers.dart';
import 'package:waloma/core/services/message_services/message_services.dart';
import 'package:waloma/core/services/user_auth_services/user_shared_services.dart';
import 'package:waloma/helpers/profile_image_initals.dart';
import 'package:waloma/main.dart';
import 'package:waloma/views/screens/message_detail_page.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  late MessageProvider _messageProvider;
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
    _initializeChat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get the provider reference once and store it
    _messageProvider = Provider.of<MessageProvider>(context, listen: false);
  }

  @override
  void dispose() {
    // Safely perform any cleanup operations
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Consumer<MessageProvider>(
        builder: (context, messageProvider, _) {
          print("Inside Scaffold: ${messageProvider.chatUsers.length}");
          if (messageProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (messageProvider.chatUsers.isEmpty) {
            return _buildEmptyMessageView();
          }

          return _buildUserList(messageProvider);
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        'Messages',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: IconButton(
        onPressed: () {
          messageProvider.disconnectSocket();
          Navigator.of(context).pop();
        },
        icon: SvgPicture.asset('assets/icons/Arrow-left.svg'),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: AppColor.primarySoft,
        ),
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }

  Widget _buildEmptyMessageView() {
    return Center(
      child: Text(
        "No messages yet.",
        style: TextStyle(
          color: AppColor.secondary.withOpacity(0.7),
        ),
      ),
    );
  }

  Widget _buildUserList(MessageProvider messageProvider) {
    print('Building user list with ${messageProvider.chatUsers.length} users');
    return ListView.builder(
      itemCount: messageProvider.chatUsers.length,
      itemBuilder: (context, index) {
        final latestMessage = messageProvider.chatUsers[index].lastMessage;
        final user = messageProvider.chatUsers[index];
        final avatarUrl = user.profileDetails?['profile_image'];
        final isOnline = user.status == "online";

        return GestureDetector(
          onTap: () {
            _messageProvider.markReader(user.id, _currentUserId);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MessageDetailPage(
                      chatUser: user,
                      initialData: Message(
                          receiverId: user.id,
                          senderId: _currentUserId,
                          content: "",
                          // isRead: false,
                          timestamp: DateTime.now())),
                ));
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: AppColor.primarySoft, width: 1),
              ),
            ),
            child: Row(
              children: [
                // Avatar or Initials Placeholder
                Container(
                  width: 46,
                  height: 46,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: avatarUrl == null || avatarUrl.isEmpty
                        ? ProfileInitals.getBackgroundColorForInitials(
                            user.firstName, user.lastName)
                        : null,
                    image: avatarUrl != null && avatarUrl.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(avatarUrl),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: Stack(
                    children: [
                      if (avatarUrl == null || avatarUrl.isEmpty)
                        Center(
                          child: Text(
                            ProfileInitals.getInitials(
                                user.firstName, user.lastName),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      Positioned(
                        bottom: -2.5,
                        right: -2.5,
                        child: Container(
                          width: 12.5,
                          height: 12.5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isOnline ? Colors.green : Colors.grey,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // User Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Full Name
                      Text(
                        '${user.firstName} ${user.lastName}',
                        style: const TextStyle(
                          color: AppColor.secondary,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),

                      Text(latestMessage.toString()),
                    ],
                  ),
                ),

                // Arrow Icon
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColor.border,
                  size: 14,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
