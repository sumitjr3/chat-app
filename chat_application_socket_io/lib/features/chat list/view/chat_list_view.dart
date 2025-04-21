import 'package:chat_application_socket_io/cores/app_colors.dart';
import 'package:chat_application_socket_io/features/chat%20list/controller/chat_list_controller.dart';
import 'package:chat_application_socket_io/widgets/chat_list_widget.dart';
import 'package:chat_application_socket_io/widgets/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class ChatListView extends StatelessWidget {
  ChatListView({super.key});
  final ChatListController controller = Get.put(ChatListController());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Obx(() {
      return SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: Padding(
            padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'welcome, ',
                      style: TextStyle(
                        fontSize: height * 0.025,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: AppColors.backgroundDark,
                      ),
                    ),
                    Text(
                      '${controller.userName}',
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: height * 0.025,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: AppColors.orange,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/svg/profile.svg',
                        height: height * 0.04,
                        width: width * 0.04,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                SizedBox(height: height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Chats',
                      style: TextStyle(
                        fontSize: height * 0.02,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: AppColors.backgroundDark,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.01),
                controller.isLoading.value
                    ? Shimmer.fromColors(
                        baseColor: AppColors.textSecondary,
                        highlightColor: AppColors.background,
                        direction: ShimmerDirection.ltr,
                        child: SizedBox(
                          height: height * 0.8,
                          child: ListView.builder(
                            itemCount: 10,
                            itemBuilder: (_, index) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: height * 0.01),
                                child: ShimCon(
                                  height: height * 0.08,
                                  width: width * 0.9,
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : controller.chatList.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Center(
                                child: SvgPicture.asset(
                                  'assets/svg/no_data.svg',
                                  height: width * 0.9,
                                  width: width * 0.9,
                                ),
                              ),
                            ],
                          )
                        : Expanded(
                            // Wrap ListView with Expanded
                            child: ListView.builder(
                              itemCount: controller.chatList.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setString('receiver_id',
                                        controller.chatList[index].id ?? '');
                                    prefs.setString('receiver_name',
                                        controller.chatList[index].name ?? '');
                                    prefs.setString('receiver_mail',
                                        controller.chatList[index].email ?? '');
                                    prefs.setString(
                                        'receiver_gender',
                                        controller.chatList[index].gender ??
                                            '');

                                    //navigate to chat screen
                                    Get.toNamed('/chatScreen');
                                  },
                                  child: ChatListWidget(
                                    context,
                                    controller.chatList[index].name!,
                                    controller.chatList[index].lastMessage!,
                                    controller.chatList[index].lastMessageTime!,
                                    controller.chatList[index].gender == 'male'
                                        ? true
                                        : false,
                                  ),
                                );
                              },
                            ),
                          ),
              ],
            ),
          ),
          floatingActionButton: Padding(
            padding: EdgeInsets.all(width * 0.03),
            child: FloatingActionButton(
              backgroundColor: AppColors.background,
              onPressed: () {
                // Add your action here
                Get.toNamed('/searchView');
              },
              child: const Icon(
                Icons.person_add_alt_1_outlined,
                color: AppColors.orange,
              ),
            ),
          ),
        ),
      );
    });
  }
}
