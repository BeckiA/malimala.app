class UserNotification {
  final String id;
  final String userId;
  final String senderId;
  final String type;
  final Map<String, dynamic> data;
  final bool isRead;
  final DateTime createdAt;

  UserNotification({
    required this.id,
    required this.userId,
    required this.senderId,
    required this.type,
    required this.data,
    required this.isRead,
    required this.createdAt,
  });

  // Factory method to create an instance from JSON
  factory UserNotification.fromJson(Map<String, dynamic> json) {
    return UserNotification(
      id: json['id'] as String,
      userId: json['userId'] as String,
      senderId: json['senderId'] as String,
      type: json['type'] as String,
      data: json['data'] as Map<String, dynamic>,
      isRead: json['isRead'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  // Method to convert the instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'senderId': senderId,
      'type': type,
      'data': data,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
