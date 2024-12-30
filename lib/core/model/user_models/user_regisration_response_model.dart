import 'dart:convert';

UserRegistrationResponseModel registerResponseJson(String str) =>
    UserRegistrationResponseModel.fromJson(json.decode(str));

class UserRegistrationResponseModel {
  bool? success;
  User? user;

  UserRegistrationResponseModel({this.success, this.user});

  UserRegistrationResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? email;
  String? phoneNumber;
  String? firstName;
  String? lastName;
  String? username;
  String? userType;
  String? profileDetails;
  String? updatedAt;
  String? createdAt;

  User(
      {this.id,
      email,
      phoneNumber,
      firstName,
      lastName,
      username,
      userType,
      profileDetails,
      updatedAt,
      createdAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    username = json['username'];
    userType = json['user_type'];
    profileDetails = json['profile_details'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['username'] = username;
    data['user_type'] = userType;
    data['profile_details'] = profileDetails;
    data['updatedAt'] = updatedAt;
    data['createdAt'] = createdAt;
    return data;
  }
}
