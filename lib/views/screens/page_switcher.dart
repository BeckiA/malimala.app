import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waloma/constant/app_color.dart';
import 'package:waloma/core/services/user_auth_services/user_shared_services.dart';
import 'package:waloma/views/screens/home/broker_homepage_screen.dart';
import 'package:waloma/views/screens/home_page.dart';
import 'package:waloma/views/screens/show_specialized_screen/not_signed_in_notification.dart';
import 'show_specialized_screen/not_signed_in_post_listing.dart';
import 'show_specialized_screen/not_signed_in_profile.dart';

class PageSwitcher extends StatefulWidget {
  @override
  _PageSwitcherState createState() => _PageSwitcherState();
}

class _PageSwitcherState extends State<PageSwitcher> {
  int _selectedIndex = 0;
  String? userType = '';

  @override
  void initState() {
    super.initState();
    func();
  }

  void func() async {
    final loginDetails = await SharedService.loginDetails();
    if (loginDetails != null) {
      setState(() {
        userType = loginDetails.user!.userType;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        userType == 'broker' ? BrokerHomePage() : HomePage(),
        // HomePage(),
        CanPostListing(),
        CanBrowseNotification(),
        IsSignedIn(),
      ][_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            border:
                Border(top: BorderSide(color: AppColor.primarySoft, width: 2))),
        child: BottomNavigationBar(
          onTap: _onItemTapped,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            (_selectedIndex == 0)
                ? BottomNavigationBarItem(
                    icon: SvgPicture.asset('assets/icons/Home-active.svg'),
                    label: '')
                : BottomNavigationBarItem(
                    icon: SvgPicture.asset('assets/icons/Home.svg'), label: ''),
            (_selectedIndex == 1)
                ? BottomNavigationBarItem(
                    icon: SvgPicture.asset('assets/icons/Plus-active.svg'),
                    label: '')
                : BottomNavigationBarItem(
                    icon: SvgPicture.asset('assets/icons/Plus.svg'), label: ''),
            (_selectedIndex == 2)
                ? BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                        'assets/icons/Notification-active.svg'),
                    label: '')
                : BottomNavigationBarItem(
                    icon: SvgPicture.asset('assets/icons/Notification.svg'),
                    label: ''),
            (_selectedIndex == 3)
                ? BottomNavigationBarItem(
                    icon: SvgPicture.asset('assets/icons/Profile-active.svg'),
                    label: '')
                : BottomNavigationBarItem(
                    icon: SvgPicture.asset('assets/icons/Profile.svg'),
                    label: ''),
          ],
        ),
      ),
    );
  }
}
