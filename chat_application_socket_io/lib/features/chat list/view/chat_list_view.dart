import 'package:chat_application_socket_io/features/chat%20list/controller/chat_list_controller.dart';
import 'package:chat_application_socket_io/features/chat/view/chat_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatListView extends StatelessWidget {
  final String userId; // Receive user ID as a parameter

  ChatListView({required this.userId}); // Constructor to accept user ID

  @override
  Widget build(BuildContext context) {
    final ChatListController userListController = Get.put(ChatListController());

    return Scaffold(
      appBar: AppBar(title: Text('Users')),
      body: Obx(() {
        if (userListController.isLoading.value) {
          return Center(
              child: CircularProgressIndicator()); // Show loading indicator
        } else if (userListController.errorMessage.value.isNotEmpty) {
          return Center(child: Text(userListController.errorMessage.value));
        } else {
          return ListView.builder(
            itemCount: userListController.users.length,
            itemBuilder: (context, index) {
              if (userListController.users[index]['username'] == userId) {
                return SizedBox.shrink();
              } else {
                return ListTile(
                  title: Text(userListController.users[index]['username']),
                  onTap: () {
                    Get.to(() => ChatScreen(), arguments: {
                      'senderId': userId,
                      'receiverId': userListController.users[index]['_id'],
                    });
                  },
                );
              }
            },
          );
        }
      }),
    );
  }
}
