import 'package:chat_application_socket_io/cores/app_colors.dart'; // Import AppColors
import 'package:chat_application_socket_io/features/signup/controller/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class AvatarSelectionScreen extends StatelessWidget {
  // Inject the SignupController
  final SignupController avatarController = Get.find<SignupController>();

  AvatarSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions using MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Define responsive sizes based on screen dimensions
    double appBarIconSize = screenHeight * 0.028;
    double appBarTitleSize = screenHeight * 0.028;
    double gridSpacing = screenWidth * 0.03; // Responsive spacing
    double verticalSpacing = screenHeight * 0.01; // Responsive vertical spacing
    double avatarBorderSize = screenWidth * 0.006; // Responsive border size
    double avatarBlurRadius =
        screenWidth * 0.015; // Adjusted blur for general shadow
    double avatarSpreadRadius =
        screenWidth * 0.002; // Adjusted spread for general shadow
    double selectedAvatarBlurRadius = screenWidth * 0.02; // Blur for selected
    double selectedAvatarSpreadRadius =
        screenWidth * 0.005; // Spread for selected
    // double avatarPadding = screenWidth * 0.02; // Padding removed to allow image to fill space
    double buttonHeight = screenHeight * 0.06;
    double buttonFontSize = screenHeight * 0.022;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0, // Remove app bar shadow if desired
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.textPrimary, // Use color from AppColors
          ),
          iconSize: appBarIconSize, // Use responsive size
        ),
        title: Text(
          'Select Your Avatar',
          style: TextStyle(
            fontSize: appBarTitleSize, // Use responsive size
            color: AppColors.textPrimary, // Use color from AppColors
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        // Use responsive padding
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch, // Stretch button later
          children: [
            SizedBox(height: verticalSpacing), // Use responsive spacing

            // Use Obx to reactively update the UI when selectedAvatarIndex changes
            Expanded(
              // GridView to display avatars
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Number of columns
                    crossAxisSpacing: gridSpacing, // Use responsive spacing
                    mainAxisSpacing: gridSpacing, // Use responsive spacing
                    childAspectRatio:
                        1.0, // Aspect ratio of each item (makes them square)
                  ),
                  // Use the length of the avatar list from the controller
                  itemCount: avatarController.avatarAssets.length,
                  itemBuilder: (context, index) {
                    // Get the avatar asset path
                    final String avatarPath =
                        avatarController.avatarAssets[index];

                    // Check if the current avatar is the selected one
                    return Obx(
                      () {
                        final isSelected =
                            avatarController.selectedAvatarIndex.value == index;

                        return GestureDetector(
                          // On tap, call the selectAvatar method in the controller
                          onTap: () {
                            avatarController.selectAvatar(index);
                          },
                          child: AnimatedContainer(
                            // Use AnimatedContainer for smooth transition on selection change
                            duration: const Duration(milliseconds: 200),
                            // padding: EdgeInsets.all(avatarPadding), // Padding removed
                            decoration: BoxDecoration(
                              shape: BoxShape
                                  .circle, // Make the container circular
                              color: AppColors
                                  .surfaceColor, // Use surface color for background
                              border: Border.all(
                                color: isSelected
                                    ? AppColors
                                        .orange // Use orange for selected border
                                    : Colors
                                        .grey.shade300, // Default subtle border
                                width: isSelected
                                    ? avatarBorderSize
                                    : 1.0, // Use responsive border size for selected
                              ),
                              boxShadow: [
                                // Apply shadow to all avatars
                                BoxShadow(
                                  // Use orange shadow for selected, subtle grey otherwise
                                  color: isSelected
                                      ? AppColors.orange.withOpacity(0.6)
                                      : Colors.black.withOpacity(0.15),
                                  blurRadius: isSelected
                                      ? selectedAvatarBlurRadius // Responsive blur for selected
                                      : avatarBlurRadius, // General blur
                                  spreadRadius: isSelected
                                      ? selectedAvatarSpreadRadius // Responsive spread for selected
                                      : avatarSpreadRadius, // General spread
                                  offset: Offset(
                                      0,
                                      avatarSpreadRadius *
                                          2), // Slight offset downwards
                                ),
                              ],
                            ),
                            child: ClipOval(
                              // Clip the image to the circle shape
                              child: SvgPicture.asset(
                                // Use SvgPicture.asset for SVG files
                                avatarPath,
                                fit: BoxFit
                                    .cover, // Ensure the image covers the circle area fully
                                placeholderBuilder: (BuildContext context) =>
                                    Container(
                                        // Optional placeholder while loading
                                        alignment: Alignment.center,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          color: AppColors.primary,
                                        )),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
            ),

            SizedBox(height: verticalSpacing), // Use responsive spacing

            // Create Account Button
            ElevatedButton(
              // Disable button if loading
              onPressed: avatarController.isLoading.value
                  ? null
                  : () async {
                      if (avatarController.selectedAvatarIndex.value != -1) {
                        // Get SharedPreferences instance
                        final prefs = await SharedPreferences.getInstance();

                        // Retrieve stored data (provide default empty strings just in case)
                        final username = prefs.getString('usernameText') ?? '';
                        final password = prefs.getString('passwordText') ?? '';
                        final email = prefs.getString('emailText') ?? '';
                        final firstname =
                            prefs.getString('firstnameText') ?? '';
                        final lastname = prefs.getString('lastnameText') ?? '';
                        final gender = prefs.getString('genderText') ?? '';
                        final avatarPath = avatarController.avatarAssets[
                            avatarController.selectedAvatarIndex.value];

                        // Call the signup method from the controller
                        await avatarController.signup(username, password, email,
                            firstname, lastname, gender, avatarPath);

                        // Note: Navigation is handled inside the signup method on success
                      } else {
                        // Show a snackbar or message asking the user to select an avatar
                        Get.snackbar(
                          'Avatar Required',
                          'Please select an avatar before creating an account.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    AppColors.orange, // Use orange color from AppColors
                minimumSize: Size(double.infinity,
                    buttonHeight), // Full width, responsive height
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Add some rounding
                ),
                elevation: 3, // Add slight elevation to the button
              ),
              // Show loading indicator or text based on controller state
              child: Obx(() {
                return avatarController.isLoading.value
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: buttonFontSize, // Responsive font size
                          color: Colors.white, // White text for contrast
                          fontWeight: FontWeight.bold,
                        ),
                      );
              }),
            ),
            SizedBox(height: verticalSpacing), // Add some bottom spacing
          ],
        ),
      ),
    );
  }
}
