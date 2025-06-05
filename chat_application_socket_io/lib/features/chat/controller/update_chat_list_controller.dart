import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';

class UpdateChatListController extends GetxController
    with WidgetsBindingObserver {
  var receiverId = ''.obs;
  var myId = ''.obs;
  late IO.Socket chatListSocket;
  var isConnected = false.obs;
  bool _shouldReconnect = true;
  static var _baseUrl = "https://chat-app-3m6o.onrender.com";

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
        print('UpdateChatList Socket: App resumed');
        if (receiverId.value.isNotEmpty) {
          print(
              'UpdateChatList Socket: Reconnecting to receiver ${receiverId.value}');
          _shouldReconnect = true;
          if (!isConnected.value) {
            connectSocket();
          }
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        print(
            'UpdateChatList Socket: App in background/terminated - Disconnecting socket...');
        _shouldReconnect = false;
        disconnectChatListSocket();
        break;
      default:
        break;
    }
  }

  Future<void> close() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('receiver_id', '');
  }

  Future<void> getInfo() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      receiverId.value = prefs.getString('receiver_id') ?? '';
      myId.value = prefs.getString('userId') ?? '';

      if (receiverId.value.isNotEmpty && myId.value.isNotEmpty) {
        print(
            'UpdateChatList Socket: Initializing with receiverId: ${receiverId.value}');
        connectSocket();
      } else {
        print(
            'UpdateChatList Socket: Missing user info - receiverId: ${receiverId.value}, myId: ${myId.value}');
      }
    } catch (e) {
      print('UpdateChatList Socket: Error getting user info - $e');
    }
  }

  void connectSocket() {
    if (isConnected.value) {
      print('UpdateChatList Socket: Already connected, skipping connection');
      return;
    }

    if (receiverId.value.isEmpty || myId.value.isEmpty) {
      print(
          'UpdateChatList Socket: Missing receiverId or myId, cannot connect');
      return;
    }

    try {
      chatListSocket = IO.io('$_baseUrl/chatlist/', <String, dynamic>{
        'transports': ['websocket', 'polling'],
        'autoConnect': false,
        'reconnection': true,
        'reconnectionAttempts': 5,
        'reconnectionDelay': 2000,
        'query': {
          'targetUserId': receiverId
              .value, // Explicitly specify we want to connect to receiver's room
          'myId': myId.value
        }
      });

      chatListSocket.onConnect((_) {
        print('UpdateChatList Socket: Connected to chatlist namespace');
        isConnected.value = true;
        _shouldReconnect = true;
        joinReceiverRoom();
      });

      chatListSocket.onConnectError((error) {
        print('UpdateChatList Socket: Connection Error - $error');
        isConnected.value = false;
        if (_shouldReconnect) {
          Future.delayed(const Duration(seconds: 3), () {
            if (!isConnected.value && _shouldReconnect) {
              print('UpdateChatList Socket: Attempting manual reconnect...');
              chatListSocket.connect();
            }
          });
        }
      });

      chatListSocket.onDisconnect((_) {
        print('UpdateChatList Socket: Disconnected');
        isConnected.value = false;
        if (_shouldReconnect) {
          Future.delayed(const Duration(seconds: 2), () {
            if (_shouldReconnect) connectSocket();
          });
        }
      });

      chatListSocket.on('updateChatList', (_) {
        print(
            'UpdateChatList Socket: Received updateChatList event for room: ${receiverId.value}');
      });

      chatListSocket.onError((error) {
        print('UpdateChatList Socket: Error - $error');
        isConnected.value = false;
      });

      print(
          'UpdateChatList Socket: Attempting to connect to chatlist namespace...');
      chatListSocket.connect();
    } catch (e) {
      print('UpdateChatList Socket: Error creating socket - $e');
      isConnected.value = false;
    }
  }

  void joinReceiverRoom() {
    if (!isConnected.value || receiverId.value.isEmpty) {
      print(
          'UpdateChatList Socket: Cannot join room - Socket not connected or receiverId missing');
      return;
    }

    try {
      print(
          'UpdateChatList Socket: Joining receiver room: ${receiverId.value}');
      chatListSocket.emit('joinRoom', {
        'userId': receiverId.value, // Always join receiver's room
        'source': 'chatlist_update' // Add context for debugging
      });
    } catch (e) {
      print('UpdateChatList Socket: Error joining receiver room - $e');
    }
  }

  void sendMessage() {
    if (!isConnected.value) {
      print('UpdateChatList Socket: Not connected, attempting to reconnect');
      connectSocket();
      Future.delayed(Duration(seconds: 1), () {
        if (isConnected.value) {
          _sendMessageImpl();
        } else {
          print('UpdateChatList Socket: Failed to connect, message not sent');
        }
      });
      return;
    }
    _sendMessageImpl();
  }

  void _sendMessageImpl() {
    if (receiverId.value.isEmpty) {
      print('UpdateChatList Socket: receiverId is empty, cannot send message');
      return;
    }

    try {
      print(
          'UpdateChatList Socket: Sending update notification to receiver: ${receiverId.value}');
      chatListSocket.emit("sendMessage",
          {"userId": receiverId.value, "source": "chatlist_update"});
      print('UpdateChatList Socket: Update notification sent');
    } catch (e) {
      print('UpdateChatList Socket: Error sending message - $e');
    }
  }

  Future<void> disconnectChatListSocket() async {
    _shouldReconnect = false;
    if (isConnected.value) {
      try {
        if (receiverId.value.isNotEmpty) {
          print(
              'UpdateChatList Socket: Leaving receiver room: ${receiverId.value}');
          chatListSocket.emit('leaveRoom',
              {'userId': receiverId.value, 'source': 'chatlist_update'});
        }
        await chatListSocket.disconnect();
        isConnected.value = false;
        print('UpdateChatList Socket: Disconnected from chatlist namespace');
      } catch (e) {
        print('UpdateChatList Socket: Error during disconnect - $e');
      }
    }
  }
}
