import 'package:chat_application_socket_io/features/login/view/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  RxString username = ''.obs;
  RxString userId = ''.obs;
  RxString userEmail = ''.obs;
  RxString userGender = ''.obs;
  RxBool isLoading = false.obs;
  RxString userAvatar = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getUserData();
  }

  void getUserData() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      username.value = prefs.getString('username') ?? '';
      userId.value = prefs.getString('userId') ?? '';
      userEmail.value = prefs.getString('email') ?? '';
      userGender.value = prefs.getString('gender') ?? '';
      userAvatar.value = prefs.getString('avatar') ?? '';
      print('username------------------------------------->${username.value}');
      print('gender------------------------------------->${userGender.value}');
    } catch (e) {
      print('Error fetching user data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('userId');
    await prefs.remove('email');
    await prefs.remove('gender');
    await prefs.remove('loggedIn');
    await prefs.remove('token');
    await prefs.remove('firstname');
    await prefs.remove('lastname');

    Get.offAll(() => LoginView());
  }
}
