import 'package:chat_application_socket_io/cores/app_colors.dart';
import 'package:chat_application_socket_io/features/signup/controller/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupView extends StatelessWidget {
  final SignupController signupController = Get.put(SignupController());
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

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
                        'SignUp ',
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

                SizedBox(height: screenHeight * 0.04),

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
                          hintText: 'Username',
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

                SizedBox(height: screenHeight * 0.01),

                //email text
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     Padding(
                //       padding: EdgeInsets.only(left: screenWidth * 0.05),
                //       child: Text(
                //         'Email',
                //         style: TextStyle(
                //             fontSize: screenHeight * 0.018,
                //             fontWeight: FontWeight.w400),
                //       ),
                //     ),
                //   ],
                // ),
                //email textfield
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
                        controller: emailController,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(
                            Icons.mail_rounded,
                            color: AppColors.textSecondary,
                          ),
                          hintText: 'Enter Email',
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

                SizedBox(height: screenHeight * 0.01),

                // firstname and lastname
                Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 0.05, right: screenWidth * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //firstname
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //firstname text
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   children: [
                          //     Text(
                          //       'First Name',
                          //       style: TextStyle(
                          //           fontSize: screenHeight * 0.018,
                          //           fontWeight: FontWeight.w400),
                          //     ),
                          //   ],
                          // ),
                          //firstname textfield
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: screenWidth * 0.43,
                                height: screenHeight * 0.056,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextField(
                                  controller: firstNameController,
                                  decoration: InputDecoration(
                                    // suffixIcon: const Icon(
                                    //   Icons.person,
                                    //   color: AppColors.textSecondary,
                                    // ),
                                    hintText: 'First Name',
                                    hintStyle: TextStyle(
                                        fontSize: screenHeight * 0.018,
                                        color: AppColors.textSecondary),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: AppColors.backgroundDark,
                                          width: 0.3),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: AppColors.backgroundDark,
                                          width: 0.3),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: AppColors.backgroundDark,
                                          width: 0.3),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      //lastname
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //firstname text
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   children: [
                          //     Text(
                          //       'Last Name',
                          //       style: TextStyle(
                          //           fontSize: screenHeight * 0.018,
                          //           fontWeight: FontWeight.w400),
                          //     ),
                          //   ],
                          // ),
                          //firstname textfield
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: screenWidth * 0.43,
                                height: screenHeight * 0.056,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextField(
                                  controller: lastNameController,
                                  decoration: InputDecoration(
                                    // suffixIcon: const Icon(
                                    //   Icons.person,
                                    //   color: AppColors.textSecondary,
                                    // ),
                                    hintText: 'Last Name',
                                    hintStyle: TextStyle(
                                        fontSize: screenHeight * 0.018,
                                        color: AppColors.textSecondary),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: AppColors.backgroundDark,
                                          width: 0.3),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: AppColors.backgroundDark,
                                          width: 0.3),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: AppColors.backgroundDark,
                                          width: 0.3),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.01),

                //password text
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     Padding(
                //       padding: EdgeInsets.only(left: screenWidth * 0.05),
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
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(
                            Icons.lock,
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
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.01),

                //male female text
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     Padding(
                //       padding: EdgeInsets.only(left: screenWidth * 0.05),
                //       child: Text(
                //         'Male/Female',
                //         style: TextStyle(
                //             fontSize: screenHeight * 0.018,
                //             fontWeight: FontWeight.w400),
                //       ),
                //     ),
                //   ],
                // ),
                //male female radio button
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
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
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
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        ),
                        hint: Text('Select Gender',
                            style: TextStyle(
                                fontSize: screenHeight * 0.018,
                                color: AppColors.textSecondary)),
                        items: ['male', 'female'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: screenHeight * 0.018,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          genderController.text = value ?? '';
                        },
                      ),
                    ),
                  ],
                ),

                //buttons
                SizedBox(height: screenHeight * 0.06),

                //login button
                FilledButton(
                  onPressed: signupController.isLoading.value
                      ? null
                      : () async {
                          if (usernameController.text.isNotEmpty &&
                              passwordController.text.isNotEmpty &&
                              emailController.text.isEmail &&
                              firstNameController.text.isNotEmpty &&
                              lastNameController.text.isNotEmpty &&
                              genderController.text.isNotEmpty) {
                            // signupController.signup(
                            //     usernameController.text,
                            //     passwordController.text,
                            //     emailController.text,
                            //     firstNameController.text,
                            //     lastNameController.text,
                            //     genderController.text);
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setString(
                                'usernameText', usernameController.text);
                            await prefs.setString(
                                'passwordText', passwordController.text);
                            await prefs.setString(
                                'emailText', emailController.text);
                            await prefs.setString(
                                'firstnameText', firstNameController.text);
                            await prefs.setString(
                                'lastnameText', lastNameController.text);
                            await prefs.setString(
                                'genderText', genderController.text);

                            Get.toNamed('/selectAvtarScreen');
                          } else {
                            Get.snackbar(
                              'Error',
                              'Please fill all fields',
                              snackPosition: SnackPosition.TOP,
                            );
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
                  child: signupController.isLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Text(
                          'SignUp',
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
                          'Or Login',
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
                    Get.offAllNamed('/login');
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
                    'Login',
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
