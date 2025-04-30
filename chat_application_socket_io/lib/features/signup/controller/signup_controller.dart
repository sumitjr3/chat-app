import 'package:chat_application_socket_io/services/api_services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupController extends GetxController {
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
  // Observable variable to track the selected avatar index. -1 means none selected.
  var selectedAvatarIndex = RxInt(-1);

  Future<void> signup(
      String Username,
      String Password,
      String Email,
      String FirstName,
      String LastName,
      String Gender,
      String avatarPath) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await ApiServices.signup(
          Username, Password, Email, FirstName, LastName, Gender, avatarPath);
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
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // List of avatar asset paths (replace with your actual asset paths)
  // Make sure you have these images in your assets folder and declared in pubspec.yaml
  final List<String> avatarAssets = [
    'assets/avatar/avatar1.svg',
    'assets/avatar/avatar2.svg',
    'assets/avatar/avatar3.svg',
    'assets/avatar/avatar4.svg',
    'assets/avatar/avatar5.svg',
    'assets/avatar/avatar6.svg',
    'assets/avatar/avatar7.svg',
    'assets/avatar/avatar8.svg',
    'assets/avatar/avatar9.svg',
    'assets/avatar/avatar10.svg',
    'assets/avatar/avatar11.svg',
    'assets/avatar/avatar12.svg',
    'assets/avatar/avatar13.svg',
    'assets/avatar/avatar14.svg',
    'assets/avatar/avatar15.svg',
  ];

  void selectAvatar(int index) {
    selectedAvatarIndex.value = index;
    // You could potentially add more logic here, like saving the selection
    // or navigating to another screen.
    print('Selected avatar index: $index');
  }
}
