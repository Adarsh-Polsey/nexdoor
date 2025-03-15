enum MessageStatus { sent, delivered, error }

class Message {
  final String text;
  final bool isUser;
  final MessageStatus status;
  final DateTime timestamp;

  Message({
    required this.text,
    required this.isUser,
    required this.status,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory Message.fromJson(Map<String, dynamic> json, {bool isUser = false}) {
    return Message(
      text: json['text'] ?? '',
      isUser: isUser,
      status: MessageStatus.sent,
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isUser': isUser,
      'status': status.toString(),
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
