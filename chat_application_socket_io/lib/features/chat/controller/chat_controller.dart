import 'package:chat_application_socket_io/features/chat/model/message_model.dart';
import 'package:chat_application_socket_io/services/chat_service.dart';
import 'package:chat_application_socket_io/services/message_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatController extends GetxController {
  final ChatService chatService = ChatService();
  final MessageService messageService = MessageService();
  var receiverName = ''.obs;
  var receiverId = ''.obs;
  var myId = ''.obs;
  var receiverPhone = ''.obs;
  var contractCount = 0.obs;
  var token = ''.obs;
  var messages = <Message>[].obs;
  var newMessage = ''.obs;
  var messageCount = 0.obs;
  var isLoading = false.obs; // Added isLoading variable
  late IO.Socket socket;
  bool _isConnected = false;
  String? _currentRoomID;
  bool _shouldReconnect = true; // Flag to control reconnection
  late ScrollController scrollController; // Add ScrollController

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchOldMessages() async {
    isLoading.value = true;
    try {
      String roomID = myId.value.compareTo(receiverId.value) < 0
          ? '${myId.value}-${receiverId.value}'
          : '${receiverId.value}-${myId.value}';
      List<Message> oldMessages =
          await messageService.fetchMessages(myId.value, receiverId.value);
      messages.assignAll(oldMessages);
      messageCount.value = messages.length;
      scrollToBottom(); // Scroll to bottom when old messages are fetched
    } catch (e) {
      print('Error fetching old messages: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }
  //new code

  void connectSocket() {
    if (!_isConnected) {
      socket = IO.io('https://chat-app-0mkv.onrender.com', <String, dynamic>{
        'transports': ['websocket', 'polling'],
        'autoConnect': false,
        'reconnection': true,
        'reconnectionAttempts': 5,
        'reconnectionDelay': 2000,
      });

      // Remove existing listeners
      socket.off('connect');
      socket.off('connect_error');
      socket.off('disconnect');

      socket.on('connect', (_) {
        print('Connected to WebSocket server');
        _isConnected = true;
        joinRoom();
      });

      socket.on('connect_error', (error) {
        print('Connection error: $error');
        if (_shouldReconnect) {
          reconnect();
        }
      });

      socket.on('disconnect', (_) {
        print('Disconnected from WebSocket server');
        _isConnected = false;
        if (_shouldReconnect) {
          reconnect();
        }
      });

      socket.connect();
    }
  }

  void reconnect() {
    if (_isConnected) {
      socket.disconnect();
      print('Disconnecting');
    }
    if (!_isConnected) {
      print('Attempting to reconnect...');
      socket.connect();
      connectSocket();
    }
  }

  void joinRoom() {
    String roomID = myId.value.compareTo(receiverId.value) < 0
        ? '${myId.value}-${receiverId.value}'
        : '${receiverId.value}-${myId.value}';
    _currentRoomID = roomID;

    if (!_isConnected) {
      print('Socket not connected, cannot join room');
      return;
    }

    socket.emit('joinRoom', {'roomID': roomID});
    print('Joined room: $roomID');

    socket.on('message', (data) {
      String sender = data['sender'];
      String content = data['content'];
      String createdAt = data['createdAt'];
      if (sender != myId.value) {
        messages.add(Message.fromJson(data));
        messageCount.value = messages.length;
        scrollToBottom(); // Scroll to bottom when a new message is received
      }
    });

    socket.on('joinRoom_error', (error) {
      print('Error joining room: $error');
    });
  }

  void sendMessage() {
    if (newMessage.value.isNotEmpty) {
      String roomID = myId.value.compareTo(receiverId.value) < 0
          ? '${myId.value}-${receiverId.value}'
          : '${receiverId.value}-${myId.value}';

      if (!_isConnected) {
        print('Socket not connected, cannot send message');
        return;
      }

      String createdAt = DateTime.now().toIso8601String();
      Message message = Message(
        id: '',
        sender: myId.value,
        receiver: receiverId.value,
        content: newMessage.value,
        roomID: roomID,
        createdAt: DateTime.now(),
      );
      messages.add(message);
      messageCount.value = messages.length;
      print('msg sent 1');

      socket.emit('sendMessage', {
        'sender': myId.value,
        'receiver': receiverId.value,
        'content': newMessage.value,
        'roomID': roomID,
        'createdAt': createdAt,
      });
      print('msg sent 2');
      newMessage.value = '';
      scrollToBottom(); // Scroll to bottom when a message is sent
    }
  }

  void leaveRoomAndDisconnect() {
    _shouldReconnect = false;
    if (_currentRoomID != null && _isConnected) {
      print('Leaving room: $_currentRoomID');
      socket.emit('leaveRoom', {'roomID': _currentRoomID});
      _currentRoomID = null;
    }

    if (_isConnected) {
      socket.disconnect();
      print('Socket disconnected manually');
    }
  }

  void disconnectSocket() {
    if (_isConnected) {
      socket.disconnect();
      print('Socket disconnected manually');
    }
  }
}
