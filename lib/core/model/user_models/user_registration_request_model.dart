class UserRegistrationRequestModel {
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? username;
  String? userType;
  String? password;
  Map<String, dynamic>? profileDetails;

  UserRegistrationRequestModel(
      {this.firstName,
      this.lastName,
      this.email,
      this.phoneNumber,
      this.username,
      this.userType,
      this.profileDetails,
      this.password});

  UserRegistrationRequestModel.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    username = json['username'];
    userType = json['user_type'];
    password = json['password'];
    profileDetails =
        json['profile_details'] == null || json['profile_details'] is String
            ? null
            : Map<String, dynamic>.from(json['profile_details']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['username'] = this.username;
    data['user_type'] = this.userType;
    data['password'] = this.password;
    data['profile_details'] = this.profileDetails;
    return data;
  }
}
