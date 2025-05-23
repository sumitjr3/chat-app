import 'package:chat_application_socket_io/cores/app_colors.dart';
import 'package:chat_application_socket_io/features/chat%20list/controller/chat_list_controller.dart';
import 'package:chat_application_socket_io/features/chat/controller/chat_controller.dart';
import 'package:chat_application_socket_io/features/chat/controller/update_chat_list_controller.dart';
import 'package:chat_application_socket_io/features/chat/models/message_model.dart';
import 'package:chat_application_socket_io/features/chat/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatelessWidget {
  final ChatController controller = Get.put(ChatController());
  final UpdateChatListController updateChatListController =
      Get.put(UpdateChatListController());
  final TextEditingController _textController = TextEditingController();

  ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        // Properly cleanup both controllers
        // await controller.leaveRoomAndDisconnect();
        updateChatListController.onClose();
        controller.onClose();
        // Get.find<ChatListController>().onInit();
        Get.back();
        return true;
      },
      child: Container(
        height: screenHeight * 0.9,
        width: screenWidth,
        decoration: const BoxDecoration(
          // Lightweight gradient background
          gradient: LinearGradient(
            colors: [AppColors.background, AppColors.surfaceColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(screenHeight * 0.08),
            child: GestureDetector(
              onTap: () {
                // Get.toNamed('/otherprofile');
              },
              child: Obx(
                () {
                  return AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: AppColors.background,
                    foregroundColor: AppColors.background,
                    shadowColor: AppColors.textTernary,
                    surfaceTintColor: AppColors.background,
                    elevation: 4.0, // Increased AppBar elevation
                    centerTitle: false,
                    titleSpacing: screenWidth * 0.00,
                    leadingWidth: screenWidth * 0.13,
                    leading: MaterialButton(
                      splashColor: Colors.grey.shade200,
                      highlightColor: Colors.grey.shade200,
                      height: 2,
                      minWidth: 2,
                      shape: const CircleBorder(),
                      onPressed: () async {
                        updateChatListController.onClose();
                        controller.onClose();
                        // Get.find<ChatListController>().onInit();
                        Get.back();
                      },
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        size: screenHeight * 0.03,
                        color: AppColors.backgroundDark,
                      ),
                    ),
                    title: Row(
                      children: [
                        Stack(children: [
                          ClipOval(
                            child: SvgPicture.asset(
                              height: screenHeight * 0.06,
                              width: screenHeight * 0.06,
                              controller.receiverAvatar.value,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: screenHeight * 0.043,
                              left: screenWidth * 0.09,
                            ),
                            child: Obx(() {
                              return Container(
                                height: screenHeight * 0.015,
                                width: screenWidth * 0.055,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.background,
                                    width: screenWidth * 0.005,
                                  ),
                                  color: controller.isOnline.value
                                      ? Colors.green
                                      : AppColors.textTernary,
                                ),
                              );
                            }),
                          ),
                        ]),
                        SizedBox(width: screenWidth * 0.014),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.receiverName.value,
                              style: TextStyle(
                                fontSize: screenHeight * 0.02,
                                fontFamily: 'Poppins',
                                color: AppColors.backgroundDark,
                                fontWeight: FontWeight.w400,
                              ),
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
                                backgroundColor: AppColors.background,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.017,
                                    horizontal: screenWidth * 0.07),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Rounded corners
                                ),
                                buttonPadding:
                                    EdgeInsets.all(screenHeight * 0.01),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Mail',
                                      style: TextStyle(
                                        fontSize: screenHeight * 0.02,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins',
                                      ),
                                      textAlign: TextAlign.center,
                                    ),

                                    Text(
                                      "Do you want to mail? ${controller.receiverEmail.value}",
                                      style: TextStyle(
                                          fontSize: screenHeight * 0.018,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Poppins',
                                          color: AppColors.textTernary),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: screenHeight * 0.03,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor:
                                                AppColors.background,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: screenWidth * 0.1,
                                                vertical: screenHeight * 0.007),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              side: const BorderSide(
                                                  color: AppColors.orange),
                                            ),
                                          ),
                                          child: Text(
                                            'No',
                                            style: TextStyle(
                                                fontSize: screenHeight * 0.018,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Poppins',
                                                color: AppColors.orange),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: AppColors.orange,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: screenWidth * 0.1,
                                                vertical: screenHeight * 0.007),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              side: const BorderSide(
                                                  color: AppColors.orange),
                                            ),
                                          ),
                                          child: Text(
                                            'Yes',
                                            style: TextStyle(
                                                fontSize: screenHeight * 0.018,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Poppins',
                                                color: AppColors.background),
                                          ),
                                          onPressed: () async {},
                                        ),
                                      ],
                                    ),
                                    // SizedBox(
                                    //   height: height * 0.01,
                                    // ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.mail_outline_rounded,
                          color: AppColors.backgroundDark,
                        ),
                      ),
                      PopupMenuButton<int>(
                        onSelected: handleClick,
                        itemBuilder: (context) => [
                          const PopupMenuItem<int>(
                            value: 0,
                            child: Text(
                              'Refresh',
                              style: TextStyle(fontFamily: 'Poppins'),
                            ),
                          ),
                        ],
                        icon: const Icon(
                          Icons.more_vert,
                          color: AppColors.backgroundDark,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.01),
                    ],
                  );
                },
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Obx(
                  () {
                    if (controller.isLoading.value) {
                      return const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.orange,
                          ),
                        ),
                      );
                    } else if (controller.messages.isEmpty) {
                      return Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline_rounded,
                                size: screenHeight * 0.1,
                                color: AppColors.orange.withOpacity(0.5),
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              Text(
                                'Start Chatting',
                                style: TextStyle(
                                  fontSize: screenHeight * 0.025,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.orange,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Text(
                                'Send your first message',
                                style: TextStyle(
                                  fontSize: screenHeight * 0.015,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textTernary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Expanded(
                        child: Container(
                          color: Colors.transparent,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.02,
                            ),
                            child: ListView.builder(
                              controller: controller.scrollController,
                              itemCount: controller.messageCount.value,
                              itemBuilder: (context, index) {
                                Message currentMessage =
                                    controller.messages[index];
                                bool isLast =
                                    index == controller.messageCount.value - 1;
                                String formattedDate = formatDate(
                                    currentMessage.createdAt.toIso8601String());
                                String formattedTime = formatTime(
                                    currentMessage.createdAt.toIso8601String());

                                bool isFirstMessageOfDay = index == 0 ||
                                    (index > 0 &&
                                        formatDate(controller
                                                    .messages[index - 1]
                                                    .createdAt
                                                    .toIso8601String())
                                                .split(',')[0] !=
                                            formattedDate.split(',')[0]);

                                return Column(
                                  children: [
                                    if (isFirstMessageOfDay)
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: screenHeight * 0.02,
                                          bottom: screenHeight * 0.02,
                                        ),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            formattedDate,
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: screenHeight * 0.015,
                                              color: AppColors.textTernary,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                    CustomChatBubble(
                                      message: currentMessage.content,
                                      timestamp: formattedTime,
                                      senderId: currentMessage.sender,
                                      myId: controller.myId.value,
                                      istyping: false,
                                    ),
                                    isLast
                                        ? SizedBox(height: screenHeight * 0.01)
                                        : const SizedBox(height: 0),
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
          bottomNavigationBar: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 8,
              left: screenWidth * 0.03,
              right: screenWidth * 0.03,
              top: 8,
            ),
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Material(
                    // Replaced Container with Material for elevation
                    elevation: 4.0, // Added elevation
                    borderRadius: BorderRadius.circular(24),
                    color: AppColors.surfaceColor,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            onChanged: (value) {
                              controller.newMessage.value = value.isNotEmpty
                                  ? value[0].toUpperCase() + value.substring(1)
                                  : value;
                              if (value.isNotEmpty) {
                                controller.startTyping();
                              } else {
                                controller.stopTyping();
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'Type a message...',
                              hintStyle: TextStyle(
                                fontFamily: 'Poppins',
                                color: AppColors.textTernary,
                                fontSize: screenHeight *
                                    0.017, // Adjusted for responsiveness
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: screenWidth *
                                    0.04, // Adjusted for responsiveness
                                vertical: screenHeight *
                                    0.015, // Adjusted for responsiveness
                              ),
                              filled:
                                  false, // Changed: Material widget now provides the background
                              // fillColor: AppColors.background, // Removed
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24.0),
                                borderSide: BorderSide(
                                  color: AppColors.orange.withOpacity(0.3),
                                  width:
                                      0.8, // Slightly thicker border for better visibility
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24.0),
                                borderSide: BorderSide(
                                  color: AppColors.orange.withOpacity(0.3),
                                  width: 0.8, // Slightly thicker border
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24.0),
                                borderSide: const BorderSide(
                                  color: AppColors
                                      .orange, // Highlight color on focus
                                  width: 1.0, // Slightly thicker focused border
                                ),
                              ),
                              suffixIcon: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(24),
                                  onTap: () {
                                    // Send message logic
                                    if (_textController.text
                                        .trim()
                                        .isNotEmpty) {
                                      updateChatListController.sendMessage();
                                      controller.sendMessage();
                                      _textController.clear();
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Icon(
                                      Icons.send_rounded,
                                      color: AppColors.orange,
                                      size: screenHeight *
                                          0.03, // Adjusted for responsiveness
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void handleClick(int item) {
    switch (item) {
      case 0:
        controller.refreshChats();
        //controller.reconnect();
        break;
    }
  }

  String formatTime(String isoDate) {
    DateTime dateTime = DateTime.parse(isoDate);
    return DateFormat.jm().format(dateTime);
  }

  String formatDate(String isoDate) {
    DateTime dateTime = DateTime.parse(isoDate);
    return DateFormat('d MMM yyyy, h:mm a').format(dateTime);
  }
}
