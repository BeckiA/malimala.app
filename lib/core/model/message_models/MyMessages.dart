class MessageModel {
  final int senderId;
  final int receiverId;
  final String text;
  final DateTime timestamp;

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
  });

  // Factory constructor to create a MessageModel object from JSON
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      senderId: json['senderId'] as int,
      receiverId: json['receiverId'] as int,
      text: json['text'] as String,
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  // Convert a MessageModel object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
