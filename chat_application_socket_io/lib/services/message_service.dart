import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MessageService {
    static var _baseUrl = dotenv.env['DEVELOPMENT_URL'];

  // Function to fetch messages between sender and receiver
  Future<List<dynamic>> fetchMessages(
      String senderId, String receiverId) async {
    try {
      // Generate roomID based on sender and receiver IDs
      final roomID = senderId.compareTo(receiverId) < 0
          ? '$senderId-$receiverId'
          : '$receiverId-$senderId';

      // Replace with your actual backend URL and endpoint
      final url =
          Uri.parse('$_baseUrl/chat/messages/$roomID');

      // Send GET request to the server with a timeout
      final response = await http.get(url).timeout(const Duration(
          seconds: 10)); // Add timeout to prevent indefinite waiting

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Parse and return the response body as a list of messages
        return json.decode(response.body);
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
