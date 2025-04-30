import 'package:chat_application_socket_io/features/chat%20list/view/chat_list_view.dart';
import 'package:chat_application_socket_io/features/chat/view/chat_view.dart';
import 'package:chat_application_socket_io/features/login/view/login_view.dart';
import 'package:chat_application_socket_io/features/profile/view/profile_view.dart';
import 'package:chat_application_socket_io/features/search/view/search_view.dart';
import 'package:chat_application_socket_io/features/signup/view/select_avtar.dart';
import 'package:chat_application_socket_io/features/signup/view/signup_view.dart';
import 'package:chat_application_socket_io/features/splash/view/splash_view.dart';
import 'package:get/get.dart';

class AppPages {
  AppPages._();

  static const INITIAL = '/';

  static final routes = [
    GetPage(
      name: '/',
      page: () => SplashView(),
    ),
    GetPage(
      name: '/login',
      page: () => LoginView(),
    ),
    GetPage(
      name: '/home',
      page: () => ChatListView(),
    ),
    GetPage(
      name: '/signup',
      page: () => SignupView(),
    ),
    GetPage(
      name: '/searchView',
      page: () => SearchViewClass(),
    ),
    GetPage(
      name: '/chatScreen',
      page: () => ChatScreen(),
    ),
    GetPage(
      name: '/profileScreen',
      page: () => ProfileView(),
    ),
    GetPage(
      name: '/selectAvtarScreen',
      page: () => AvatarSelectionScreen(),
    ),
  ];
}
