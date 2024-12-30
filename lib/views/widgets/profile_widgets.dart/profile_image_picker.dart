import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:waloma/core/config/app_configuration.dart';
import 'package:waloma/core/controllers/image_picker_controller.dart';
import 'package:waloma/core/services/user_auth_services/user_api_services.dart';

class ImagePickerWidget extends StatefulWidget {
  final int userId; // Pass userId to identify the user
  const ImagePickerWidget({Key? key, required this.userId}) : super(key: key);

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _imageFile;
  String? _profileImageUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    // Fetch user details to load the current profile image
    final response = await UserAPIService.getUserProfile(widget.userId);
    if (response['success'] && response['user']['profile_details'] != null) {
      setState(() {
        _profileImageUrl = response['user']['profile_details']['profile_image'];
      });
    }
  }

  Future<void> _pickAndUploadImage() async {
    try {
      // Pick image from gallery
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });

        // Upload image to the server
        final uploadResponse = await UserAPIService.updateProfileImage(
          widget.userId,
          _imageFile!,
        );

        if (uploadResponse['success']) {
          setState(() {
            _profileImageUrl =
                uploadResponse['user']['profile_details']['profile_image'];
          });
        } else {
          _showError(uploadResponse['message'] ?? 'Failed to upload image');
        }
      }
    } catch (e) {
      print("Error picking or uploading image: $e");
      _showError("An error occurred. Please try again.");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _normalizeImageUrl(String imagePath) {
    if (imagePath.startsWith('http')) {
      return imagePath;
    }
    // Remove leading slash and construct the full URL
    imagePath = imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;
    return 'http://${AppConfiguration.apiURL}/$imagePath';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.white,
            image: DecorationImage(
              image: _profileImageUrl != null
                  ? NetworkImage(
                      _normalizeImageUrl(_profileImageUrl!)) // Load from server
                  : _imageFile != null
                      ? FileImage(_imageFile!)
                      : const AssetImage('assets/images/user-icon.png')
                          as ImageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _pickAndUploadImage,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                'assets/icons/Pencil.svg',
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
