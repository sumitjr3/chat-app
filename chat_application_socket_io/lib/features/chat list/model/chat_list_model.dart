class ChatListModel {
  String? id;
  String? name;
  String? gender;
  String? email;
  String? lastMessage;
  String? lastMessageTime;

  ChatListModel({
    this.id,
    this.name,
    this.gender,
    this.email,
    this.lastMessage,
    this.lastMessageTime,
  });

  factory ChatListModel.fromJson(Map<String, dynamic> json) {
    return ChatListModel(
      id: json['otherPerson']['_id'],
      name: json['otherPerson']['username'],
      email: json['otherPerson']['email'],
      gender: json['otherPerson']['gemder'],
      lastMessage: json['last_message'],
      lastMessageTime: json['last_updated'],
    );
  }
}
