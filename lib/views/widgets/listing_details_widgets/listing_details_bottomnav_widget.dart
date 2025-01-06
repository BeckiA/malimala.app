import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:waloma/constant/app_color.dart';
import 'package:waloma/core/model/Message.dart';
import 'package:waloma/core/model/listing_models/listing_response_model.dart';
import 'package:waloma/core/providers/message_providers.dart';
import 'package:waloma/core/services/message_services/message_services.dart';
import 'package:waloma/core/services/user_auth_services/user_shared_services.dart';
import 'package:waloma/views/screens/chat_pages/message_detail_page.dart';
import '../modals/show_contact_modal.dart';

class ListingBottomNavWidget extends StatefulWidget {
  final Listings listings;

  ListingBottomNavWidget({
    required this.listings,
    Key? key,
  }) : super(key: key);

  @override
  State<ListingBottomNavWidget> createState() => _ListingBottomNavWidgetState();
}

class _ListingBottomNavWidgetState extends State<ListingBottomNavWidget> {
  late MessageProvider _messageProvider;
  late final int _currentUserId;

  @override
  void dispose() {
    super.dispose();
    // Clean up any resources when the widget is disposed
  }

  Future<void> _initializeChat() async {
    try {
      int userId = widget.listings.userId;
      if (userId != null) {
        print("USER ID: $userId");
        print('Initializing chat...');
        _messageProvider = Provider.of<MessageProvider>(context, listen: false);
        ChatService chatService =
            ChatService(messageProvider: _messageProvider);

        chatService.initializeSocket(userId, authToken: '');
        print('Socket initialized for userId: $userId');

        // _messageProvider.initializeSocket(userId, authToken: '');

        // Wait for a few seconds to ensure users are fetched
        await Future.delayed(Duration(seconds: 2));
        print(
            "User Data: ${Provider.of<MessageProvider>(context, listen: false).userData}");
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

  Future<Message> _initializeMessage(BuildContext context) async {
    // Fetch the current user ID
    final loginDetails = await SharedService.loginDetails();

    if (loginDetails?.success != true || loginDetails?.user == null) {
      // Handle cases where user is not logged in
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please log in to initiate a chat.')),
      );
      throw Exception("User not logged in");
    }

    final currentUserId = loginDetails!.user?.id;

    // Create a new Message object to initiate the chat
    final message = Message(
      chatId: 0,
      senderId: currentUserId!,
      receiverId: widget.listings.userId,
      content: "",
      timestamp: DateTime.now(),
    );

    return message;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColor.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          Consumer<MessageProvider>(
            builder: (context, messageProvider, _) => Container(
              width: 64,
              height: 64,
              margin: const EdgeInsets.only(right: 14),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: AppColor.secondary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: () async {
                  // print(
                  // "NAME OF MY RECEIVER: ${messageProvider.userData.firstName}");
                  try {
                    final message = await _initializeMessage(context);

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MessageDetailPage(
                          chatUser: messageProvider.userData,
                          initialData: message,
                        ),
                      ),
                    );
                  } catch (e) {
                    print("Error initializing message: $e");
                  }
                },
                child: SvgPicture.asset(
                  'assets/icons/Chat.svg',
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 64,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: AppColor.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return ContactBottomSheet();
                    },
                  );
                },
                child: const Text(
                  'Contact Seller',
                  style: TextStyle(
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
