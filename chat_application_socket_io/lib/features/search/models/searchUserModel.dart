class Searchusermodel {
  final String username;
  final String userId;
  final String email;
  final String gender;
  final String avatar;

  Searchusermodel(
      {required this.username,
      required this.userId,
      required this.email,
      required this.gender,
      required this.avatar});

  factory Searchusermodel.fromJson(Map<String, dynamic> json) {
    return Searchusermodel(
      userId: json['_id'],
      username: json['username'],
      email: json['email'],
      gender: json['gender'],
      avatar: json['avatar'],
    );
  }
}
