import 'package:chat_application_socket_io/cores/app_colors.dart';
import 'package:chat_application_socket_io/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:flutter_svg/flutter_svg.dart'; // Import flutter_svg

class ProfileView extends StatelessWidget {
  ProfileView({super.key});
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Obx(() {
      return controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Scaffold(
              // Use a background color from the theme for the whole page
              backgroundColor: AppColors.background,
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                  iconSize: height * 0.028,
                ),
                title: Text(
                  'Profile',
                  style: TextStyle(fontSize: height * 0.028),
                ),
                backgroundColor: Colors.transparent, // Make AppBar transparent
                elevation: 0, // Remove shadow
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                // Use SingleChildScrollView for responsiveness
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // --- Profile Header ---
                    Obx(() {
                      // Check if the avatar path is not empty before trying to load
                      if (controller.userAvatar.value.isNotEmpty) {
                        return CircleAvatar(
                          radius: width * 0.15,
                          backgroundColor: AppColors
                              .surfaceColor, // Background for the circle
                          // Use SvgPicture.asset for SVG images
                          child: ClipOval(
                            // Clip the SVG to the circle shape
                            child: SvgPicture.asset(
                              controller.userAvatar.value,
                              fit: BoxFit.cover, // Cover the circle area
                              width: width *
                                  0.3, // Ensure SVG fills the avatar size
                              height: width * 0.3,
                            ),
                          ),
                        );
                      } else {
                        // Show a placeholder or default avatar if the path is empty
                        return CircleAvatar(
                          radius: width * 0.15,
                          backgroundColor:
                              Colors.grey.shade300, // Placeholder color
                          child: Icon(
                            Icons.person,
                            size: width * 0.15,
                            color: Colors.white,
                          ),
                        );
                      }
                    }),

                    const SizedBox(height: 16.0),

                    // --- User Name (from Controller) ---
                    Obx(() => Text(
                          // Use Obx to react to changes
                          controller.username.value.isNotEmpty
                              ? controller.username.value
                              : "Loading...", // Show loading or default
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: height * 0.028,
                          ),
                          textAlign: TextAlign.center,
                        )),
                    SizedBox(height: height * 0.01),

                    // --- User Email (from Controller) ---
                    Obx(() => Text(
                          // Use Obx to react to changes
                          controller.userEmail.value.isNotEmpty
                              ? controller.userEmail.value
                              : "No email provided", // Show default if empty
                          style: TextStyle(
                            fontSize: height * 0.022,
                          ),
                          textAlign: TextAlign.center,
                        )),
                    SizedBox(height: height * 0.03),

                    // --- Profile Details Card ---
                    Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color:
                          AppColors.surfaceColor, // Use a distinct card color
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            // Use Obx around each row or the value Text for reactivity
                            Obx(() => _buildInfoRow(
                                  context: context,
                                  icon: Icons.person_outline,
                                  label: 'Username',
                                  value: controller.username.value.isNotEmpty
                                      ? controller.username.value
                                      : "N/A",
                                )),
                            Divider(height: height * 0.02),
                            Obx(() => _buildInfoRow(
                                  context: context,
                                  icon: Icons.email_outlined,
                                  label: 'Email',
                                  value: controller.userEmail.value.isNotEmpty
                                      ? controller.userEmail.value
                                      : "N/A",
                                )),
                            const Divider(height: 20),
                            Obx(() => _buildInfoRow(
                                  context: context,
                                  icon: Icons
                                      .wc_outlined, // Example icon for gender
                                  label: 'Gender',
                                  value: controller.userGender.value.isNotEmpty
                                      ? controller.userGender.value
                                      : "Not Specified",
                                )),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.03),

                    // --- Logout Button ---
                    ElevatedButton.icon(
                      icon: const Icon(Icons.logout,
                          color: AppColors.surfaceColor),
                      label: const Text(
                        'Logout',
                        style: TextStyle(
                            fontSize: 16, color: AppColors.surfaceColor),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors
                            .error, // Use error color for logout button
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.15, vertical: height * 0.015),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        elevation: 3,
                      ),
                      onPressed: () {
                        // Show confirmation dialog before logging out
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: AppColors.surfaceColor,
                            title: const Text('Logout',
                                style:
                                    TextStyle(color: AppColors.backgroundDark)),
                            content: const Text(
                                'Are you sure you want to logout?',
                                style:
                                    TextStyle(color: AppColors.backgroundDark)),
                            actions: [
                              TextButton(
                                child: const Text('Cancel',
                                    style: TextStyle(
                                        color: AppColors.backgroundDark)),
                                onPressed: () => Navigator.of(ctx).pop(),
                              ),
                              TextButton(
                                child: const Text('Logout',
                                    style: TextStyle(color: AppColors.orange)),
                                onPressed: () {
                                  Navigator.of(ctx).pop(); // Close dialog first
                                  controller
                                      .logout(); // Call controller's logout method
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(
                        height:
                            height * 0.02), // Add some padding at the bottom
                  ],
                ),
              ),
            );
    });
  }

  // Helper widget for displaying info rows in the card
  Widget _buildInfoRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
  }) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Row(
      children: [
        Icon(icon, color: AppColors.orange, size: width * 0.06),
        SizedBox(width: width * 0.04),
        Expanded(
          // Use Expanded to prevent overflow if value is long
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                    color: AppColors.backgroundDark,
                    fontSize: height * 0.018,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(height: height * 0.002),
              Text(
                value,
                style: TextStyle(
                    color: AppColors.backgroundDark,
                    fontWeight: FontWeight.w500,
                    fontSize: height * 0.018),
                overflow: TextOverflow.ellipsis, // Handle long text
              ),
            ],
          ),
        ),
      ],
    );
  }
}
