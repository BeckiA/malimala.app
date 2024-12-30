import 'package:flutter/material.dart';
import 'package:waloma/core/model/user_models/user_login_response_model.dart';
import 'package:waloma/core/services/user_auth_services/user_shared_services.dart';
import 'package:waloma/views/widgets/profile_widgets.dart/profile_image_picker.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  UserLoginResponseModel? user;
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load cached user data when the profile page is initialized
  }

  // Function to load cached user data from SharedService
  Future<void> _loadUserData() async {
    try {
      UserLoginResponseModel? cachedUser = await SharedService.loginDetails();
      setState(() {
        user = cachedUser;
        isLoading = false; // Data loaded, stop loading
      });
    } catch (e) {
      print("Error loading user data: $e");
      setState(() {
        isLoading = false; // Stop loading even if there's an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // Show a loading indicator while fetching data
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    final userData = user?.user;

    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              // Profile Picture
              ImagePickerWidget(userId: int.parse((userData?.id).toString())),
              // Fullname
              Container(
                margin: const EdgeInsets.only(bottom: 4, top: 14),
                child: Text(
                  userData != null
                      ? "${userData.firstName} ${userData.lastName}"
                      : "Unknown User",
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
              ),
              // Username
              Text(
                userData != null ? "@${userData.username}" : "Unknown Username",
                style: TextStyle(
                    color: Colors.white.withOpacity(0.6), fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
