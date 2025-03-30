import 'package:get/get.dart';
import '../../../services/api_services.dart';

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
      var fetchedUsers = await apiService.fetchUsers();
      users.assignAll(fetchedUsers);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
