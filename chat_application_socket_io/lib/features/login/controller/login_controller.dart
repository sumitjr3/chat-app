import 'package:chat_application_socket_io/features/chat%20list/view/chat_list_view.dart';
import 'package:chat_application_socket_io/services/api_services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var token = ''.obs;
  var userId = ''.obs;
  var userName = ''.obs;
  var userEmail = ''.obs;
  var firstname = ''.obs;
  var lastname = ''.obs;
  var gender = ''.obs;
  var avatar = ''.obs;

  final ApiServices _apiServices = ApiServices();

  Future<void> login(String username, String password) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _apiServices.login(username, password);
      if (result.isEmpty) {
        Get.snackbar('Invalid creds', 'Please enter valids credentials');
      } else {
        token.value = result['token'];
        userId.value = result['userId'];
        userName.value = result['username'];
        userEmail.value = result['email'];
        firstname.value = result['firstname'];
        lastname.value = result['lastname'];
        gender.value = result['gender'];
        avatar.value = result['avatar'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token.value);
        await prefs.setString('userId', userId.value);
        await prefs.setString('username', userName.value);
        await prefs.setString('email', userEmail.value);
        await prefs.setString('firstname', firstname.value);
        await prefs.setString('lastname', lastname.value);
        await prefs.setString('gender', gender.value);
        await prefs.setString('avatar', avatar.value);

        await prefs.setString('loggedIn', 'true');
        Get.offAllNamed('/home');
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
