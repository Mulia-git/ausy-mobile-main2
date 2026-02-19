import 'dart:io';

import 'package:ausy/core/themes/app_colors.dart';
import 'package:ausy/core/widgets/custom_textbox.dart';
import 'package:ausy/features/auth/controllers/auth_controller.dart';
import 'package:ausy/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends StatelessWidget {
  final AuthController authController =
      Get.put(AuthController(), permanent: true);
  final TextEditingController nimController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController regionController = TextEditingController();
  final TextEditingController typeOfUseController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController =
      TextEditingController();
  final TextEditingController baseUrlController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form key

  // Regular expression for basic URL validation
  final RegExp urlRegex = RegExp(
      r'^(https?:\/\/)?([a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5})?(:[0-9]{1,5})?(\/.*)?$');

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Daftar",
        backgroundColor: Color(0xFF63B790),
        textColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 250,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF63B790), // Hijau Muda
                        Color(0xFF70BD97), // Hijau Tua
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 48 - MediaQuery.of(context).padding.top,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              child: Image.asset(
                                'assets/images/logo-white.png',
                                width: 280,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20.0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 30.0),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20), // Radius di kiri atas
                                  topRight:
                                      Radius.circular(20), // Radius di kanan atas
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Daftar!",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 24),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    "Daftarkan akun Anda sekarang untuk memperoleh kemudahan dalam mengakses layanan RS Aura Syifa.",
                                    style: TextStyle(color: AppColor.labelColor,fontSize: 12),
                                  ),
                                  const SizedBox(height: 20),
                                  CustomTextBox(
                                    hint: "Nomor KTP",
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    prefix: const Icon(Icons.add_card,
                                        color: Colors.grey, size: 16),
                                    controller: nameController,
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextBox(
                                    hint: "Nama Lengkap (Sesuai KTP)",
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    prefix: const Icon(Icons.person,
                                        color: Colors.grey, size: 16),
                                    controller: nameController,
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextBox(
                                    hint: "No Whatsapp",
                                    keyboardType: TextInputType.phone,
                                    textInputAction: TextInputAction.next,
                                    prefix: const Icon(Icons.phone,
                                        color: Colors.grey, size: 16),
                                    controller: usernameController,
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextBox(
                                    hint: "Email",
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    prefix: const Icon(Icons.email,
                                        color: Colors.grey, size: 16),
                                    controller: emailController,
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    alignment: Alignment.center,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 10.0),
                                    child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'Sudah punya akun?? ',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            GestureDetector(
                                              onTap: () => Get.offNamed('/login'),
                                              child: const Text(
                                                'Login',
                                                style: TextStyle(
                                                  color: AppColor.primary,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ]),
                                  ),
                                  SizedBox(
                                    height: Platform.isIOS ? 20 : 0,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (MediaQuery.of(context).viewInsets.bottom == 0)
          const Column(
            children: [
              SizedBox(height: 20),
              Text(
                "© 2025 RS Aura Syifa",
                style: TextStyle(
                  color: AppColor.labelColor,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "All rights reserved.",
                style: TextStyle(
                  color: AppColor.labelColor,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
