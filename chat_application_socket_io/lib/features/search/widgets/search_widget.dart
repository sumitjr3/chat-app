import 'package:chat_application_socket_io/cores/app_colors.dart';
import 'package:flutter/material.dart';

Widget SearchWidget(context, String name, bool genderMale) {
  double Height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;
  return Container(
    height: (Height * 0.08),
    width: (width * 0.9),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: AppColors.surfaceColor,
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
                child: genderMale
                    ? Image.asset('assets/png/male.jpg')
                    : Image.asset('assets/png/female.jpg'),
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
                  'tap to chat',
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
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(' ')],
          )
        ],
      ),
    ),
  );
}
