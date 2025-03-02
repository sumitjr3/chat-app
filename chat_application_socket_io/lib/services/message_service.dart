import 'package:chat_application_socket_io/features/chat/model/message_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MessageService {
  Future<List<Message>> fetchMessages(
      String? senderId, String? receiverId) async {
    try {
      // Generate roomID based on sender and receiver IDs
      final roomID = senderId!.compareTo(receiverId!) < 0
          ? '$senderId-$receiverId'
          : '$receiverId-$senderId';

      // Replace with your actual backend URL and endpoint
      final url =
          Uri.parse('https://chat-app-0mkv.onrender.com/chat/messages/$roomID');

      // Send GET request to the server with a timeout
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Parse and return the response body as a list of messages
        print(response.body.toString());
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => Message.fromJson(item)).toList();
      } else if (response.statusCode == 404) {
        // Handle case where no messages are found
        throw Exception('Messages not found for room: $roomID');
      } else {
        // Handle other unsuccessful responses
        throw Exception(
            'Failed to load messages. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Log the error and rethrow an exception with the error message
      print('Error fetching messages: $e');
      throw Exception('Failed to load messages: $e');
    }
  }
}
