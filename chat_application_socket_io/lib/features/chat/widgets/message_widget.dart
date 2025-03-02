import 'package:flutter/material.dart';

class CustomChatBubble extends StatelessWidget {
  final String message;
  final String timestamp;
  final String senderId;
  final String myId;

  const CustomChatBubble({
    Key? key,
    required this.message,
    required this.timestamp,
    required this.senderId,
    required this.myId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(
        left: screenWidth * 0.02,
        right: screenWidth * 0.02,
        bottom: screenHeight * 0.006,
      ),
      child: Row(
        mainAxisAlignment:
            senderId == myId ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          IntrinsicWidth(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: screenWidth * 0.65,
              ),
              decoration: BoxDecoration(
                color: myId == senderId
                    ? const Color.fromARGB(255, 4, 5, 118)
                    : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: myId == senderId
                      ? Radius.circular(20)
                      : Radius.circular(2),
                  bottomRight: myId == senderId
                      ? Radius.circular(2)
                      : Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff3D0187).withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      // left: myId == senderId
                      //     ? screenHeight * 0.025
                      //     : screenHeight * 0.05,
                      // right: myId == senderId
                      //     ? screenHeight * 0.05
                      //     : screenHeight * 0.025,
                      left: screenHeight * 0.025,
                      right: screenHeight * 0.025,
                      top: screenHeight * 0.015,
                      bottom: screenHeight * 0.005,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            message,
                            style: TextStyle(
                              fontSize: screenHeight * 0.018,
                              color: myId == senderId
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          right: screenHeight * 0.025,
                          bottom: screenHeight * 0.01,
                        ),
                        child: Text(
                          timestamp,
                          style: TextStyle(
                            fontSize: screenHeight * 0.01,
                            color:
                                myId == senderId ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
