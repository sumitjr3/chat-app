import 'package:chat_application_socket_io/services/api_services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> signup(String Username, String Password, String Email,
      String FirstName, String LastName, String Gender) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await ApiServices.signup(
          Username, Password, Email, FirstName, LastName, Gender);
      String token = result['token'];
      String userId = result['userId'];
      String userName = result['username'];
      String email = result['email'];
      String firstname = result['firstname'];
      String lastName = result['lastname'];
      String gender = result['gender'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('userId', userId);
      await prefs.setString('username', userName);
      await prefs.setString('email', email);
      await prefs.setString('firstname', firstname);
      await prefs.setString('lastname', lastName);
      await prefs.setString('gender', gender);
      await prefs.setString('loggedIn', 'true');
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
