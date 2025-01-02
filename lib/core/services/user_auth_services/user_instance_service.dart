import 'package:waloma/core/model/user_models/user_regisration_response_model.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  User? _user;

  factory UserService() {
    return _instance;
  }

  UserService._internal();

  void setUser(User user) {
    _user = user;
  }

  User? get user => _user;

  int? get userId => _user?.id;
}
