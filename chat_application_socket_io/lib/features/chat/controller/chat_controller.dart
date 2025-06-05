import 'package:chat_application_socket_io/features/chat/models/message_model.dart';
import 'package:chat_application_socket_io/services/api_services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatController extends GetxController with WidgetsBindingObserver {
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
  var isInitialScrollDone = false.obs;
  static var _baseUrl = dotenv.env['DEVELOPMENT_URL'];

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    scrollController = ScrollController();
    getInfo();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    scrollController.dispose();
    leaveRoomAndDisconnect();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        print('Chat Socket: App resumed - Reconnecting socket...');
        _shouldReconnect = true;
        if (!_isConnected) {
          getInfo();
          connectSocket();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        print('Chat Socket: App in background/terminated - Disconnecting socket...');
        _shouldReconnect = false;
        leaveRoomAndDisconnect();
        break;
      default:
        break;
    }
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
        connectSocket();
        print('Chat Socket: Initialized with myId: ${myId.value}, receiverId: ${receiverId.value}');
      }
    } catch (e) {
      print('Chat Socket: Error getting user info: $e');
    }
  }

  void connectSocket() {
    if (_isConnected) {
      print('Chat Socket: Already connected, skipping connection');
      return;
    }

    try {
      socket = IO.io('$_baseUrl', <String, dynamic>{
        'transports': ['websocket', 'polling'],
        'autoConnect': false,
        'reconnection': true,
        'reconnectionAttempts': 5,
        'reconnectionDelay': 2000,
        'auth': {'token': token.value},
        'query': {
          'userId': myId.value,
          'receiverId': receiverId.value
        }
      });

      // Remove existing listeners to prevent duplicates
      socket.off('connect');
      socket.off('connect_error');
      socket.off('disconnect');
      socket.off('message');
      socket.off('typing');
      socket.off('stop_typing');
      socket.off('total_clients');

      socket.onConnect((_) {
        print('Chat Socket: Connected successfully');
        _isConnected = true;
        joinRoom();
      });

      socket.onConnectError((error) {
        print('Chat Socket: Connection error - $error');
        _isConnected = false;
        if (_shouldReconnect) {
          Future.delayed(const Duration(seconds: 3), () { 
            if (!_isConnected && _shouldReconnect) {
              print('Chat Socket: Attempting reconnect after error...');
              socket.connect();
            }
          });
        }
      });

      socket.onDisconnect((_) {
        print('Chat Socket: Disconnected');
        _isConnected = false;
        isOnline.value = false;
        if (_shouldReconnect) {
          Future.delayed(const Duration(seconds: 2), () {
            if (!_isConnected && _shouldReconnect) {
              print('Chat Socket: Attempting reconnect after disconnect...');
              connectSocket();
            }
          });
        }
      });

      // Event listeners
      socket.on('message', (data) {
        if (data['sender'] != myId.value) {
          messages.add(Message.fromJson(data));
          messageCount.value = messages.length;
          scrollToBottom();
        }
      });

      socket.on('typing', (_) => isTyping.value = true);
      socket.on('stop_typing', (_) => isTyping.value = false);
      socket.on('total_clients', (count) => isOnline.value = count > 1);

      print('Chat Socket: Attempting to connect...');
      socket.connect();
    } catch (e) {
      print('Chat Socket: Error creating socket - $e');
      _isConnected = false;
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
        print('Socket not connected, attempting to reconnect...');
        connectSocket();
        Future.delayed(Duration(seconds: 1), () {
          if (_isConnected) _sendMessageImpl();
        });
        return;
      }

      _sendMessageImpl();
      scrollToBottom();
    }
  }

  void _sendMessageImpl() {
    String roomID = myId.value.compareTo(receiverId.value) < 0
        ? '${myId.value}-${receiverId.value}'
        : '${receiverId.value}-${myId.value}';

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

    socket.emit('sendMessage', {
      'sender': myId.value,
      'receiver': receiverId.value,
      'content': newMessage.value,
      'roomID': roomID,
      'createdAt': createdAt,
    });

    stopTyping();
    newMessage.value = '';
  }

  Future<void> leaveRoomAndDisconnect() async {
    _shouldReconnect = false;
    if (_currentRoomID != null && _isConnected) {
      try {
        print('Chat Socket: Leaving room - $_currentRoomID');
        socket.emit('leaveRoom', {
          'roomID': _currentRoomID,
          'userId': myId.value
        });
        _currentRoomID = null;
        stopTyping();
        await disconnectSocket();
      } catch (e) {
        print('Chat Socket: Error during room cleanup - $e');
      }
    }
  }

  Future<void> disconnectSocket() async {
    if (_isConnected) {
      try {
        await socket.disconnect();
        _isConnected = false;
        isOnline.value = false;
        print('Chat Socket: Disconnected manually');
      } catch (e) {
        print('Chat Socket: Error during disconnect - $e');
      }
    }
  }

  Future<void> fetchOldMessages() async {
    isLoading.value = true;
    try {
      dynamic fetchedMessages = await apiService.fetchMessages(
          myId.value, receiverId.value, token.value);

      if (fetchedMessages['messages'] != null) {
        List<Message> oldMessages = (fetchedMessages['messages'] as List)
            .map((item) => Message.fromJson(item as Map<String, dynamic>))
            .toList();

        messages.assignAll(oldMessages);
        messageCount.value = messages.length;

        // Schedule scroll after build
        if (!isInitialScrollDone.value && messages.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            scrollToBottom(animate: false);
            isInitialScrollDone.value = true;
          });
        }
      } else {
        messages.value = [];
      }
    } catch (e) {
      print('Error fetching old messages: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void scrollToBottom({bool animate = true}) {
    if (!scrollController.hasClients) return;

    if (animate) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
  }

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
