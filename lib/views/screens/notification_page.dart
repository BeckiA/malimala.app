import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:waloma/constant/app_color.dart';
import 'package:waloma/core/providers/notification_providers.dart';
import 'package:waloma/core/services/notification_services/notification_api_services.dart';
import 'package:waloma/core/services/user_auth_services/user_shared_services.dart';
import 'package:waloma/views/widgets/main_app_bar_widget.dart';
import 'package:waloma/views/widgets/menu_tile_widget.dart';
import 'package:waloma/views/widgets/notification_tile.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late final int _currentUserId;
  Future<void> _initializeChat() async {
    try {
      final response = await SharedService.loginDetails();

      if (response?.success == true) {
        final userId = response?.user?.id;
        _currentUserId = int.parse(userId.toString());
        if (userId != null) {
          print('Initializing chat...');
          final notificationProvider =
              Provider.of<NotificationProvider>(context, listen: false);
          NotificationAPIService notificationAPIService =
              NotificationAPIService(
                  notificationProvider: notificationProvider);
          notificationAPIService.initializeSocket(userId);
          print('Socket initialized for userId: $userId');
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
    print('Initializing notifications...');
    _initializeChat().then((_) {
      print('Notification initialization complete');
    }).catchError((error) {
      print('Chat initialization failed: $error');
    });
  }

  @override
  void dispose() {
    // Safely perform any cleanup operations\
    _initializeChat();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        cartValue: 2, // Replace with actual cart value
        chatValue: 2, // Replace with actual chat value
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, notificationProvider, child) {
          final notifications = notificationProvider.notifications;
          final unreadCount = notificationProvider.unreadCount;

          return ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              // Section 1 - Menu
              MenuTileWidget(
                onTap: () {},
                icon: SvgPicture.asset(
                  'assets/icons/Discount.svg',
                  color: AppColor.secondary.withOpacity(0.5),
                ),
                title: 'Product Promo',
                margin: const EdgeInsets.all(0),
              ),
              MenuTileWidget(
                onTap: () {},
                icon: SvgPicture.asset(
                  'assets/icons/Info-Square.svg',
                  color: AppColor.secondary.withOpacity(0.5),
                ),
                title: 'waloma Info',
                margin: const EdgeInsets.all(0),
              ),

              // Section 2 - Status (List)
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 16, bottom: 8),
                      child: Text(
                        'ORDERS STATUS',
                        style: TextStyle(
                          color: AppColor.secondary.withOpacity(0.5),
                          letterSpacing: 6 / 100,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    notifications.isNotEmpty
                        ? ListView.builder(
                            itemBuilder: (context, index) {
                              final notification = notifications[index];
                              return NotificationTile(
                                data: notification,
                                onTap: () {
                                  // Mark notification as read
                                  // notificationProvider
                                  //     .markAsRead(notification.id);
                                },
                              );
                            },
                            itemCount: notifications.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                          )
                        : Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'No Notifications Available',
                                style: TextStyle(
                                  color: AppColor.secondary.withOpacity(0.7),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
