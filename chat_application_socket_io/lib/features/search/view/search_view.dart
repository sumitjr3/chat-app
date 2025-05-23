import 'package:chat_application_socket_io/cores/app_colors.dart';
import 'package:chat_application_socket_io/features/chat%20list/controller/chat_list_controller.dart';
import 'package:chat_application_socket_io/features/search/controller/search_controller.dart';
import 'package:chat_application_socket_io/features/search/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchViewClass extends StatelessWidget {
  SearchViewClass({super.key});
  SearchControllers controller = Get.put(SearchControllers());
  final searchControllertc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Obx(() {
      return SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: IconButton(
                icon:
                    Icon(Icons.arrow_back_ios, color: AppColors.backgroundDark),
                onPressed: () {
                  // Get.find<ChatListController>().onInit();
                  Get.back();
                }),
            title: Text(
              'Search User',
              style: TextStyle(
                fontSize: height * 0.02,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: width * 0.05,
                  right: width * 0.05,
                  top: width * 0.03,
                ),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Container(
                    width: double.infinity,
                    child: TextField(
                      scrollPadding: EdgeInsets.zero,
                      autofocus: false,
                      onChanged: (value) {
                        controller.searchValue.value = value;
                      },
                      controller: searchControllertc,
                      keyboardType: TextInputType.streetAddress,
                      decoration: InputDecoration(
                        hintText: "Search using number or name",
                        hintStyle: TextStyle(
                          fontSize: height * 0.018,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                        ),
                        prefixIcon: const Icon(Icons.search_rounded),
                        fillColor: AppColors.surfaceColor,
                        filled: true,
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(
                            color: AppColors.backgroundDark,
                            width: 0.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(
                            color: AppColors.orange, // Focused border color
                            width: 0.5,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: height * 0.01,
                          horizontal: width * 0.02,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.01),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.getSearchUser();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: EdgeInsets.symmetric(vertical: height * 0.015),
                    ),
                    child: Text(
                      'Search',
                      style: TextStyle(
                        fontSize: height * 0.018,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              controller.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : controller.userList.isEmpty
                      ? Center()
                      : GestureDetector(
                          onTap: () async {
                            //store data to shared preference
                            final prefs = await SharedPreferences.getInstance();
                            prefs.setString(
                                'receiver_id', controller.userList[0].userId);
                            prefs.setString('receiver_name',
                                controller.userList[0].username);
                            prefs.setString(
                                'receiver_mail', controller.userList[0].email);
                            prefs.setString('receiver_gender',
                                controller.userList[0].gender);

                            prefs.setString('receiver_avatar',
                                controller.userList[0].avatar);

                            //navigate to chat screen
                            Get.toNamed('/chatScreen');
                          },
                          child: SearchWidget(
                            context,
                            controller.userList[0].username,
                            controller.userList[0].avatar,
                          ),
                        )
            ],
          ),
        ),
      );
    });
  }
}
