import 'package:chat_application_socket_io/features/search/models/searchUserModel.dart';
import 'package:chat_application_socket_io/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchControllers extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var userId = ''.obs;
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userImage = ''.obs;
  var userToken = ''.obs;
  var searchValue = ''.obs;
  var userList = <Searchusermodel>[].obs;
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
  }

  Future<void> getSearchUser() async {
    try {
      isLoading.value = true;
      final response =
          await _apiServices.searchUser(searchValue.value, userToken.value);

      if (response['data'] != null) {
        userList.clear();
        final user = Searchusermodel.fromJson(response['data']);
        userList.add(user);
      } else {
        Get.snackbar('Not a user', 'The username you typed isn\'t valid');
      }
    } catch (e) {
      Get.snackbar('Oops!!!', 'something went wrong');
    } finally {
      isLoading.value = false;
    }
  }
}
