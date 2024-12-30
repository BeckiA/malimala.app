import 'package:flutter/material.dart';
import 'package:waloma/views/screens/profile_pages/profile_header_page.dart';
import 'package:waloma/views/widgets/main_app_bar_widget.dart';
import 'package:waloma/views/widgets/users_widet/user_edit_form.dart';

class EditUserProfile extends StatefulWidget {
  const EditUserProfile({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EditUserProfileState createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
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
        children: const [
          // Section 1 - Profile Picture - Username - Name
          ProfileHeader(),
          SizedBox(
            height: 15,
          ),
          // Section 2 - Account Menu
          EditUserProfileForm()
        ],
      ),
    );
  }
}
