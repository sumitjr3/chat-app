import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SocketHelper {
  static var _baseUrl = dotenv.env['DEVELOPMENT_URL'];

  static IO.Socket connect() {

    return IO.io('$_baseUrl', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });
  }
}
