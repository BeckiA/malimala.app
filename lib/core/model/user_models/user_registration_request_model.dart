class UserRegistrationRequestModel {
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? username;
  String? userType;
  String? password;
  Map<String, dynamic>? profileDetails;
  List<String>? documents; // New property for file URLs

  UserRegistrationRequestModel({
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.username,
    this.userType,
    this.password,
    this.profileDetails,
    this.documents,
  });

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
    documents = json['documents']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['username'] = username;
    data['user_type'] = userType;
    data['password'] = password;
    data['profile_details'] = profileDetails;
    data['documents'] = documents;
    return data;
  }
}
