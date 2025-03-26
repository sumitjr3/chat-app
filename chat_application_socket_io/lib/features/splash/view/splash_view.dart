import 'package:chat_application_socket_io/cores/app_colors.dart';
import 'package:chat_application_socket_io/features/splash/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final SplashController splashController = Get.put(SplashController());
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Center(
        child: SvgPicture.asset(
          height: (screenHeight * 0.075),
          "assets/svg/splash_app_name.svg",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
