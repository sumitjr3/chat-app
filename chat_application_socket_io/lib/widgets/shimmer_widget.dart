import 'package:chat_application_socket_io/cores/app_colors.dart';
import 'package:flutter/material.dart';

class ShimCon extends StatelessWidget {
  final height;
  final width;
  const ShimCon({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: AppColors.textSecondary,
          borderRadius: BorderRadius.circular(10)),
    );
  }
}
