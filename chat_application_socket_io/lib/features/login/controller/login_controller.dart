import 'package:chat_application_socket_io/features/chat%20list/view/chat_list_view.dart';
import 'package:chat_application_socket_io/services/auth_service.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> login(String username, String password) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await AuthService.login(username, password);
      String token = result['token'];
      String userId = result['userId'];

      // Store the token and userId if needed
      // For example, you can use GetStorage or any other storage solution

      // Navigate to the User List screen, passing the user ID
      Get.off(() => ChatListView(userId: userId));
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
