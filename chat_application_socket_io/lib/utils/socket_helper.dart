import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketHelper {
  static IO.Socket connect() {
    return IO.io('http://192.168.0.108:5000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });
  }
}
