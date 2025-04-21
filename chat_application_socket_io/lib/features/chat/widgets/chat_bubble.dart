import 'package:chat_application_socket_io/cores/app_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomChatBubble extends StatefulWidget {
  final String message;
  final String timestamp;
  final String senderId;
  final String myId;
  final bool istyping;

  const CustomChatBubble({
    super.key,
    required this.message,
    required this.timestamp,
    required this.senderId,
    required this.myId,
    required this.istyping,
  });

  @override
  _CustomChatBubbleState createState() => _CustomChatBubbleState();
}

class _CustomChatBubbleState extends State<CustomChatBubble> {
  bool _isExpanded = false;
  static const int _maxChars =
      300; // Define the maximum characters before truncation

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    bool isMessageTooLong = widget.message.length > _maxChars;
    String displayedMessage = _isExpanded || !isMessageTooLong
        ? widget.message
        : '${widget.message.substring(0, _maxChars)}...';

    return widget.istyping
        ? _buildTypingIndicator(screenWidth, screenHeight)
        : _buildMessageBubble(
            screenWidth, screenHeight, isMessageTooLong, displayedMessage);
  }

  Widget _buildTypingIndicator(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.only(
        left: screenWidth * 0.02,
        right: screenWidth * 0.02,
        bottom: screenHeight * 0.006,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: screenHeight * 0.06,
            width: screenWidth * 0.15,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(2),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.orange.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                'assets/gif/Loading.gif',
                height: screenHeight * 0.03,
                width: screenWidth * 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(double screenWidth, double screenHeight,
      bool isMessageTooLong, String displayedMessage) {
    return Padding(
      padding: EdgeInsets.only(
        top: screenHeight * 0.002,
        left: screenWidth * 0.02,
        right: screenWidth * 0.02,
        bottom: screenHeight * 0.006,
      ),
      child: Row(
        mainAxisAlignment: widget.senderId == widget.myId
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          IntrinsicWidth(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: screenWidth * 0.65,
              ),
              decoration: BoxDecoration(
                color: widget.myId == widget.senderId
                    ? AppColors.orange
                    : AppColors.sentMessage,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: widget.myId == widget.senderId
                      ? const Radius.circular(20)
                      : const Radius.circular(2),
                  bottomRight: widget.myId == widget.senderId
                      ? const Radius.circular(2)
                      : const Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.orange.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(screenHeight * 0.015),
                child: isMessageTooLong
                    ? _buildLongMessageContent(displayedMessage)
                    : _buildShortMessageContent(displayedMessage),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLongMessageContent(String displayedMessage) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      // mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SelectableText(
          displayedMessage,
          style: TextStyle(
            fontFamily: 'poppins',
            fontSize: screenHeight * 0.018,
            color: widget.myId == widget.senderId
                ? AppColors.sentMessage
                : AppColors.backgroundDark,
          ),
        ),
        if (!_isExpanded)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = true;
                  });
                },
                child: Text(
                  'Read more',
                  style: TextStyle(
                      fontFamily: 'poppins',
                      fontSize: screenHeight * 0.018,
                      color: Colors.lightBlue
                      // color: widget.myId == widget.senderId
                      //     ? Colors.white
                      //     : Colors.black,
                      ),
                ),
              ),
              Text(
                widget.timestamp,
                style: TextStyle(
                  fontFamily: 'poppins',
                  fontSize: screenHeight * 0.01,
                  color: widget.myId == widget.senderId
                      ? AppColors.sentMessage
                      : AppColors.backgroundDark,
                ),
              ),
            ],
          ),
        if (_isExpanded)
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.01,
              ),
              child: Text(
                widget.timestamp,
                style: TextStyle(
                  fontFamily: 'poppins',
                  fontSize: screenHeight * 0.01,
                  color: widget.myId == widget.senderId
                      ? AppColors.sentMessage
                      : AppColors.backgroundDark,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildShortMessageContent(String displayedMessage) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Determine if the message spans multiple lines
    TextSpan textSpan = TextSpan(
      text: displayedMessage,
      style: TextStyle(
        fontFamily: 'poppins',
        fontSize: screenHeight * 0.018,
        color: widget.myId == widget.senderId
            ? AppColors.sentMessage
            : AppColors.backgroundDark,
      ),
    );
    TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: screenWidth * 0.65);

    bool isMultiline = textPainter.width > screenWidth * 0.65;

    return isMultiline
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SelectableText(
                displayedMessage,
                style: TextStyle(
                  fontFamily: 'poppins',
                  fontSize: screenHeight * 0.018,
                  color: widget.myId == widget.senderId
                      ? AppColors.sentMessage
                      : AppColors.backgroundDark,
                ),
              ),
              Container(
                color: Colors.amber,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      widget.timestamp,
                      style: TextStyle(
                        fontFamily: 'poppins',
                        fontSize: screenHeight * 0.01,
                        color: widget.myId == widget.senderId
                            ? AppColors.sentMessage
                            : AppColors.backgroundDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: SelectableText(
                  displayedMessage,
                  style: TextStyle(
                    fontFamily: 'poppins',
                    fontSize: screenHeight * 0.018,
                    color: widget.myId == widget.senderId
                        ? AppColors.sentMessage
                        : AppColors.backgroundDark,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: screenHeight * 0.012,
                  left: screenWidth * 0.03,
                ),
                child: Text(
                  widget.timestamp,
                  style: TextStyle(
                    fontFamily: 'poppins',
                    fontSize: screenHeight * 0.01,
                    color: widget.myId == widget.senderId
                        ? AppColors.sentMessage
                        : AppColors.backgroundDark,
                  ),
                ),
              ),
            ],
          );
  }
}
