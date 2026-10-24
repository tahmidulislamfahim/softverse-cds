import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/theme/app_colors_extension.dart';
import '../../controller/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    // Touch controller so GetX resolves it and its onInit navigation timer starts.
    controller;

    return Scaffold(
      backgroundColor: c.cardBg,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 240, maxHeight: 240),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Image.asset(
              'assets/icons/logo.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
