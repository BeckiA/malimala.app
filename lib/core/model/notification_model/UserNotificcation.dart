class UserNotification {
  final int id;
  final String title;
  final String body;
  bool isRead;

  UserNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
  });

  factory UserNotification.fromJson(Map<String, dynamic> json) {
    return UserNotification(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      isRead: json['isRead'],
    );
  }
}
