class ChatUser {
  final int id;
  final String firstName;
  final String lastName;
  final String? email;
  final String? username;
  final String? lastMessage;
  final DateTime? lastMessageTimestamp;
  final Map<String, dynamic>? profileDetails;
  bool isRead;
  final String status;

  ChatUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    this.username,
    this.lastMessage,
    this.lastMessageTimestamp,
    this.profileDetails,
    this.isRead = false,
    required this.status,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: int.parse(json['id'].toString()),
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String?,
      username: json['username'] as String?,
      lastMessage: json['last_message'] as String?,
      lastMessageTimestamp: json['last_message_timestamp'] != null
          ? DateTime.tryParse(json['last_message_timestamp'])
          : null,
      profileDetails:
          json['profile_details'] == null || json['profile_details'] is String
              ? null
              : Map<String, dynamic>.from(json['profile_details']),
      isRead: json['last_message_isRead'] == true ||
          json['last_message_isRead'] == 1,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'username': username,
      'last_message': lastMessage,
      'last_message_timestamp': lastMessageTimestamp?.toIso8601String(),
      'profile_details': profileDetails,
      'last_message_isRead': isRead,
      'status': status,
    };
  }
}
