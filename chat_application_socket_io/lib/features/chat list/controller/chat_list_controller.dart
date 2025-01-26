import 'package:chat_application_socket_io/services/auth_service.dart';
import 'package:get/get.dart';

class ChatListController extends GetxController {
  var isLoading = true.obs;
  var users = <dynamic>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      var fetchedUsers = await AuthService.fetchUsers();
      users.assignAll(fetchedUsers);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
