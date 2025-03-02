import 'package:chat_application_socket_io/features/chat/model/message_model.dart';
import 'package:chat_application_socket_io/features/chat/widgets/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/chat_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatScreen extends StatelessWidget {
  final ChatController controller = Get.put(ChatController());
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String getSvgPath(String name) {
    if (name.isNotEmpty) {
      String initial = name[0].toLowerCase();
      return 'assets/avtar/$initial.svg';
    }
    return 'assets/avtar/1.jpg';
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Pass the scroll controller to the controller
    controller.scrollController = _scrollController;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xfff8f8f8),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight * 0.08),
          child: AppBar(
            backgroundColor: Colors.white,
            shadowColor: Colors.grey,
            surfaceTintColor: Colors.grey,
            elevation: 0.4,
            leading: IconButton(
              onPressed: () {
                controller.onClose();
              },
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                size: screenHeight * 0.03,
                color: Colors.black,
              ),
            ),
            title: Row(
              children: [
                ClipOval(
                  child: SvgPicture.asset(
                    height: screenHeight * 0.06,
                    width: screenHeight * 0.06,
                    getSvgPath(controller.receiverName.value),
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.025,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.receiverName.value,
                      style: TextStyle(
                          fontSize: screenHeight * 0.02,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      controller.receiverPhone.value,
                      style: TextStyle(
                          fontSize: screenHeight * 0.016,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Call'),
                        content: Text("call " + controller.receiverPhone.value),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('No'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          TextButton(
                            child: const Text('Yes'),
                            onPressed: () {
                              return null;
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(
                  Icons.phone,
                  size: screenHeight * 0.03,
                  color: Colors.black,
                ),
              ),
              PopupMenuButton<int>(
                onSelected: handleClick,
                itemBuilder: (context) => [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text('Refresh'),
                  ),
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Text('Get help'),
                  ),
                ],
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: screenWidth * 0.01,
              ),
            ],
          ),
        ),
        body: Container(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Obx(
                  () {
                    if (controller.isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Expanded(
                        child: Container(
                          color: Color(0xfff8f8f8),
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom: screenHeight * 0.088,
                              left: screenWidth * 0.02,
                              right: screenWidth * 0.02,
                            ),
                            child: ListView.builder(
                              controller: _scrollController,
                              reverse: false,
                              itemCount: controller.messageCount.value,
                              itemBuilder: (context, index) {
                                Message currentMessage =
                                    controller.messages[index];
                                bool isLast = false;
                                if (index ==
                                    controller.messageCount.value - 1) {
                                  isLast = true;
                                }
                                String formattedDate = formatDate(
                                    currentMessage.createdAt.toIso8601String());
                                String formattedTime = formatTime(
                                    currentMessage.createdAt.toIso8601String());

                                // Check if the current message is the first message of the day
                                bool isFirstMessageOfDay = index == 0 ||
                                    formatDate(controller
                                            .messages[index - 1].createdAt
                                            .toIso8601String()) !=
                                        formattedDate;

                                return Column(
                                  children: [
                                    if (isFirstMessageOfDay)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: screenHeight * 0.02),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            formattedDate,
                                            style: TextStyle(
                                              fontSize: screenHeight * 0.018,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    CustomChatBubble(
                                      message: currentMessage.content,
                                      timestamp: formattedTime,
                                      senderId: currentMessage.sender,
                                      myId: controller.myId.value,
                                    ),
                                    isLast
                                        ? SizedBox(
                                            height: screenHeight * 0.01,
                                          )
                                        : SizedBox(
                                            height: 0,
                                          )
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: screenHeight * 0.02),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: screenHeight * 0.065,
                width: screenWidth * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xffffffff),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff3D0187).withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        onChanged: (value) {
                          controller.newMessage.value = value;
                        },
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                            ),
                          ),
                          filled: true,
                          fillColor: Color(0xffffffff),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: screenHeight * 0.015,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: screenHeight * 0.06,
                      width: screenHeight * 0.06,
                      decoration: const BoxDecoration(
                        color: Color(0xffffffff),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15)),
                      ),
                      child: IconButton(
                        onPressed: () {
                          controller.sendMessage();
                          _textController.clear(); // Clear the text field
                        },
                        icon: Icon(
                          Icons.send_rounded,
                          color: const Color.fromARGB(255, 4, 5, 118),
                          size: screenHeight * 0.03,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  void handleClick(int item) {
    switch (item) {
      case 0:
        controller.reconnect();
        break;
      case 1:
        break;
      case 2:
        // Get.to(ChatMessage(otherUserName: username));
        break;
      case 3:
        break;
    }
  }

  String formatTime(String isoDate) {
    DateTime dateTime = DateTime.parse(isoDate);
    String formattedTime =
        "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    return formattedTime;
  }

  String formatDate(String isoDate) {
    DateTime dateTime = DateTime.parse(isoDate);
    String formattedDate =
        "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    return formattedDate;
  }
}
