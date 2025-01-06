import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:waloma/constant/app_color.dart';
import 'package:waloma/core/services/user_auth_services/user_shared_services.dart';
import 'package:waloma/views/screens/notification_page.dart';
import 'package:waloma/views/screens/user_not_loggedIn/user_not_logged_page.dart';

class CanBrowseNotification extends StatelessWidget {
  const CanBrowseNotification({Key? key}) : super(key: key);

  Future<bool> _checkLoginStatus() async {
    return await SharedService.isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    const double _kSize = 50;
    return FutureBuilder<bool>(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        // Show a loading indicator while waiting for the Future
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LoadingAnimationWidget.flickr(
              leftDotColor: AppColor.primary,
              rightDotColor: AppColor.accent,
              size: _kSize,
            ),
          );
        }

        // Handle errors in the Future
        if (snapshot.hasError) {
          return const Center(
              child: Text("An error occurred. Please try again."));
        }

        // Check login status and return the appropriate screen
        if (snapshot.hasData && snapshot.data == true) {
          return NotificationPage();
        } else {
          return const UserNotLoggedIn();
        }
      },
    );
  }
}
