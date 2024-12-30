import 'package:flutter/foundation.dart';
import 'package:waloma/core/model/user_models/user_regisration_response_model.dart';

class UserProvider with ChangeNotifier {
  UserRegistrationResponseModel? _userRegistrationResponse;

  // Getter for the user
  User? get user => _userRegistrationResponse?.user;

  // Method to set user data after registration or login
  void setUser(UserRegistrationResponseModel userRegistrationResponse) {
    _userRegistrationResponse = userRegistrationResponse;
    notifyListeners();
  }

  // Method to clear user data (e.g., on logout)
  void clearUser() {
    _userRegistrationResponse = null;
    notifyListeners();
  }
}
