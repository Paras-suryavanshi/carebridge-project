class MessageModel {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;

  MessageModel({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      content: json['content'],
      isUser: json['isUser'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  String get formattedTime {
    final hour = timestamp.hour > 12 ? timestamp.hour - 12 : timestamp.hour;
    final period = timestamp.hour >= 12 ? 'PM' : 'AM';
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
}
