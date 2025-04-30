import 'package:chat_application_socket_io/features/chat%20list/model/chat_list_model.dart';
import 'package:get/get.dart';
import '../../../services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatListController extends GetxController {
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var userId = ''.obs;
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userImage = ''.obs;
  var userToken = ''.obs;
  var chatList = <ChatListModel>[].obs;
  final ApiServices _apiServices = ApiServices();

  @override
  void onInit() {
    super.onInit();
    getInfo();
  }

  Future<void> getInfo() async {
    final prefs = await SharedPreferences.getInstance();
    userId.value = prefs.getString('userId') ?? '';
    userName.value = prefs.getString('username') ?? '';
    userEmail.value = prefs.getString('email') ?? '';
    userToken.value = prefs.getString('token') ?? '';
    if (userId.value.isNotEmpty && userToken.value.isNotEmpty) {
      getChatList();
    }
  }

  Future<void> getChatList() async {
    try {
      isLoading.value = true;
      final response =
          await _apiServices.getChatList(userId.value, userToken.value);

      if (response['length'] > 0) {
        chatList.value = List<Map<String, dynamic>>.from(response['data'])
            .map((json) => ChatListModel.fromJson(json))
            .toList();
      } else {
        chatList.value = [];
      }
    } catch (e) {
      errorMessage('Error: $e');
      chatList.value = [];
    } finally {
      isLoading.value = false;
    }
  }
}
