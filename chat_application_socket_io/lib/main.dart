import 'package:chat_application_socket_io/features/chat%20list/view/chat_list_view.dart';
import 'package:chat_application_socket_io/features/chat/view/chat_view.dart';
import 'package:chat_application_socket_io/features/login/view/login_view.dart';
import 'package:chat_application_socket_io/features/splash/view/splash_view.dart';
import 'package:chat_application_socket_io/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".envApp");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Chat Application',
      getPages: AppPages.routes,
      home: const SplashView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
