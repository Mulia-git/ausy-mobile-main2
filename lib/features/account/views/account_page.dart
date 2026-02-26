import 'package:ausy/core/themes/app_colors.dart';
import 'package:ausy/core/widgets/custom_image.dart';
import 'package:ausy/features/account/views/widgets/account_appbar.dart';
import 'package:ausy/features/account/views/widgets/setting_item.dart';
import 'package:ausy/features/auth/controllers/auth_controller.dart';
import 'package:ausy/features/profile/controllers/profile_controller.dart';
import 'package:ausy/features/account/controllers/account_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final AccountController accountController =
      Get.put(AccountController(), permanent: true);
  final AuthController authController =
      Get.put(AuthController(), permanent: true);
  final ProfileController profileController =
      Get.put(ProfileController(), permanent: true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      accountController.loadCustomerData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            backgroundColor: Colors.white,
            pinned: true,
            snap: true,
            floating: true,
            elevation: 0,
            title: AccountAppBar(),
          ),
          SliverToBoxAdapter(child: _buildBody(context))
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Obx(() {
            if (accountController.customer.value == null) {
              return Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                  ));
            }
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColor.cardColor,
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomImage(
                      accountController.customer.value?.profilePicture.isNotEmpty == true
                          ? accountController.customer.value!.profilePicture
                          : 'assets/images/male.png',
                      width: 38,
                      height: 38,
                      radius: 19,
                      fit: BoxFit.fitWidth,

                    ),

                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            accountController.customer.value!.name,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            accountController.customer.value!.medicalRecord,
                            style: const TextStyle(color: AppColor.labelColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // child: Column(
              //   children: [
              //     CustomImage(
              //       accountController.customer.value!.image,
              //       width: 70,
              //       height: 70,
              //       radius: 20,
              //     ),
              //     const SizedBox(
              //       height: 10,
              //     ),
              //     Text(
              //       accountController.customer.value!.name,
              //       style: const TextStyle(
              //         fontSize: 18,
              //         fontWeight: FontWeight.w500,
              //       ),
              //     ),
              //   ],
              // ),
            );
          }),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppColor.cardColor,
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                SettingItem(
                  title: "Informasi Pribadi",
                  leadingIcon: "assets/icons/profile.svg",
                  bgIconColor: AppColor.primary,
                  onTap: () {
                    Get.toNamed('/profile');
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 45),
                  child: Divider(
                    height: 0,
                    color: Colors.grey.withValues(alpha: 0.8),
                  ),
                ),
                // SettingItem(
                //   title: "Layanan Telemedicine",
                //   leadingIcon: "assets/icons/telemedicine.svg",
                //   bgIconColor: Colors.green,
                //   onTap: () {
                //     Get.toNamed('/telemedicine');
                //   },
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 45),
                //   child: Divider(
                //     height: 0,
                //     color: Colors.grey.withValues(alpha: 0.8),
                //   ),
                // ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              Get.dialog(
                Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Radius untuk dialog
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Teks rata kiri
                      children: [
                        const Text(
                          "Yakin Mau Keluar?",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Jika Anda keluar, Anda harus login kembali untuk mengakses aplikasi. Tetap ingin keluar?",
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Get.back(); // Tutup dialog tanpa logout
                              },
                              child: const Text("Batal"),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                authController.logout(); // Call logout
                                Get.back(); // Tutup dialog setelah logout
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10), // Radius tombol
                                ),
                              ),
                              child: const Text("Ya",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColor.cardColor,
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const SettingItem(
                title: "Log Out",
                leadingIcon: "assets/icons/logout.svg",
                bgIconColor: AppColor.darker,
              ),
            ),
          )
        ],
      ),
    );
  }
}
