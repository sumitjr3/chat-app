import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../screens/chat_screen.dart';

class UserListScreen extends StatefulWidget {
  final String userId; // Receive user ID as a parameter

  UserListScreen({required this.userId}); // Constructor to accept user ID

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<dynamic> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  fetchUsers() async {
    var fetchedUsers = await AuthService.fetchUsers();
    setState(() {
      users = fetchedUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users')),
      body: users.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(users[index]['username']),
                  onTap: () {
                    // print(widget.userId.compareTo(users[index]['_id']) < 0
                    //     ? '${widget.userId}-${users[index]['_id']}'
                    //     : '${users[index]['_id']}-${widget.userId}');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          receiverId: users[index]['_id'],
                          senderId: widget.userId, // Pass sender ID
                          // roomId:
                          //     widget.userId.compareTo(users[index]['_id']) < 0
                          //         ? '${widget.userId}-${users[index]['_id']}'
                          //         : '${users[index]['_id']}-${widget.userId}',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
