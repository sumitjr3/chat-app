import 'package:chat_application_socket_io/screens/user_list_screen.dart';
import 'package:flutter/material.dart';
import '../services/chat_service.dart';
import '../services/message_service.dart'; // For fetching previous messages

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String senderId;

  ChatScreen({required this.receiverId, required this.senderId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService chatService = ChatService();
  final MessageService messageService =
      MessageService(); // Service to fetch old messages
  final TextEditingController messageController = TextEditingController();
  List<dynamic> messages = []; // List to store messages
  late String roomID; // RoomID to handle both users
  bool isLoading = true; // To show loading indicator while fetching messages

  @override
  void initState() {
    super.initState();

    // Generate roomID using sender and receiver IDs in a consistent order
    roomID = widget.senderId.compareTo(widget.receiverId) < 0
        ? '${widget.senderId}-${widget.receiverId}'
        : '${widget.receiverId}-${widget.senderId}';

    // Connect to the chat service if not already connected
    if (!chatService.isConnected) {
      chatService.connect(onConnect: () {
        // Join the chat room once connected
        chatService.joinRoom(roomID);

        // Fetch previous messages from the server after joining the room
        fetchMessages();
      });
    } else {
      // If already connected, join the room directly
      chatService.joinRoom(roomID);
      fetchMessages();
    }

    // Listen for real-time incoming messages
    chatService.listenForMessages((sender, content) {
      setState(() {
        messages.add({'sender': sender, 'content': content});
      });
    });
  }

  // Fetch previous messages from the server
  fetchMessages() async {
    try {
      var fetchedMessages = await messageService.fetchMessages(
          widget.senderId, widget.receiverId);
      setState(() {
        messages = fetchedMessages; // Load the fetched messages into the list
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching messages: $e');
    } finally {
      setState(() {
        isLoading = false; // Stop loading once messages are fetched
      });
    }
  }

  // Send a message to the server
  void _sendMessage() {
    final message = messageController.text;
    if (message.isEmpty) return; // Prevent sending empty messages

    if (chatService.socket.connected) {
      // Send the message to the server, which will then broadcast it back
      chatService.sendMessage(widget.senderId, widget.receiverId, message);
    } else {
      // Handle the case where the socket is not connected
      print('Socket not connected, message not sent');
    }

    messageController.clear(); // Clear input field after sending message
    FocusScope.of(context).requestFocus(FocusNode()); // Close keyboard
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Rejoin the room on navigating back (modified)
        if (chatService.isConnected) {
          chatService.leaveRoomAndDisconnect();
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UserListScreen(userId: widget.senderId),
          ),
        );

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chat'),
          leading: IconButton(
            onPressed: () {
              // Rejoin the room on navigating back (modified)
              if (chatService.isConnected) {
                chatService.leaveRoomAndDisconnect();
              }

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => UserListScreen(userId: widget.senderId),
                ),
              );
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : messages.isEmpty
                      ? Center(child: Text('No messages yet.'))
                      : ListView.builder(
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final msg = messages[index];
                            bool isMe = msg['sender'] == widget.senderId;
                            return ListTile(
                              title: Align(
                                alignment: isMe
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isMe
                                        ? Colors.blue[100]
                                        : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${msg['content']}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(labelText: 'Type a message'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//   @override
//   void dispose() {
//     chatService
//         .leaveRoomAndDisconnect(); // Leave the chat room instead of disconnecting
//     messageController.dispose(); // Dispose the controller
//     super.dispose();
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// class ChatScreen extends StatefulWidget {
//   final String roomId;
//   const ChatScreen({Key? key, required this.roomId}) : super(key: key);

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   IO.Socket? socket;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     connectSocket();
//   }

//   void connectSocket() {
//     // Initialize socket connection
//     socket = IO.io('http://172.16.20.37:3000', <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': false,
//     });

//     socket?.connect();

//     // Listening to socket events
//     socket?.onConnect((_) {
//       print('Connected to socket');
//       joinRoom();
//     });

//     socket?.on('userJoinedRoom', (data) {
//       print('User joined room: $data');
//       setState(() {
//         isLoading = false; // Stop loading once connected to the room
//       });
//     });

//     socket?.on('error', (error) {
//       print('Socket error: $error');
//       setState(() {
//         isLoading = false; // Stop loading on error
//       });
//     });

//     socket?.onDisconnect((_) {
//       print('Disconnected from socket');
//       setState(() {
//         isLoading = false; // Stop loading on disconnect as well
//       });
//     });
//   }

//   void joinRoom() {
//     // Emit event to join the chat room
//     if (socket != null && socket!.connected) {
//       socket?.emit('joinRoom', widget.roomId);
//       print('User joined room: ${widget.roomId}');
//     } else {
//       print('Socket not connected, cannot join room');
//     }
//   }

//   @override
//   void dispose() {
//     // Leave the room and disconnect socket on dispose
//     if (socket != null) {
//       socket?.emit('leaveRoom', widget.roomId);
//       socket?.disconnect();
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat Room ${widget.roomId}'),
//       ),
//       body: isLoading
//           ? Center(
//               child:
//                   CircularProgressIndicator()) // Show loading spinner while connecting
//           : Column(
//               children: [
//                 // Your chat messages go here
//                 Expanded(
//                   child: ListView(
//                     children: const <Widget>[
//                       // Example chat messages
//                       ListTile(title: Text('Message 1')),
//                       ListTile(title: Text('Message 2')),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     children: <Widget>[
//                       Expanded(
//                         child: TextField(
//                           decoration: InputDecoration(
//                             labelText: 'Enter message',
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.send),
//                         onPressed: () {
//                           // Emit event to send message
//                           if (socket != null && socket!.connected) {
//                             socket?.emit('sendMessage', {'message': 'Hello!'});
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }
