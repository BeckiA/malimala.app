import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class ImagePickerController {
  static const _imageKey = 'profile_image_path';

  // Save image path to SharedPreferences
  Future<void> saveImagePath(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_imageKey, imagePath);
  }

  // Retrieve image path from SharedPreferences
  Future<String?> getImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_imageKey);
  }

  // Load image from local storage
  Future<File?> loadImageFromLocalStorage() async {
    final imagePath = await getImagePath();
    return imagePath != null ? File(imagePath) : null;
  }

  // Pick and save new image
  Future<File?> pickAndSaveImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage == null) {
      print('No image selected.');
      return null;
    }

    final directory = await getApplicationDocumentsDirectory();
    final savedImagePath = path.join(directory.path, 'profile_image.png');

    // Delete any existing image at the saved path
    final existingFile = File(savedImagePath);
    if (await existingFile.exists()) {
      await existingFile.delete();
    }

    // Save the new image and update SharedPreferences
    final savedImage = await File(pickedImage.path).copy(savedImagePath);
    await saveImagePath(savedImage.path);
    return savedImage;
  }
}
