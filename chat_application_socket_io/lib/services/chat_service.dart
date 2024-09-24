import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatService {
  late IO.Socket socket;
  bool _isConnected = false;
  String? _currentRoomID;

  void connect({required Function onConnect, Function? onDisconnect}) {
    // Check if socket is null or not connected, then initialize
    if (!(_isConnected)) {
      // Establish connection to the WebSocket server
      socket = IO.io('http://172.16.20.37:3000', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false, // Connect manually
        'reconnection': true, // Enable automatic reconnection
        'reconnectionAttempts': 5, // Try reconnecting 5 times
        'reconnectionDelay': 2000, // Delay in ms between reconnections
      });

      socket.connect();

      socket.onConnect((_) {
        print('Connected to WebSocket server');
        _isConnected = true; // Set connection status to true
        onConnect(); // Trigger onConnect callback
      });

      // Attempt reconnection on disconnect
      socket.onDisconnect((_) {
        print('Disconnected from WebSocket server');
        _isConnected = false; // Update the connection status
        if (onDisconnect != null) {
          onDisconnect(); // Call onDisconnect if provided
        }
        reconnect(); // Attempt to reconnect automatically
      });

      socket.on('connect_error', (error) {
        print('Connection error: $error');
        reconnect(); // Implement reconnection logic in case of errors
      });
    }
  }

  // Function to attempt reconnection
  void reconnect() {
    if (!_isConnected) {
      print('Attempting to reconnect...');
      socket.connect(); // Try reconnecting
      connect(onConnect: () {});
    }
  }

  // Function to send a message
  void sendMessage(String senderId, String receiverId, String content) {
    // Generate roomID based on sender and receiver IDs
    String roomID = senderId.compareTo(receiverId) < 0
        ? '$senderId-$receiverId'
        : '$receiverId-$senderId';

    if (!_isConnected) {
      print('Socket not connected, cannot send message');
      return;
    }

    // Ensure we are in the room before sending the message
    joinRoom(roomID);

    socket.emit('sendMessage', {
      'sender': senderId,
      'receiver': receiverId,
      'content': content,
      'roomID': roomID,
    });
  }

  // Function to listen for new messages
  void listenForMessages(Function(String sender, String content) onMessage) {
    socket.on('message', (data) {
      String sender = data['sender'];
      String content = data['content'];
      onMessage(sender, content);
    });
  }

  // Function to join a room
  void joinRoom(String roomID) {
    _currentRoomID = roomID;

    if (!_isConnected) {
      print('Socket not connected, cannot join room');
      return;
    }

    socket.emit('joinRoom', {
      'roomID': roomID,
    });

    print('Joined room: $roomID');

    // Add error handling for joinRoom
    socket.on('joinRoom_error', (error) {
      print('Error joining room: $error');
    });
  }

  // Function to leave a room and disconnect the socket
  void leaveRoomAndDisconnect() {
    if (_currentRoomID != null && _isConnected) {
      print('Leaving room: $_currentRoomID');
      socket.emit('leaveRoom', {
        'roomID': _currentRoomID,
      });
      _currentRoomID = null;
    }

    // Disconnect only if connected (modified)
    if (_isConnected) {
      socket.disconnect();
      print('Socket disconnected manually');
    }
  }

  // Function to disconnect the socket manually (without leaving the room)
  void disconnect() {
    if (_isConnected) {
      socket.disconnect();
      print('Socket disconnected manually');
    }
  }

  // Function to check if the socket is connected
  bool get isConnected => _isConnected;
}
