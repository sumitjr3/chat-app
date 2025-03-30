import 'package:chat_application_socket_io/features/chat%20list/view/chat_list_view.dart';
import 'package:chat_application_socket_io/features/chat/controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.put(ChatController());
    final TextEditingController messageController = TextEditingController();

    return WillPopScope(
      onWillPop: () async {
        if (chatController.chatService.isConnected) {
          chatController.chatService.leaveRoomAndDisconnect();
        }

        // Get.off(ChatListView(userId: Get.arguments['senderId']));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chat'),
          leading: IconButton(
            onPressed: () {
              if (chatController.chatService.isConnected) {
                chatController.chatService.leaveRoomAndDisconnect();
              }

              // Get.off(ChatListView(userId: Get.arguments['senderId']));
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (chatController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else if (chatController.errorMessage.value.isNotEmpty) {
                  return Center(child: Text(chatController.errorMessage.value));
                } else if (chatController.messages.isEmpty) {
                  return Center(child: Text('No messages yet.'));
                } else {
                  return ListView.builder(
                    itemCount: chatController.messages.length,
                    itemBuilder: (context, index) {
                      final msg = chatController.messages[index];
                      bool isMe = msg['sender'] == Get.arguments['senderId'];
                      return ListTile(
                        title: Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.blue[100] : Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${msg['content']}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(labelText: 'Type a message'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      chatController.sendMessage(messageController.text);
                      messageController.clear();
                      FocusScope.of(context)
                          .requestFocus(FocusNode()); // Close keyboard
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
