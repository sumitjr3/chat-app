import 'package:chat_application_socket_io/cores/app_colors.dart';
import 'package:chat_application_socket_io/features/login/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  final LoginController authController = Get.put(LoginController());
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Obx(() {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.05),

                //heading
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: screenWidth * 0.05),
                      child: Text(
                        'Login ',
                        style: TextStyle(
                            fontSize: screenHeight * 0.04,
                            fontWeight: FontWeight.w500,
                            color: AppColors.orange),
                      ),
                    ),
                    Text(
                      'to your',
                      style: TextStyle(
                          fontSize: screenHeight * 0.04,
                          fontWeight: FontWeight.w500,
                          color: AppColors.backgroundDark),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: screenWidth * 0.05),
                      child: Text(
                        'Account',
                        style: TextStyle(
                            fontSize: screenHeight * 0.04,
                            fontWeight: FontWeight.w500,
                            color: AppColors.backgroundDark),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.05),

                //username text
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     Padding(
                //       padding: EdgeInsets.only(left: screenWidth * 0.05),
                //       child: Text(
                //         'Username',
                //         style: TextStyle(
                //             fontSize: screenHeight * 0.018,
                //             fontWeight: FontWeight.w400),
                //       ),
                //     ),
                //   ],
                // ),

                //username textfield
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: screenWidth * 0.9,
                      height: screenHeight * 0.056,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(
                            Icons.person,
                            color: AppColors.textSecondary,
                          ),
                          hintText: 'Enter Username',
                          hintStyle: TextStyle(
                              fontSize: screenHeight * 0.018,
                              color: AppColors.textSecondary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: AppColors.backgroundDark, width: 0.3),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: AppColors.backgroundDark, width: 0.3),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: AppColors.backgroundDark, width: 0.3),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.02),

                //password text
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     Padding(
                //       padding: EdgeInsets.only(left: screenWidth * 0.06),
                //       child: Text(
                //         'Password',
                //         style: TextStyle(
                //             fontSize: screenHeight * 0.018,
                //             fontWeight: FontWeight.w400),
                //       ),
                //     ),
                //   ],
                // ),

                //password textfield
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: screenWidth * 0.9,
                      height: screenHeight * 0.056,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(
                            Icons.remove_red_eye_sharp,
                            color: AppColors.textSecondary,
                          ),
                          hintText: 'Enter Password',
                          hintStyle: TextStyle(
                              fontSize: screenHeight * 0.018,
                              color: AppColors.textSecondary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: AppColors.backgroundDark, width: 0.3),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: AppColors.backgroundDark, width: 0.3),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: AppColors.backgroundDark, width: 0.3),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                        ),
                      ),
                    ),
                  ],
                ),

                //forget password text
                Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 0.05, right: screenWidth * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forget Password?',
                        style: TextStyle(
                          fontSize: screenHeight * 0.018,
                          fontWeight: FontWeight.w400,
                          color: AppColors.orange,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: screenHeight * 0.288,
                ),

                //login button
                FilledButton(
                  onPressed: authController.isLoading.value
                      ? null
                      : () {
                          if (usernameController.text.isNotEmpty &&
                              passwordController.text.isNotEmpty) {
                            authController.login(usernameController.text,
                                passwordController.text);
                          } else {
                            Get.snackbar('Error', 'Please fill all fields',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: AppColors.orange,
                                colorText: Colors.white);
                          }
                        },
                  style: FilledButton.styleFrom(
                    fixedSize: Size(screenWidth * 0.9, screenHeight * 0.056),
                    backgroundColor: AppColors.orange,
                    foregroundColor: AppColors.orange,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                          color: AppColors.backgroundDark, width: 0.2),
                      borderRadius:
                          BorderRadius.circular(25), // Button border radius
                    ),
                  ),
                  child: authController.isLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white, // Text color
                            fontSize: screenHeight * 0.018,
                          ),
                        ),
                ),

                SizedBox(height: screenHeight * 0.02),

                //divider
                Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 0.05, right: screenWidth * 0.05),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: AppColors.backgroundDark,
                          thickness: 0.5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Or signup',
                          style: TextStyle(
                            color: AppColors.backgroundDark,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: AppColors.backgroundDark,
                          thickness: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),

                //signup button
                FilledButton(
                  onPressed: () {
                    // Add your login logic here
                    Get.offAllNamed('/signup');
                  },
                  style: FilledButton.styleFrom(
                    fixedSize: Size(screenWidth * 0.9, screenHeight * 0.056),
                    backgroundColor: AppColors.backgroundDark,
                    foregroundColor: AppColors.backgroundDark,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(25), // Button border radius
                    ),
                  ),
                  child: Text(
                    'SignUp',
                    style: TextStyle(
                      color: Colors.white, // Text color
                      fontSize: screenHeight * 0.018,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
