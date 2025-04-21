import 'package:chat_application_socket_io/cores/app_colors.dart';
import 'package:chat_application_socket_io/features/chat/controller/chat_controller.dart';
import 'package:chat_application_socket_io/features/chat/models/message_model.dart';
import 'package:chat_application_socket_io/features/chat/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatelessWidget {
  final ChatController controller = Get.put(ChatController());
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String getSvgPath(String name) {
    if (name == 'male') {
      return 'assets/png/male.jpg';
    } else {
      return 'assets/png/female.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // controller.scrollController = _scrollController;

    return WillPopScope(
      onWillPop: () async {
        controller.onClose();
        controller.close();
        Get.back();
        return true;
      },
      child: Container(
        height: screenHeight * 0.9,
        width: screenWidth,
        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage('assets/svg/background.svg'),
        //     fit: BoxFit.fitHeight,
        //     colorFilter:
        //         ColorFilter.mode(AppColors.background, BlendMode.darken),
        //   ),
        // ),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColors.background,
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
                    elevation: 0.4,
                    centerTitle: false,
                    titleSpacing: screenWidth * 0.00,
                    leadingWidth: screenWidth * 0.13,
                    leading: MaterialButton(
                      splashColor: Colors.grey.shade200,
                      highlightColor: Colors.grey.shade200,
                      height: 2,
                      minWidth: 2,
                      shape: const CircleBorder(),
                      onPressed: () {
                        controller.onClose();
                        controller.close();
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
                              getSvgPath(controller.receiverGender.value),
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
                      return const Center(child: CircularProgressIndicator());
                    } else if (controller.messages.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: screenHeight * 0.37),
                            Text(
                              'Say Hello!',
                              style: TextStyle(
                                fontSize: screenHeight * 0.025,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                color: AppColors.orange,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              'Start your conversation',
                              style: TextStyle(
                                fontSize: screenHeight * 0.015,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Expanded(
                        child: Container(
                          color: Colors.transparent,
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom: screenHeight * 0.088,
                              left: screenWidth * 0.02,
                              right: screenWidth * 0.02,
                            ),
                            child: ListView.builder(
                              // controller: _scrollController,
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
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: screenHeight * 0.065,
                width: screenWidth * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.background,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.orange.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _textController,
                  onChanged: (value) {
                    controller.newMessage.value =
                        value[0].toUpperCase() + value.substring(1);
                    if (value.isNotEmpty) {
                      controller.startTyping();
                    } else {
                      controller.stopTyping();
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: const TextStyle(
                        fontFamily: 'Poppins', color: AppColors.textTernary),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        controller.sendMessage();
                        _textController.clear();
                      },
                      child: Icon(
                        Icons.send_rounded,
                        color: AppColors.orange,
                        size: screenHeight * 0.03,
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.background,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03,
                      vertical: screenHeight * 0.02,
                    ),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniCenterFloat,
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
