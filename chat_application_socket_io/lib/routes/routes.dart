import 'package:chat_application_socket_io/features/login/view/login_view.dart';
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
  ];
}
