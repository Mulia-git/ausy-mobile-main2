import 'package:ausy/core/themes/app_colors.dart';
import 'package:ausy/core/widgets/custom_textbox.dart';
import 'package:ausy/features/auth/controllers/auth_controller.dart';
import 'package:ausy/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ForgotPage extends StatelessWidget {
  final AuthController authController =
      Get.put(AuthController(), permanent: true);
  final TextEditingController usernameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form key
  final RxBool isVisible = true.obs;
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController waController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // Regular expression for basic URL validation
  final RegExp urlRegex = RegExp(
      r'^(https?:\/\/)?([a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5})?(:[0-9]{1,5})?(\/.*)?$');

  ForgotPage({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: "Lupa Password",
        backgroundColor: Color(0xFF63B790),
        textColor: Colors.white,
      ),
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

                            const SizedBox(height: 48),

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
                              padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 30.0),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20), // Radius di kiri atas
                                  topRight: Radius.circular(20), // Radius di kanan atas
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Lupa password?",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 24),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    "Jika Anda lupa kata sandi, silakan lakukan reset melalui sistem kami untuk mengakses layanan RS Aura Syifa kembali. ",
                                    style: TextStyle(color: AppColor.labelColor,fontSize: 12),
                                  ),
                                  const SizedBox(height: 20),

                                  CustomTextBox(
                                    hint: "Nama Lengkap",
                                    keyboardType: TextInputType.name,
                                    controller: namaController,
                                    prefix: const Icon(Icons.person_outline, size: 16),
                                    validator: (v) => v == null || v.isEmpty ? "Nama wajib diisi" : null,
                                  ),

                                  const SizedBox(height: 16),

                                  CustomTextBox(
                                    hint: "NIK (16 digit)",
                                    keyboardType: TextInputType.number,
                                    controller: nikController,
                                    prefix: const Icon(Icons.badge_outlined, size: 16),
                                    validator: (v) {
                                      if (v == null || v.isEmpty) return "NIK wajib diisi";
                                      if (v.length != 16) return "NIK harus 16 digit";
                                      if (!RegExp(r'^[0-9]+$').hasMatch(v)) return "NIK hanya angka";
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 16),

                                  CustomTextBox(
                                    hint: "No WhatsApp",
                                    keyboardType: TextInputType.phone,
                                    controller: waController,
                                    prefix: const Icon(Icons.phone_outlined, size: 16),
                                    validator: (v) => v == null || v.isEmpty ? "No WA wajib diisi" : null,
                                  ),

                                  const SizedBox(height: 16),

                                  CustomTextBox(
                                    hint: "Email",
                                    keyboardType: TextInputType.emailAddress,
                                    controller: emailController,
                                    prefix: const Icon(Icons.email_outlined, size: 16),
                                    validator: (v) {
                                      if (v == null || v.isEmpty) return "Email wajib diisi";
                                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) return "Email tidak valid";
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 20),
                                  Obx(() {
                                    return SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColor.primary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () {
                                          if (_formKey.currentState!.validate()) {
                                            _sendForgotToWA(
                                              namaController.text,
                                              nikController.text,
                                              waController.text,
                                              emailController.text,
                                            );
                                          }
                                        },

                                        child: authController.isLoading.value
                                            ? const Text('Loading...',
                                                style: TextStyle(color: Colors.white))
                                            : const Text('Kirim',
                                                style: TextStyle(color: Colors.white)),
                                      ),
                                    );
                                  }),
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
                "© 2025 IT RS Aura Syifa",
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

Future<void> _sendForgotToWA(String nama, String nik, String wa, String email) async {
  const String admin = "6282231708671";

  final String message = '''
Halo Admin RS Aura Syifa,

Saya lupa password akun.

Nama  : $nama
NIK   : $nik
No WA : $wa
Email : $email

Mohon bantuan reset password.
''';

  final Uri url =
  Uri.parse("https://wa.me/$admin?text=${Uri.encodeComponent(message)}");

  await launchUrl(url, mode: LaunchMode.externalApplication);
}
