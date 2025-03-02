class Message {
  final String id;
  final String sender;
  final String receiver;
  final String content;
  final String roomID;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.content,
    required this.roomID,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? '',
      sender: json['sender'] ?? '',
      receiver: json['receiver'] ?? '',
      content: json['content'] ?? '',
      roomID: json['roomID'] ?? '',
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender,
      'receiver': receiver,
      'content': content,
      'roomID': roomID,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
