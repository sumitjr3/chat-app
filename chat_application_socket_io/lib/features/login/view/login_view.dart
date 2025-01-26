import 'package:chat_application_socket_io/features/login/controller/login_controller.dart';
import 'package:chat_application_socket_io/features/signup/view/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  final LoginController authController = Get.put(LoginController());
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Obx(() {
          return Column(
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              if (authController.errorMessage.value.isNotEmpty)
                Text(
                  authController.errorMessage.value,
                  style: TextStyle(color: Colors.red),
                ),
              ElevatedButton(
                onPressed: authController.isLoading.value
                    ? null
                    : () {
                        authController.login(
                          usernameController.text,
                          passwordController.text,
                        );
                      },
                child: authController.isLoading.value
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Get.off(() => SignupView());
                },
                child: Text(
                  'Signup',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
