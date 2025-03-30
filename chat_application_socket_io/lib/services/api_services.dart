import 'dart:io';

import 'package:chat_application_socket_io/cores/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class apiService {
  static var _baseUrl = dotenv.env['DEVELOPMENT_URL'];

  static Future<void> showExitDialog(
      BuildContext context, double height, double width) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          contentPadding: EdgeInsets.symmetric(
              vertical: height * 0.017, horizontal: width * 0.07),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          buttonPadding: EdgeInsets.all(height * 0.01),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Exit',
                style: TextStyle(
                  fontSize: height * 0.02,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "Do you want to exit?",
                style: TextStyle(
                    fontSize: height * 0.018,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                    color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.background,
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.1, vertical: height * 0.007),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: const BorderSide(color: AppColors.orange),
                      ),
                    ),
                    child: Text(
                      'No',
                      style: TextStyle(
                          fontSize: height * 0.018,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                          color: AppColors.orange),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.1, vertical: height * 0.007),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: const BorderSide(color: AppColors.orange),
                      ),
                    ),
                    child: Text(
                      'Yes',
                      style: TextStyle(
                          fontSize: height * 0.018,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                          color: AppColors.background),
                    ),
                    onPressed: () {
                      if (Platform.isAndroid) {
                        SystemNavigator.pop();
                      } else if (Platform.isIOS) {
                        exit(0);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<Map<String, dynamic>> signup(String username, String password,
      String email, String firstName, String lastName, String gender) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'gender': gender
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      Get.offAllNamed('/home');

      return {
        'token': data['data']['token'],
        'userId': data['data']['userId'],
        'username': data['data']['username'],
        'email': data['data']['email'],
        'firstname': data['data']['firstName'],
        'lastname': data['data']['lastName'],
        'gender': data['data']['gender'],
      };
    } else if (response.statusCode == 403) {
      final data = jsonDecode(response.body);

      Get.snackbar(
        'Error',
        data['data']['message'],
        snackPosition: SnackPosition.TOP,
      );
      return {};
    } else if (response.statusCode == 401 || response.statusCode == 400) {
      Get.snackbar(
        'Error',
        'Invalid username or password',
        snackPosition: SnackPosition.TOP,
      );
      return {};
    } else {
      Get.snackbar(
        'Error',
        'something went wrong',
        snackPosition: SnackPosition.TOP,
      );
      return {};
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
      Get.offAllNamed('/home');

      return {
        'token': data['data']['token'],
        'userId': data['data']['userId'],
        'username': data['data']['username'],
        'email': data['data']['email'],
        'firstname': data['data']['firstName'],
        'lastname': data['data']['lastName'],
        'gender': data['data']['gender'],
      };
    } else if (response.statusCode == 403) {
      final data = jsonDecode(response.body);

      Get.snackbar(
        'Error',
        data['data']['message'],
        snackPosition: SnackPosition.TOP,
      );
      return {};
    } else if (response.statusCode == 401 || response.statusCode == 400) {
      Get.snackbar(
        'Error',
        'Invalid username or password',
        snackPosition: SnackPosition.TOP,
      );
      return {};
    } else {
      Get.snackbar(
        'Error',
        'something went wrong',
        snackPosition: SnackPosition.TOP,
      );
      return {};
    }
  }

  static Future<List<dynamic>> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/auth/users'));
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
