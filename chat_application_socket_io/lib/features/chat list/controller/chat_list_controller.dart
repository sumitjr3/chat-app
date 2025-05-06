import 'package:chat_application_socket_io/features/chat%20list/model/chat_list_model.dart';
import 'package:get/get.dart';
import '../../../services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatListController extends GetxController {
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var userId = ''.obs;
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userImage = ''.obs;
  var userToken = ''.obs;
  var userAvatar = ''.obs;
  var chatList = <ChatListModel>[].obs;
  final ApiServices _apiServices = ApiServices();

  // Socket related variables
  late IO.Socket chatListSocket;
  bool _isConnected = false;
  bool _shouldReconnect = true; // Flag to control reconnection
  static var _baseUrl = dotenv.env['DEVELOPMENT_URL'];

  @override
  void onInit() {
    super.onInit();
    getInfo();
  }

  Future<void> getInfo() async {
    final prefs = await SharedPreferences.getInstance();
    userId.value = prefs.getString('userId') ?? '';
    userName.value = prefs.getString('username') ?? '';
    userEmail.value = prefs.getString('email') ?? '';
    userToken.value = prefs.getString('token') ?? '';
    userAvatar.value = prefs.getString('avatar') ?? '';

    if (userId.value.isNotEmpty && userToken.value.isNotEmpty) {
      // Fetch initial list via HTTP
      await getChatList();
      // Connect to the socket for real-time updates
      connectChatListSocket();
    } else {
      isLoading.value = false; // Stop loading if no user info
      errorMessage(
          'User information not found. Cannot fetch chat list or connect socket.');
    }
  }

  @override
  void onClose() {
    disconnectChatListSocket();
    super.onClose();
  }

  void connectChatListSocket() {
    if (_isConnected || userId.value.isEmpty)
      return; // Don't connect if already connected or no userId

    // Connect to the specific namespace for chat list
    chatListSocket = IO.io('$_baseUrl/chatlist/', <String, dynamic>{
      'transports': ['websocket', 'polling'],
      'autoConnect': false, // Connect manually after setting up listeners
      'reconnection': true,
      'reconnectionAttempts': 5,
      'reconnectionDelay': 2000,
      // Add authentication if needed, e.g., query parameters or headers
      // 'query': {'token': userToken.value}
    });

    // --- Standard Listeners ---
    chatListSocket.onConnect((_) {
      print('ChatList Socket:----------------------------> Connected');
      _isConnected = true;
      _shouldReconnect =
          true; // Allow reconnection attempts if disconnected later
      joinChatListRoom(); // Join the user-specific room
    });

    chatListSocket.onConnectError((error) {
      print(
          'ChatList Socket: ---------------------------->Connection Error: $error');
      // Optionally attempt manual reconnection or show an error
      if (_shouldReconnect) {
        // Consider adding a delay before retrying
        Future.delayed(const Duration(seconds: 5), () {
          if (!_isConnected && _shouldReconnect) {
            // Check again before connecting
            print(
                'ChatList Socket: ---------------------------->Attempting manual reconnect...');
            chatListSocket.connect();
          }
        });
      }
    });

    chatListSocket.onDisconnect((_) {
      print('ChatList Socket: ---------------------------->Disconnected');
      _isConnected = false;
      // Attempt to reconnect if not intentionally disconnected
      if (_shouldReconnect) {
        print(
            'ChatList Socket:----------------------------> Attempting reconnect on disconnect...');
        // Socket.IO client handles automatic reconnection based on options
        // If auto-reconnect fails, you might need manual intervention here
      }
    });

    // --- Custom Event Listeners ---
    chatListSocket.on('updateChatList', (_) {
      print(
          'ChatList Socket:----------------------------> Received updateChatList event. Refreshing list...');
      getChatList(); // Refresh the chat list when notified
    });

    chatListSocket.onError((error) {
      print('ChatList Socket:----------------------------> Error: $error');
      // Handle specific errors if needed
    });

    // --- Connect ---
    chatListSocket.connect();
  }

  void joinChatListRoom() {
    if (_isConnected && userId.value.isNotEmpty) {
      chatListSocket.emit('joinRoom', {'userId': userId.value});
      print(
          'ChatList Socket: ---------------------------->Joining room for user ${userId.value}');
    } else {
      print(
          'ChatList Socket: ---------------------------->Cannot join room. Socket not connected or userId missing.');
    }
  }

  Future<void> getChatList() async {
    try {
      isLoading.value = true;
      final response =
          await _apiServices.getChatList(userId.value, userToken.value);

      if (response['length'] > 0) {
        chatList.value = List<Map<String, dynamic>>.from(response['data'])
            .map((json) => ChatListModel.fromJson(json))
            .toList();
      } else {
        chatList.value = [];
      }
    } catch (e) {
      errorMessage('Error: $e');
      chatList.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> disconnectChatListSocket() async {
    _shouldReconnect =
        false; // Prevent reconnection attempts on manual disconnect
    if (_isConnected) {
      if (userId.value.isNotEmpty) {
        // Optionally tell the server the user is leaving the room
        chatListSocket.emit('leaveRoom', {'userId': userId.value});
        print(
            'ChatList Socket: ---------------------------->Leaving room for user ${userId.value}');
      }
      await chatListSocket.disconnect();
      print(
          'ChatList Socket:----------------------------> Disconnected manually.');
    }
  }
}
