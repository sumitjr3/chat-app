import 'package:chat_application_socket_io/features/login/view/login_view.dart';
import 'package:chat_application_socket_io/features/signup/controller/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupView extends StatelessWidget {
  final SignupController signupController = Get.put(SignupController());
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Signup')),
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
              if (signupController.errorMessage.value.isNotEmpty)
                Text(
                  signupController.errorMessage.value,
                  style: TextStyle(color: Colors.red),
                ),
              ElevatedButton(
                onPressed: signupController.isLoading.value
                    ? null
                    : () {
                        signupController.signup(
                          usernameController.text,
                          passwordController.text,
                        );
                      },
                child: signupController.isLoading.value
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text('Signup'),
              ),
              TextButton(
                onPressed: () {
                  Get.off(() => LoginView());
                },
                child: Text(
                  'Login',
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
