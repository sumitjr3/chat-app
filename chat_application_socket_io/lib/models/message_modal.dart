class Message {
  final String sender;
  final String content;
  final String roomID;

  Message({required this.sender, required this.content, required this.roomID});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sender: json['sender'],
      content: json['content'],
      roomID: json['roomID'],
    );
  }
}
