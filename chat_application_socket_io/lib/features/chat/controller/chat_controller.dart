import 'package:chat_application_socket_io/services/chat_service.dart';
import 'package:chat_application_socket_io/services/message_service.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final ChatService chatService = ChatService();
  final MessageService messageService = MessageService();
  var messages = <dynamic>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  late String roomID;

  @override
  void onInit() {
    super.onInit();
    // Generate roomID using sender and receiver IDs in a consistent order
    roomID =
        Get.arguments['senderId'].compareTo(Get.arguments['receiverId']) < 0
            ? '${Get.arguments['senderId']}-${Get.arguments['receiverId']}'
            : '${Get.arguments['receiverId']}-${Get.arguments['senderId']}';

    // Connect to the chat service if not already connected
    if (!chatService.isConnected) {
      chatService.connect(onConnect: () {
        // Join the chat room once connected
        chatService.joinRoom(roomID);
        fetchMessages();
      });
    } else {
      // If already connected, join the room directly
      chatService.joinRoom(roomID);
      fetchMessages();
    }

    // Listen for real-time incoming messages
    chatService.listenForMessages((sender, content) {
      messages.add({'sender': sender, 'content': content});
    });
  }

  Future<void> fetchMessages() async {
    try {
      var fetchedMessages = await messageService.fetchMessages(
          Get.arguments['senderId'], Get.arguments['receiverId']);
      messages.assignAll(fetchedMessages);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void sendMessage(String message) {
    if (message.isEmpty) return; // Prevent sending empty messages

    if (chatService.socket.connected) {
      chatService.sendMessage(
          Get.arguments['senderId'], Get.arguments['receiverId'], message);
    } else {
      errorMessage.value = 'Socket not connected, message not sent';
    }
  }

  @override
  void onClose() {
    // Leave the room but don't disconnect the socket
    chatService.leaveRoomAndDisconnect();
    super.onClose();
  }
}
