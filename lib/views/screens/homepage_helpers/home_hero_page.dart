import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:waloma/core/providers/message_providers.dart';
import 'package:waloma/core/services/message_services/message_services.dart';
import 'package:waloma/core/services/user_auth_services/user_shared_services.dart';
import 'package:waloma/views/screens/empty_cart_page.dart';
import 'package:waloma/views/screens/message_page.dart';
import 'package:waloma/views/screens/search_page.dart';
import 'package:waloma/views/widgets/custom_icon_button_widget.dart';
import 'package:waloma/views/widgets/dummy_search_widget_1.dart';

class HomeHeroDisplayPage extends StatefulWidget {
  final String titleMessage;
  final bool isCreateListing;
  final bool isEditListing;

  const HomeHeroDisplayPage({
    Key? key,
    this.isEditListing = false,
    required this.titleMessage,
    this.isCreateListing = false,
  }) : super(key: key);

  @override
  State<HomeHeroDisplayPage> createState() => _HomeHeroDisplayPageState();
}

class _HomeHeroDisplayPageState extends State<HomeHeroDisplayPage> {
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
        }
      }
    } catch (error) {
      print("Error initializing chat: $error");
    }
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
    // Ensure the unread count stays updated when navigating back to this page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _messageProvider.unreadMessagesCount;
    });
  }

  @override
  void dispose() {
    // Safely perform any cleanup operations
    super.dispose();
  }
  // @override
  // void dispose() {
  //   // Safely perform any cleanup operations
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.isCreateListing ? 80 : 190,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 26),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widget.isEditListing
                    ? CustomIconButtonWidget(
                        onTap: () => Navigator.pop(context),
                        value: 0,
                        icon: SvgPicture.asset(
                          'assets/icons/Arrow-left.svg',
                          color: Colors.white,
                        ),
                        margin: const EdgeInsets.all(0),
                      )
                    : const SizedBox(),
                Text(
                  widget.titleMessage,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    height: 150 / 100,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
                widget.isCreateListing
                    ? const SizedBox()
                    : Row(
                        children: [
                          CustomIconButtonWidget(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EmptyCartPage()));
                            },
                            value: 0,
                            icon: SvgPicture.asset(
                              'assets/icons/Bag.svg',
                              color: Colors.white,
                            ),
                            margin: const EdgeInsets.all(0),
                          ),
                          Consumer<MessageProvider>(
                            builder: (context, messageProvider, _) {
                              return CustomIconButtonWidget(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => MessagePage()));
                                },
                                margin: const EdgeInsets.only(left: 16),
                                value: messageProvider.unreadMessagesCount,
                                icon: SvgPicture.asset(
                                  'assets/icons/Chat.svg',
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
              ],
            ),
          ),
          widget.isCreateListing
              ? const SizedBox()
              : DummySearchWidget1(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SearchPage(),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
