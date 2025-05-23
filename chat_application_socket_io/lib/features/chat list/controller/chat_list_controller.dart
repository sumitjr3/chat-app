import 'package:chat_application_socket_io/features/chat%20list/model/chat_list_model.dart';
import 'package:get/get.dart';
import '../../../services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';

class ChatListController extends GetxController with WidgetsBindingObserver {
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
  var isConnected = false.obs;
  bool _shouldReconnect = true;
  static var _baseUrl = dotenv.env['DEVELOPMENT_URL'];

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    getInfo();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    disconnectChatListSocket();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        print('ChatList Socket: App resumed - Reconnecting socket...');
        _shouldReconnect = true;
        getInfo(); // This will reinitialize socket if needed
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        print(
            'ChatList Socket: App in background/terminated - Disconnecting socket...');
        _shouldReconnect = false;
        disconnectChatListSocket();
        break;
      default:
        break;
    }
  }

  Future<void> getInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      userId.value = prefs.getString('userId') ?? '';
      userName.value = prefs.getString('username') ?? '';
      userEmail.value = prefs.getString('email') ?? '';
      userToken.value = prefs.getString('token') ?? '';
      userAvatar.value = prefs.getString('avatar') ?? '';

      if (userId.value.isNotEmpty && userToken.value.isNotEmpty) {
        await getChatList();
        if (!isConnected.value) {
          connectChatListSocket();
        }
      } else {
        isLoading.value = false;
        errorMessage(
            'User information not found. Cannot fetch chat list or connect socket.');
      }
    } catch (e) {
      print('ChatList Socket: Error in getInfo - ${e.toString()}');
      isLoading.value = false;
      errorMessage('Error initializing: ${e.toString()}');
    }
  }

  void connectChatListSocket() {
    if (isConnected.value || userId.value.isEmpty) return;

    try {
      chatListSocket = IO.io('$_baseUrl/chatlist/', <String, dynamic>{
        'transports': ['websocket', 'polling'],
        'autoConnect': false,
        'reconnection': true,
        'reconnectionAttempts': 5,
        'reconnectionDelay': 2000,
        'auth': {'token': userToken.value},
        'query': {'userId': userId.value}
      });

      chatListSocket.onConnect((_) {
        print('ChatList Socket: Connected');
        isConnected.value = true;
        _shouldReconnect = true;
        joinChatListRoom();
      });

      chatListSocket.onConnectError((error) {
        print('ChatList Socket: Connection Error - $error');
        isConnected.value = false;
        if (_shouldReconnect) {
          Future.delayed(const Duration(seconds: 3), () {
            if (!isConnected.value && _shouldReconnect) {
              print('ChatList Socket: Attempting manual reconnect...');
              chatListSocket.connect();
            }
          });
        }
      });

      chatListSocket.onDisconnect((_) {
        print('ChatList Socket: Disconnected');
        isConnected.value = false;
        if (_shouldReconnect) {
          print('ChatList Socket: Attempting reconnect on disconnect...');
          Future.delayed(const Duration(seconds: 2), () {
            if (_shouldReconnect) connectChatListSocket();
          });
        }
      });

      chatListSocket.on('updateChatList', (_) {
        print('ChatList Socket: Received updateChatList event');
        getChatList();
      });

      chatListSocket.onError((error) {
        print('ChatList Socket: Error - $error');
        errorMessage.value = 'Socket Error: $error';
      });

      chatListSocket.connect();
    } catch (e) {
      print('ChatList Socket: Error creating socket - ${e.toString()}');
      errorMessage.value = 'Error creating socket: ${e.toString()}';
    }
  }

  void joinChatListRoom() {
    if (isConnected.value && userId.value.isNotEmpty) {
      chatListSocket.emit('joinRoom', {'userId': userId.value});
      print('ChatList Socket: Joining room for user ${userId.value}');
    } else {
      print(
          'ChatList Socket: Cannot join room. Socket not connected or userId missing.');
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
    _shouldReconnect = false;
    if (isConnected.value) {
      try {
        if (userId.value.isNotEmpty) {
          chatListSocket.emit('leaveRoom', {'userId': userId.value});
          print('ChatList Socket: Leaving room for user ${userId.value}');
        }
        await chatListSocket.disconnect();
        isConnected.value = false;
        print('ChatList Socket: Disconnected manually');
      } catch (e) {
        print('ChatList Socket: Error during disconnect - ${e.toString()}');
      }
    }
  }
}
