import 'package:chat_application_socket_io/cores/app_colors.dart';
import 'package:chat_application_socket_io/features/chat%20list/controller/chat_list_controller.dart';
import 'package:chat_application_socket_io/widgets/chat_list_widget.dart'; // Assuming this widget displays a single chat item
import 'package:chat_application_socket_io/widgets/shimmer_widget.dart'; // Assuming this is the shimmer placeholder for a chat item
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

/// Displays the list of ongoing chats for the logged-in user.
class ChatListView extends StatelessWidget {
  ChatListView({super.key});

  // Initialize the ChatListController using GetX dependency injection.
  final ChatListController controller = Get.put(ChatListController());

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive layout calculations.
    // Consider using LayoutBuilder for more complex responsiveness if needed.
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    // Define standard padding to be reused.
    final EdgeInsets horizontalPadding =
        EdgeInsets.symmetric(horizontal: width * 0.05);
    final double verticalSpacing = height * 0.02; // Standard vertical spacing

    // Obx widget rebuilds when observable variables in the controller change.
    return Obx(
      () => SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.background,
          // Use AppBar for standard top navigation/actions.
          appBar: AppBar(
            backgroundColor: AppColors.background, // Match scaffold background
            elevation: 0, // Remove shadow for a flatter look
            automaticallyImplyLeading: false, // Remove default back button
            title: _buildWelcomeMessage(height), // Welcome message widget
            actions: [
              Padding(
                padding: EdgeInsets.only(right: width * 0.03),
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed('/profileScreen');
                  },
                  child: Container(
                    height: height * 0.05,
                    width: height * 0.05,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: SvgPicture.asset(controller.userAvatar.value),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: width * 0.05),
                child: GestureDetector(
                  onTap: () {
                    // Navigate to the user search view
                    Get.toNamed('/searchView');
                  },
                  child: Container(
                    height: height * 0.05,
                    width: height * 0.05,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.add),
                  ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: horizontalPadding, // Apply horizontal padding
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align children to the start
              children: [
                SizedBox(height: verticalSpacing / 2), // Reduced top spacing

                // Space before the list
                SizedBox(height: verticalSpacing),

                // Conditional UI based on loading state and chat list content
                Obx(
                  () => Expanded(
                    // Use Expanded to make the list take available space
                    child: _buildChatListContent(height, width),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the welcome message RichText widget.
  Widget _buildWelcomeMessage(double height) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: height * 0.022, // Adjusted size
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
          color: AppColors.backgroundDark, // Default text color
        ),
        children: <TextSpan>[
          const TextSpan(text: 'Welcome, '),
          TextSpan(
            // Display the username fetched from the controller
            text: controller.userName.value.isNotEmpty
                ? controller.userName.value
                : 'User', // Fallback text
            style: const TextStyle(
              color: AppColors.orange, // Highlight username
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      overflow: TextOverflow.ellipsis, // Handle long usernames
    );
  }

  /// Builds the main content area: shimmer loader, empty state, or chat list.
  Widget _buildChatListContent(double height, double width) {
    // Wrap the content with RefreshIndicator
    return RefreshIndicator(
      // Set the color of the refresh indicator
      color: AppColors.orange,
      backgroundColor: AppColors.background,
      // Define the action to perform when pulled down
      onRefresh: () => controller.getChatList(),
      child:
          _buildActualContent(height, width), // Build the actual content inside
    );
  }

  /// Builds the content based on loading state and data availability.
  Widget _buildActualContent(double height, double width) {
    if (controller.isLoading.value && controller.chatList.isEmpty) {
      // Show shimmer only if loading and the list is currently empty
      return _buildShimmerEffect(height, width);
    } else if (!controller.isLoading.value && controller.chatList.isEmpty) {
      // Show empty state if not loading and chat list is empty
      // Wrap with ListView to allow scrolling even when empty, enabling pull-to-refresh
      return LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: _buildEmptyState(width),
          ),
        );
      });
    } else {
      return _buildChatList(height);
    }
  }

  /// Builds the shimmer loading effect for the chat list.
  Widget _buildShimmerEffect(double height, double width) {
    return Shimmer.fromColors(
      baseColor: AppColors.textSecondary.withOpacity(0.3), // Softer base
      highlightColor: AppColors.background.withOpacity(0.5), // Softer highlight
      direction: ShimmerDirection.ltr,
      child: ListView.builder(
        itemCount: 10, // Number of shimmer items to display
        itemBuilder: (_, index) {
          return Padding(
            padding: EdgeInsets.symmetric(
                vertical: height * 0.01), // Consistent vertical padding
            // Use the custom shimmer placeholder widget
            child: ShimCon(
              height: height * 0.09, // Slightly taller shimmer item
              width: double.infinity, // Take full width
            ),
          );
        },
      ),
    );
  }

  /// Builds the widget displayed when the chat list is empty.
  Widget _buildEmptyState(double width) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Informative SVG graphic
          SvgPicture.asset(
            'assets/svg/no_data.svg', // Consider a more chat-specific SVG if available
            height: width * 0.6, // Adjusted size
            width: width * 0.6,
          ),
          const SizedBox(height: 20),
          // Informative text
          const Text(
            'No chats yet!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.backgroundDark,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Tap the button below to find someone to chat with.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the actual list of chat items.
  Widget _buildChatList(double height) {
    return ListView.builder(
      physics:
          const AlwaysScrollableScrollPhysics(), // Ensure list is always scrollable for refresh
      itemCount: controller.chatList.length,
      itemBuilder: (context, index) {
        final chatItem = controller.chatList[index];

        // Navigate to the specific chat screen on tap
        return InkWell(
          // Use InkWell for ripple effect on tap
          onTap: () async {
            // Current implementation (saving details directly here):
            final prefs = await SharedPreferences.getInstance();
            prefs.setString('receiver_id', chatItem.id ?? '');
            prefs.setString('receiver_name', chatItem.name ?? '');
            prefs.setString('receiver_mail', chatItem.email ?? '');
            prefs.setString('receiver_gender', chatItem.gender ?? '');
            prefs.setString('receiver_avatar', chatItem.avatar ?? '');
            await controller.disconnectChatListSocket();

            Future.delayed(const Duration(seconds: 1), () {
              // Navigate to the chat screen
              Get.toNamed('/chatScreen');
            });
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: height * 0.002), // Add vertical padding
            // Use the custom widget to display individual chat list item
            child: ChatListWidget(
              context, // Pass context if needed by the widget
              chatItem.name ?? 'Unknown User', // Provide default value
              chatItem.lastMessage ?? '', // Provide default value
              chatItem.lastMessageTime ?? '', // Provide default value
              chatItem.avatar ?? '', // Boolean based on gender
            ),
          ),
        );
      },
    );
  }
}
