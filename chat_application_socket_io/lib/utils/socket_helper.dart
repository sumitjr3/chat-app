import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketHelper {
  static IO.Socket connect() {
    return IO.io('https://chat-app-0mkv.onrender.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });
  }
}
