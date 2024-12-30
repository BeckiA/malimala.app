import 'dart:convert';

UserLoginResponseModel loginResponseJson(String str) =>
    UserLoginResponseModel.fromJson(json.decode(str));

class UserLoginResponseModel {
  bool? success;
  User? user;
  String? token;

  UserLoginResponseModel({this.success, this.user, this.token});

  UserLoginResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['token'] = token;
    return data;
  }
}

class User {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? username;
  String? phoneNumber;
  String? userType;
  Map<String, dynamic>? profileDetails;
  String? createdAt;
  String? updatedAt;
  String? authToken;

  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.username,
      this.phoneNumber,
      this.userType,
      this.profileDetails,
      this.createdAt,
      this.updatedAt,
      this.authToken});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    username = json['username'];
    phoneNumber = json['phone_number'];
    userType = json['user_type'];
    profileDetails = json['profile_details'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['username'] = username;
    data['phone_number'] = phoneNumber;
    data['user_type'] = userType;
    data['profile_details'] = profileDetails;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
