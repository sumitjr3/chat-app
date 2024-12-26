import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final String baseUrl = 'http://192.168.0.108:3000/auth';

  Future<bool> signup(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
          {'username': username, 'email': email, 'password': password}),
    );

    return response.statusCode == 201;
  }

  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    final response = await http.post(
      Uri.parse('http://192.168.0.108:3000/auth/login'),
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
      final response =
          await http.get(Uri.parse('http://192.168.0.108:3000/auth/users'));
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
