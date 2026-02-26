import 'package:ausy/core/themes/app_colors.dart';
import 'package:ausy/core/widgets/custom_textbox.dart';
import 'package:ausy/features/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatelessWidget {
  final AuthController authController =
      Get.put(AuthController(), permanent: true);
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form key
  final String message = Get.arguments?['message'] ?? '';
  final RxBool isVisible = true.obs;

  // Regular expression for basic URL validation
  final RegExp urlRegex = RegExp(
      r'^(https?:\/\/)?([a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5})?(:[0-9]{1,5})?(\/.*)?$');

  LoginPage({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 250 + MediaQuery.of(context).padding.top,
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
                            const SizedBox(
                              height: 48,
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
                                  topLeft: Radius.circular(
                                      20), // Radius di kiri atas
                                  topRight: Radius.circular(
                                      20), // Radius di kanan atas
                                ),
                              ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    message != ''
                                        ? Obx(() => isVisible.value
                                            ? Container(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                  color: Colors.red
                                                      .withValues(alpha: 0.8),
                                                  border: Border.all(
                                                      color: AppColor
                                                          .textBoxColor),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: AppColor
                                                          .shadowColor
                                                          .withValues(
                                                              alpha: 0.05),
                                                      spreadRadius: .5,
                                                      blurRadius: .5,
                                                      offset:
                                                          const Offset(0, 1),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    // Pesan
                                                    Expanded(
                                                      child: Text(
                                                        message,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        isVisible.value = false;
                                                      },
                                                      child: const Icon(
                                                          Icons.close,
                                                          color: Colors.white,
                                                          size: 16),
                                                    )
                                                  ],
                                                ),
                                              )
                                            : const SizedBox())
                                        : const SizedBox(),
                                    const Text(
                                      "Selamat Datang!",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      "Silakan masuk untuk memperoleh layanan kesehatan yang optimal dan fitur terbaik dari RS Aura Syifa.",
                                      style: TextStyle(
                                          color: AppColor.labelColor,
                                          fontSize: 12),
                                    ),
                                    const SizedBox(height: 20),
                                    CustomTextBox(
                                      hint: "No Rekam Medis",
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      prefix: const Icon(
                                        Icons.add_card_outlined,
                                        color: Colors.grey,
                                        size: 16,
                                      ),
                                      controller: usernameController,
                                    ),
                                    const SizedBox(height: 16),
                                    CustomTextBox(
                                      hint: "NIK",
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      prefix: const Icon(
                                        Icons.add_card_outlined,
                                        color: Colors.grey,
                                        size: 16,
                                      ),
                                      controller: nikController,
                                    ),
                                    const SizedBox(height: 20),
                                    // Container(
                                    //   width: double.infinity,
                                    //   margin: const EdgeInsets.only(bottom: 20),
                                    //   child: GestureDetector(
                                    //     onTap: () => _showNikModal(context),
                                    //     child: const Text(
                                    //       "Lupa No Rekam Medis / NIK?",
                                    //       textAlign: TextAlign.right,
                                    //       style: TextStyle(
                                    //         fontWeight: FontWeight.bold,
                                    //         color: AppColor.primary,
                                    //         fontSize: 14,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    // Container(
                                    //   width: double.infinity,
                                    //   margin: const EdgeInsets.only(bottom: 20),
                                    //   child: GestureDetector(
                                    //     onTap: () {
                                    //       Get.toNamed('/forgot');
                                    //     },
                                    //     child: const Text(
                                    //       "Lupa Kata Sandi?",
                                    //       textAlign: TextAlign.right,
                                    //       style: TextStyle(
                                    //           fontWeight: FontWeight.bold,
                                    //           color: AppColor.primary,
                                    //           fontSize: 14),
                                    //     ),
                                    //   ),
                                    // ),
                                    Obx(() {
                                      return SizedBox(
                                        width: double.infinity,
                                        height: 50,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColor.primary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: authController
                                                  .isLoading.value
                                              ? null
                                              : () {
                                                  if (_formKey.currentState
                                                          ?.validate() ==
                                                      true) {
                                                    authController.login(
                                                      usernameController.text,
                                                      nikController.text,
                                                    );
                                                  }
                                                },
                                          child: authController.isLoading.value
                                              ? const Text('Loading...',
                                                  style: TextStyle(
                                                      color: Colors.white))
                                              : const Text('Login',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                        ),
                                      );
                                    }),
                                    const SizedBox(height: 10),
                                    // Container(
                                    //   alignment: Alignment.center,
                                    //   margin:
                                    //       const EdgeInsets.symmetric(vertical: 10.0),
                                    //   child: Row(
                                    //       mainAxisAlignment: MainAxisAlignment.center,
                                    //       children: [
                                    //         const Text(
                                    //           'Belum punya akun? ',
                                    //           style: TextStyle(
                                    //             color: Colors.black,
                                    //             fontSize: 14,
                                    //           ),
                                    //         ),
                                    //         const SizedBox(width: 5),
                                    //         GestureDetector(
                                    //           onTap: () => Get.toNamed('/register'),
                                    //           child: const Text(
                                    //             'Daftar',
                                    //             style: TextStyle(
                                    //               color: AppColor.primary,
                                    //               fontWeight: FontWeight.bold,
                                    //               fontSize: 14,
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ]),
                                    // ),
                                  ]),
                            )
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
            SafeArea(
              top: false, // cuma amankan bagian bawah
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8), // naik sedikit lagi
                child: Column(
                  children: const [
                    SizedBox(height: 10),
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
                  ],
                ),
              ),
            ),

        ],
      ),
    );
  }
}
void _showNikModal(BuildContext context) {
  final TextEditingController nikController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController waController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Bantuan Lupa No RM / NIK",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text("Isi data berikut untuk membantu pencarian data Anda."),
              const SizedBox(height: 16),

              /// NAMA
              CustomTextBox(
                hint: "Nama Lengkap",
                keyboardType: TextInputType.name,
                controller: namaController,
                prefix: const Icon(Icons.person_outline, size: 16),
                validator: (value) =>
                value == null || value.isEmpty ? "Nama wajib diisi" : null,
              ),

              const SizedBox(height: 16),

              /// NIK
              CustomTextBox(
                hint: "NIK (16 digit)",
                keyboardType: TextInputType.number,
                controller: nikController,
                prefix: const Icon(Icons.badge_outlined, size: 16),
                validator: (value) {
                  if (value == null || value.isEmpty) return "NIK wajib diisi";
                  if (value.length != 16) return "NIK harus 16 digit";
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return "NIK hanya angka";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              /// NO WA
              CustomTextBox(
                hint: "No WhatsApp",
                keyboardType: TextInputType.phone,
                controller: waController,
                prefix: const Icon(Icons.phone_outlined, size: 16),
                validator: (value) {
                  if (value == null || value.isEmpty) return "No WA wajib diisi";
                  if (value.length < 10) return "No WA tidak valid";
                  return null;
                },
              ),

              const SizedBox(height: 16),

              /// EMAIL
              CustomTextBox(
                hint: "Email",
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                prefix: const Icon(Icons.email_outlined, size: 16),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Email wajib diisi";
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return "Format email tidak valid";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      _openWhatsApp(
                        namaController.text,
                        nikController.text,
                        waController.text,
                        emailController.text,
                      );
                    }
                  },
                  child: const Text(
                    "Lanjut via WhatsApp",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
void _openWhatsApp(String nama, String nik, String wa, String email) async {
  const String adminNumber = '08975520000';

  final String message = '''
Halo Admin RS Aura Syifa,
Saya ingin daftar akun.

Nama  : $nama
NIK   : $nik
No WA : $wa
Email : $email
''';

  final Uri url = Uri.parse(
      "https://wa.me/$adminNumber?text=${Uri.encodeComponent(message)}");

  await launchUrl(url, mode: LaunchMode.externalApplication);
}
