import 'package:ausy/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashScreen extends StatelessWidget {
  final GetStorage storage = GetStorage();

  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Check auth status and navigate after delay
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColor.primary,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
    Future.delayed(const Duration(seconds: 3), () {
      if (Get.currentRoute != '/verify' && Get.currentRoute != '/reset') {
        // Jika bukan halaman verifikasi, lanjutkan normal flow
        bool isAuthenticated = storage.read('isAuthenticated') ?? false;
        bool isAuthenticatedUser = storage.read('isAuthenticatedUser') ?? false;
        if (isAuthenticated || isAuthenticatedUser) {
          if (isAuthenticated) {
            Get.offNamed('/home');
          }
          else{
            Get.offNamed('/homeuser');
          }
        } else {
          Get.offNamed('/login');
        }
      }
    });

    return Scaffold(
      backgroundColor: AppColor.primary, // Set background color to white
      body: Center(
        child: Image.asset(
          'assets/images/logo-white.png', // Path to your logo SVG file
          width: MediaQuery.of(context).size.width * 0.7, // Adjust the width to fit your needs
          fit: BoxFit.contain, // Keeps the aspect ratio intact
        ),
      ),
    );
  }
}
