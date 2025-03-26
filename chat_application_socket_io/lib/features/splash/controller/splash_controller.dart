import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  var isLogged = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getCatchData();
  }

  @override
  void onClose() {
    // TODO: implement onClose
  }

  //find the log in status
  Future<void> getCatchData() async {
    final prefs = await SharedPreferences.getInstance();
    isLogged.value = prefs.getString("loggedIn") == "true";
    navigateAccordingly();
  }

  //according to the log in status navigate to the home or login page
  Future<void> navigateAccordingly() async {
    await Future.delayed(const Duration(seconds: 3));
    if (isLogged.value) {
      Get.offAllNamed('/home');
    } else {
      Get.offAllNamed('/login');
    }
  }
}
