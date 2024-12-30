import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waloma/constant/app_color.dart';
import 'package:waloma/core/services/user_auth_services/user_shared_services.dart';
import 'package:waloma/views/screens/manage_listings/manage_listings_detail_page.dart';
import 'package:waloma/views/screens/password_pages/change_password_page.dart';
import 'package:waloma/views/screens/profile_pages/user_profile_details_page.dart';
import 'package:waloma/views/widgets/main_app_bar_widget.dart';
import 'package:waloma/views/widgets/menu_tile_widget.dart';
import 'profile_pages/edit_user_profile_page.dart';
import 'profile_pages/profile_header_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future _pageNavigator(Widget widget, BuildContext context) {
    return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => widget,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        cartValue: 2,
        chatValue: 2,
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          // Section 1 - Profile Picture - Username - Name
          const ProfileHeader(),
          // Section 2 - Account Menu
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(top: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 16),
                  child: Text(
                    'ACCOUNT',
                    style: TextStyle(
                        color: AppColor.secondary.withOpacity(0.5),
                        letterSpacing: 6 / 100,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                MenuTileWidget(
                  onTap: () => _pageNavigator(
                      UserProfileList(
                        headlineText: 'My Profile',
                        profileName: 'PROFILE',
                        menuTiles: MenuTileWidget(
                          onTap: () =>
                              _pageNavigator(const EditUserProfile(), context),
                          margin: const EdgeInsets.only(top: 10),
                          icon: SvgPicture.asset(
                            'assets/icons/Profile.svg',
                            color: AppColor.secondary.withOpacity(0.5),
                          ),
                          title: 'Manage Profile',
                        ),
                      ),
                      context),
                  margin: const EdgeInsets.only(top: 10),
                  icon: SvgPicture.asset(
                    'assets/icons/Profile.svg',
                    color: AppColor.secondary.withOpacity(0.5),
                  ),
                  title: 'Your Profile',
                ),
                MenuTileWidget(
                  onTap: () => _pageNavigator(
                      UserProfileList(
                        headlineText: 'Manage Passwords',
                        profileName: 'PASSWORD MANAGER',
                        menuTiles: MenuTileWidget(
                          onTap: () =>
                              _pageNavigator(const ChangePassword(), context),
                          margin: const EdgeInsets.only(top: 10),
                          icon: SvgPicture.asset(
                            'assets/icons/Profile.svg',
                            color: AppColor.secondary.withOpacity(0.5),
                          ),
                          title: 'Change Password',
                        ),
                      ),
                      context),
                  icon: SvgPicture.asset(
                    'assets/icons/Lock.svg',
                    color: AppColor.secondary.withOpacity(0.5),
                  ),
                  title: 'Password Manager',
                  margin: const EdgeInsets.all(0),
                ),
                MenuTileWidget(
                  onTap: () {},
                  icon: SvgPicture.asset(
                    'assets/icons/Notification.svg',
                    color: AppColor.secondary.withOpacity(0.5),
                  ),
                  title: 'Notifications',
                  margin: const EdgeInsets.all(0),
                ),
                MenuTileWidget(
                  onTap: () => _pageNavigator(
                      UserProfileList(
                        headlineText: 'Manage Listings',
                        profileName: 'LISTING MANAGER',
                        menuTiles: MenuTileWidget(
                          onTap: () => _pageNavigator(
                              ManageListingsDetailsScreen(), context),
                          margin: const EdgeInsets.only(top: 10),
                          icon: SvgPicture.asset(
                            'assets/icons/Profile.svg',
                            color: AppColor.secondary.withOpacity(0.5),
                          ),
                          title: 'My Listings',
                        ),
                      ),
                      context),
                  icon: SvgPicture.asset(
                    'assets/icons/Bag.svg',
                    color: AppColor.secondary.withOpacity(0.5),
                  ),
                  title: 'My Listings',
                  margin: const EdgeInsets.all(0),
                ),
                MenuTileWidget(
                  onTap: () {},
                  icon: SvgPicture.asset(
                    'assets/icons/Wallet.svg',
                    color: AppColor.secondary.withOpacity(0.5),
                  ),
                  title: 'Wallet',
                  margin: const EdgeInsets.all(0),
                ),
              ],
            ),
          ),

          // Section 3 - Settings
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(top: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 16),
                  child: Text(
                    'SETTINGS',
                    style: TextStyle(
                        color: AppColor.secondary.withOpacity(0.5),
                        letterSpacing: 6 / 100,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                MenuTileWidget(
                  onTap: () {},
                  margin: const EdgeInsets.only(top: 10),
                  icon: SvgPicture.asset(
                    'assets/icons/Filter.svg',
                    color: AppColor.secondary.withOpacity(0.5),
                  ),
                  title: 'Languages',
                ),
                MenuTileWidget(
                  onTap: () => SharedService.logout(context),
                  icon: SvgPicture.asset(
                    'assets/icons/Log Out.svg',
                    color: AppColor.white,
                  ),
                  iconBackground: Colors.redAccent,
                  title: 'Log Out',
                  titleColor: Colors.red,
                  margin: const EdgeInsets.all(0),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
