import 'package:chat_application_socket_io/cores/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import flutter_svg

Widget ChatListWidget(context, String name, String lastMessage,
    String lastMessageTime, String avatar) {
  double Height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;
  return Container(
    height: (Height * 0.08),
    width: (width * 0.9),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: AppColors.surfaceColor,
      boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.05),
          blurRadius: 5,
          spreadRadius: 1,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Padding(
      padding: EdgeInsets.only(
        right: width * 0.015,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: width * 0.02,
          ),
          Padding(
            padding: EdgeInsets.only(
                right: width * 0.018,
                top: Height * 0.01,
                bottom: Height * 0.01),
            child: Container(
              height: (Height * 0.065),
              width: width * 0.14,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: SvgPicture.asset(avatar),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: width * 0.01,
                    top: Height * 0.016,
                    bottom: Height * 0.0025),
                child: SizedBox(
                  width: width * 0.5,
                  child: Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: Height * 0.02,
                      color: AppColors.textPrimary,
                      fontFamily: 'poppins',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: width * 0.5,
                child: Text(
                  lastMessage,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: Height * 0.018,
                    color: AppColors.textTernary,
                    fontFamily: 'poppins',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                lastMessageTime.split('T').last.substring(0, 5),
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: Height * 0.015,
                  color: AppColors.textTernary,
                  fontFamily: 'poppins',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                lastMessageTime.split('T').first,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: Height * 0.015,
                  color: AppColors.textTernary,
                  fontFamily: 'poppins',
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          )
        ],
      ),
    ),
  );
}
