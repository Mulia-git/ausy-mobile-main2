import 'dart:io';
import 'package:ausy/core/themes/app_colors.dart';
import 'package:ausy/core/widgets/custom_appbar.dart';
import 'package:ausy/features/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final ProfileController profileController =
  Get.put(ProfileController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: "Informasi Pribadi",
        backgroundColor: Color(0xFF63B790),
        textColor: Colors.white,
      ),
      body: Obx(() {
        final customer = profileController.customer.value;

        if (customer == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            /// ================= BACKGROUND GRADIENT =================
            Container(
              height: 200 - MediaQuery.of(context).padding.top,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF63B790),
                    Color(0xFF70BD97),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            /// ================= CARD CONTENT =================
            Container(
              margin: const EdgeInsets.only(
                  top: 82, right: 16, bottom: 16, left: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    /// ================= FOTO + HEADER =================
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: profileController.updatePhoto,
                          child: Stack(
                            children: [
                              Obx(() {
                                final localPath =
                                    profileController.localPhotoPath.value;

                                ImageProvider imageProvider;

                                if (localPath.isNotEmpty) {
                                  imageProvider =
                                      FileImage(File(localPath));
                                } else if (customer.profilePicture.isNotEmpty &&
                                    customer.profilePicture
                                        .startsWith('http')) {
                                  imageProvider =
                                      NetworkImage(customer.profilePicture);
                                } else if (customer.genderRaw == 'L') {
                                  imageProvider = const AssetImage(
                                      'assets/images/male.png');
                                } else {
                                  imageProvider = const AssetImage(
                                      'assets/images/female.png');
                                }

                                return CircleAvatar(
                                  radius: 40,
                                  backgroundImage: imageProvider,
                                );
                              }),

                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 16,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                customer.name,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              Text("NIK: ${customer.idCardNumber}"),
                              Text(
                                  "No HP: ${customer.phoneNumber.isEmpty ? '-' : customer.phoneNumber}"),
                              Text(
                                  "Email: ${customer.email.isEmpty ? '-' : customer.email}"),
                              Text(
                                  "Jenis Kelamin: ${customer.genderRaw == 'L' ? 'Laki-laki' : 'Perempuan'}"),
                              Text(
                                  "Tanggal Lahir: ${customer.birthDate}"),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// ================= ALAMAT =================
                    const Row(
                      children: [
                        Icon(Icons.location_on,
                            color: AppColor.darker, size: 14),
                        SizedBox(width: 8),
                        Text(
                          'Alamat',
                          style:
                          TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(customer.address),
                    ),

                    const SizedBox(height: 20),

                    /// ================= NOMOR RM =================
                    Container(
                      width: double.infinity,
                      padding:
                      const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Nomor Rekam Medik",
                            style:
                            TextStyle(color: Colors.white),
                          ),
                          Text(
                            customer.medicalRecord,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// ================= QR =================
                    QrImageView(
                      data: customer.medicalRecord,
                      size: 200,
                      backgroundColor: Colors.white,
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Kartu Berobat Virtual",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),

                    const SizedBox(height: 20),

                    /// ================= BUTTON EDIT =================
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                        profileController.showEditDialog,
                        child: const Text("Edit Profil"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
