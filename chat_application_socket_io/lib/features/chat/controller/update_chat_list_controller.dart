import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UpdateChatListController extends GetxController {
  var receiverId = ''.obs;
  var myId = ''.obs;
  late IO.Socket chatListSocket;
  bool _isConnected = false;
  bool _shouldReconnect = true; // Flag to control reconnection
  static var _baseUrl = dotenv.env['DEVELOPMENT_URL'];

  @override
  void onInit() {
    super.onInit();
    getInfo();
  }

  @override
  void onClose() {
    super.onClose();
    disconnectChatListSocket();
    // close();
  }

  Future<void> close() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('receiver_id', '');
  }

  Future<void> getInfo() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      receiverId.value = prefs.getString('receiver_id') ?? '';
      myId.value = prefs.getString('userId') ?? '';

      if (receiverId.value.isNotEmpty && myId.value.isNotEmpty) {
        connectSocket();
      }
    } catch (e) {
      print(
          'updatechatlist---------------------------->Error getting user info: $e');
    }
  }

  void connectSocket() {
    if (_isConnected) {
      print('updatechatlist---------------------------->Already connected, skipping connection');
      return;
    }

    if (receiverId.value.isEmpty || myId.value.isEmpty) {
      print('updatechatlist---------------------------->Missing receiverId or myId, cannot connect');
      return;
    }

    chatListSocket = IO.io('$_baseUrl/chatlist/', <String, dynamic>{
      'transports': ['websocket', 'polling'],
      'autoConnect': false,
      'reconnection': true,
      'reconnectionAttempts': 5,
      'reconnectionDelay': 2000,
    });

    chatListSocket.onConnect((_) {
      print('updatechatlist---------------------------->ChatList Socket: Connected');
      _isConnected = true;
      _shouldReconnect = true;
      joinRoom();
    });

    chatListSocket.onConnectError((error) {
      print('updatechatlist---------------------------->ChatList Socket: Connection Error: $error');
      _isConnected = false;
      if (_shouldReconnect) {
        Future.delayed(const Duration(seconds: 5), () {
          if (!_isConnected && _shouldReconnect) {
            print('updatechatlist---------------------------->ChatList Socket: Attempting manual reconnect...');
            chatListSocket.connect();
          }
        });
      }
    });

    chatListSocket.onDisconnect((_) {
      print('updatechatlist---------------------------->ChatList Socket: Disconnected');
      _isConnected = false;
      if (_shouldReconnect) {
        print('updatechatlist---------------------------->ChatList Socket: Attempting reconnect on disconnect...');
        Future.delayed(const Duration(seconds: 2), () {
          if (!_isConnected && _shouldReconnect) {
            chatListSocket.connect();
          }
        });
      }
    });

    // Add specific listener for updateChatList event for debugging
    chatListSocket.on('updateChatList', (_) {
      print('updatechatlist---------------------------->Received updateChatList event');
      // You might want to trigger a chat list refresh here if needed
    });

    chatListSocket.onError((error) {
      print('updatechatlist---------------------------->ChatList Socket: Error: $error');
      _isConnected = false;
    });

    print('updatechatlist---------------------------->Attempting to connect to chat list socket');
    chatListSocket.connect();
  }

  // void startTyping() {
  //   if (_currentRoomID != null && _isConnected) {
  //     socket.emit('typing', {'roomID': _currentRoomID, 'userId': myId.value});
  //   }
  // }

  // void stopTyping() {
  //   if (_currentRoomID != null && _isConnected) {
  //     socket.emit(
  //         'stop_typing', {'roomID': _currentRoomID, 'userId': myId.value});
  //   }
  // }

  void joinRoom() {
    if (_isConnected) {
      chatListSocket.emit('joinRoom', {'userId': receiverId.value});
      print(
          'updatechatlist---------------------------->Joined room: ${receiverId.value}');
    } else {
      print(
          'updatechatlist---------------------------->ChatList Socket: Cannot join room. Socket not connected or userId missing.');
    }
  }

  void sendMessage() {
    if (!_isConnected) {
      print('updatechatlist---------------------------->Socket not connected, attempting to reconnect');
      connectSocket();
      Future.delayed(Duration(seconds: 1), () {
        if (_isConnected) {
          _sendMessageImpl();
        } else {
          print('updatechatlist---------------------------->Failed to connect, message not sent');
        }
      });
      return;
    }
    _sendMessageImpl();
  }

  void _sendMessageImpl() {
    if (receiverId.value.isEmpty) {
      print('updatechatlist---------------------------->receiverId is empty, cannot send message');
      return;
    }
    
    print('updatechatlist---------------------------->Sending message to update chat list for user: ${receiverId.value}');
    chatListSocket.emit("sendMessage", {"userId": receiverId.value});
    print('updatechatlist---------------------------->Message sent to chatlist socket');
  }

  void disconnectChatListSocket() {
    _shouldReconnect =
        false; // Prevent reconnection attempts on manual disconnect
    if (_isConnected) {
      if (myId.value.isNotEmpty) {
        // Optionally tell the server the user is leaving the room
        chatListSocket.emit('leaveRoom', {'userId': receiverId.value});
        print(
            'updatechatlist---------------------------->ChatList Socket: Leaving room for user ${receiverId.value}');
      }
      chatListSocket.disconnect();
      print(
          'updatechatlist---------------------------->ChatList Socket: Disconnected manually.');
    }
  }
}
