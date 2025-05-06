import 'package:chat_application_socket_io/cores/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import flutter_svg
import 'package:get/get.dart'; // Import Get for navigation

Widget ChatListWidget(context, String name, String lastMessage,
    String lastMessageTime, String avatar) {
  final double screenHeight = MediaQuery.of(context).size.height;
  final double screenWidth = MediaQuery.of(context).size.width;

  String displayDateTimeValue;
  try {
    final DateTime parsedLastMessageTime = DateTime.parse(lastMessageTime);
    final DateTime now = DateTime.now();

    final bool isToday = parsedLastMessageTime.year == now.year &&
        parsedLastMessageTime.month == now.month &&
        parsedLastMessageTime.day == now.day;

    if (isToday) {
      // If today, show time (HH:MM)
      final String hour = parsedLastMessageTime.hour.toString().padLeft(2, '0');
      final String minute =
          parsedLastMessageTime.minute.toString().padLeft(2, '0');
      displayDateTimeValue = '$hour:$minute';
    } else {
      // If not today, show date (DD/MM/YYYY)
      final String day = parsedLastMessageTime.day.toString().padLeft(2, '0');
      final String month =
          parsedLastMessageTime.month.toString().padLeft(2, '0');
      final String year = parsedLastMessageTime.year.toString();
      displayDateTimeValue = '$day/$month/$year';
    }
  } catch (e) {
    // Fallback for invalid date string or other errors
    print("Error parsing or formatting lastMessageTime '$lastMessageTime': $e");
    displayDateTimeValue =
        lastMessageTime; // Show the original string as a fallback
  }

  return Card(
    elevation: 4,
    margin: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    color: AppColors.surfaceColor,
    child: SizedBox(
      height: screenHeight * 0.08,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: screenWidth * 0.01,
            ),
            Padding(
              padding: EdgeInsets.only(
                  right: screenWidth * 0.018,
                  top: screenHeight * 0.01,
                  bottom: screenHeight * 0.01),
              child: Container(
                height: (screenHeight * 0.065),
                width: screenWidth * 0.14,
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
                      left: screenWidth * 0.01,
                      top: screenHeight * 0.016,
                      bottom: screenHeight * 0.0025),
                  child: SizedBox(
                    width: screenWidth * 0.5,
                    child: Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: screenHeight * 0.02,
                        color: AppColors.textPrimary,
                        fontFamily: 'poppins',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.5,
                  child: Text(
                    lastMessage,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: screenHeight * 0.018,
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
              mainAxisAlignment: MainAxisAlignment
                  .center, // To vertically center the time/date text
              crossAxisAlignment:
                  CrossAxisAlignment.end, // To align the text to the right
              children: [
                Text(
                  displayDateTimeValue,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: screenHeight * 0.013, // Decreased font size
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
    ),
  );
}
