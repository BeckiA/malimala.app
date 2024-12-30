class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String profileDetails;
  final bool isVerified;
  final String avatar;
  final String status;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profileDetails,
    required this.isVerified,
    required this.avatar,
    required this.status,
  });

  // Factory constructor to create a UserModel object from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      profileDetails: json['profile_details'] as String,
      isVerified: json['is_verified'] as bool,
      avatar: json['avatar'] as String,
      status: json['status'] as String,
    );
  }

  // Convert a UserModel object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'profile_details': profileDetails,
      'is_verified': isVerified,
      'avatar': avatar,
      'status': status,
    };
  }
}
