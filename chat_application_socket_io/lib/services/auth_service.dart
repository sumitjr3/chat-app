import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  static var _baseUrl = dotenv.env['DEVELOPMENT_URL'];

  static Future<Map<String, dynamic>> signup(
      String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'token': data['token'],
        'userId': data['userId'],
      };
    } else {
      throw Exception('Failed to log in');
    }
  }

  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'token': data['token'],
        'userId': data['userId'], // Assuming your backend returns userId
      };
    } else {
      throw Exception('Failed to log in');
    }
  }

  static Future<List<dynamic>> fetchUsers() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/auth/users'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch users');
      }
    } catch (error) {
      print('Error fetching users: $error');
      return [];
    }
  }
}
