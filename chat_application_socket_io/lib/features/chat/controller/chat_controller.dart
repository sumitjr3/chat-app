import 'package:chat_application_socket_io/features/chat/models/message_model.dart';
import 'package:chat_application_socket_io/services/api_services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatController extends GetxController {
  var receiverName = ''.obs;
  var receiverId = ''.obs;
  var myId = ''.obs;
  var receiverEmail = ''.obs;
  var receiverGender = ''.obs;
  var receiverAvatar = ''.obs;
  var count = 0.obs;
  var token = ''.obs;
  var messages = <Message>[].obs;
  var newMessage = ''.obs;
  var messageCount = 0.obs;
  var isLoading = false.obs;

  late IO.Socket socket;
  final ApiServices apiService = ApiServices();
  final Uuid _uuid = const Uuid();
  bool _isConnected = false;
  var isOnline = false.obs;
  var isTyping = false.obs;
  String? _currentRoomID;
  bool _shouldReconnect = true; // Flag to control reconnection
  late ScrollController scrollController;
  bool _isInitialLoad = true;
  static var _baseUrl = dotenv.env['DEVELOPMENT_URL'];

  @override
  void onInit() {
    super.onInit();
    getInfo();
    connectSocket();
  }

  @override
  void onClose() {
    super.onClose();
    leaveRoomAndDisconnect();
    // close();
  }

  Future<void> close() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('receiver_name', '');
    prefs.setString('receiver_mail', '');
    prefs.setString('receiver_id', '');
    prefs.setString('receiver_gender', '');
  }

  Future<void> getInfo() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      receiverName.value = prefs.getString('receiver_name') ?? '';
      receiverEmail.value = prefs.getString('receiver_mail') ?? '';
      receiverId.value = prefs.getString('receiver_id') ?? '';
      receiverGender.value = prefs.getString('receiver_gender') ?? '';
      receiverAvatar.value = prefs.getString('receiver_avatar') ?? '';
      myId.value = prefs.getString('userId') ?? '';
      token.value = prefs.getString('token') ?? '';

      if (receiverId.value.isNotEmpty &&
          receiverName.value.isNotEmpty &&
          myId.value.isNotEmpty &&
          token.value.isNotEmpty) {
        await fetchOldMessages();
        print('---------------------------------myid:- ${myId.value}');
        print('---------------------------------rid:- ${receiverId.value}');
        print('---------------------------------token:- ${token.value}');

        print('--------------------------------everything cool');
      }
    } catch (e) {
      print('Error getting user info: $e');
    }
  }

  void connectSocket() {
    if (!_isConnected) {
      socket = IO.io('$_baseUrl', <String, dynamic>{
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
        print('Connected to WebSocket.');
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
      socket.on('typing', (userId) {
        isTyping.value = true;
      });
      socket.on('stop_typing', (userId) {
        isTyping.value = false;
      });
      socket.on('message', (data) {
        String sender = data['sender'];
        if (sender != myId.value) {
          messages.add(Message.fromJson(data));
          messageCount.value = messages.length;
          // scrollToBottom();
        }
      });
      socket.on('total_clients', (count) {
        count > 1 ? isOnline.value = true : isOnline.value = false;
      });
      socket.connect();
    }
  }

  void startTyping() {
    if (_currentRoomID != null && _isConnected) {
      socket.emit('typing', {'roomID': _currentRoomID, 'userId': myId.value});
    }
  }

  void stopTyping() {
    if (_currentRoomID != null && _isConnected) {
      socket.emit(
          'stop_typing', {'roomID': _currentRoomID, 'userId': myId.value});
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
      //recently commented
      // connectSocket();
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

    socket.emit('joinRoom', {'roomID': roomID, 'userId': myId.value});
    print('Joined room: $roomID');

    // socket.on('message', (data) {
    //   String sender = data['sender'];
    //   String content = data['content'];
    //   String createdAt = data['createdAt'];
    //   if (sender != myId.value) {
    //     messages.add(Message.fromJson(data));
    //     messageCount.value = messages.length;
    //     scrollToBottom(); // Scroll to bottom when a new message is received
    //   }
    // });

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
        id: _uuid.v4(),
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
      stopTyping();
      print('msg sent 2');
      newMessage.value = '';
      // scrollToBottom(); // Scroll to bottom when a message is sent
    }
  }

  void leaveRoomAndDisconnect() {
    _shouldReconnect = false;
    if (_currentRoomID != null && _isConnected) {
      print('Leaving room: $_currentRoomID');
      socket
          .emit('leaveRoom', {'roomID': _currentRoomID, 'userId': myId.value});
      _currentRoomID = null;
      stopTyping();
    }
    disconnectSocket();
  }

  void disconnectSocket() {
    if (_isConnected) {
      socket.disconnect();
      print('Socket disconnected manually');
    }
  }

  Future<void> fetchOldMessages() async {
    isLoading.value = true;
    try {
      dynamic fetchedMessages = await apiService.fetchMessages(
          myId.value, receiverId.value, token.value);

      if (fetchedMessages['messages'] != null) {
        print(fetchedMessages.toString());

        // Explicitly cast each item to Message
        List<Message> oldMessages = (fetchedMessages['messages'] as List)
            .map((item) => Message.fromJson(item as Map<String, dynamic>))
            .toList();

        messages.assignAll(oldMessages);
      } else {
        print('--------------------------------------empty');
        messages.value = [];
      }
      messageCount.value = messages.length;
    } catch (e) {
      print('Error fetching old messages: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // void scrollToBottom() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     scrollController.jumpTo(scrollController.position.maxScrollExtent);
  //   });
  // }

  void refreshChats() async {
    isLoading.value = true;
    try {
      dynamic fetchedMessages = await apiService.fetchMessages(
          myId.value, receiverId.value, token.value);
      if (fetchedMessages['messages'] != null) {
        print(fetchedMessages.toString());
        List<Message> oldMessages = fetchedMessages['messages']
            .map((item) => Message.fromJson(item))
            .toList();
        messages.assignAll(oldMessages);
      } else {
        messages.value = [];
      }
      // messages.assignAll(oldMessages);
      messageCount.value = messages.length;
      // scrollToBottom();
    } catch (e) {
      print('Error refreshing chats: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
