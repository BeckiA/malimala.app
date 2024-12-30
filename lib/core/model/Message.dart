class Message {
  final int? chatId;
  final int senderId;
  final int receiverId;
  final String content;
  final DateTime timestamp;
  final bool isRead;

  Message({
    this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    this.isRead = false,
  });

  // Factory method to convert a map to a Message object
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        senderId: int.parse(json['senderId']),
        receiverId: int.parse(json['receiverId']),
        content: json['text'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        isRead: json['isRead'] as bool);
  }
}
