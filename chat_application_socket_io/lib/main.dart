import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/user_list_screen.dart';
import 'screens/chat_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/users': (context) => UserListScreen(
              userId: '',
            ),
        '/chat': (context) => ChatScreen(
              senderId: '',
              receiverId: '',
            ),
      },
    );
  }
}
