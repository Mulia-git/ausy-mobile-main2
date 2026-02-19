import 'dart:io';
import 'package:ausy/core/constants/api_constants.dart';
import 'package:ausy/core/models/customer.dart';
import 'package:ausy/core/services/auth_service.dart';
import 'package:ausy/core/services/dio_service.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {

  final DioService _dioService = DioService();
  final AuthService _authService = AuthService();

  var customer = Rxn<Customer>();
  var isLoading = false.obs;

  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final nikController = TextEditingController();
  final birthDateController = TextEditingController();
  final gender = ''.obs;
  var localPhotoPath = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadCustomerData();
  }

  Future<void> loadCustomerData() async {
    isLoading.value = true;

    final data = await _authService.fetchCustomerData();
    customer.value = data;

    if (data != null) {
      emailController.text = data.email;
      phoneController.text = data.phoneNumber;
      addressController.text = data.address;
      nikController.text = data.idCardNumber;
      birthDateController.text = data.birthDate;

      // INI WAJIB
      gender.value = data.genderRaw.isNotEmpty ? data.genderRaw : 'L';
    }

    isLoading.value = false;
  }

  Future<void> updatePhoto() async {
    try {
      final picker = ImagePicker();
      final XFile? pickedFile =
      await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) return;

      File file = File(pickedFile.path);

      dio.FormData formData = dio.FormData.fromMap({
        "action": "upload_foto",
        "no_rkm_medis": customer.value!.medicalRecord,
        "foto": await dio.MultipartFile.fromFile(file.path),
      });

      final response = await _dioService.dio.post(
        ApiConstants.baseUrl,
        data: formData,
      );

      if (response.statusCode == 200) {
        final imageUrl =
            "${ApiConstants.baseUrl.replaceAll('api.php', '')}photopasien/pages/upload/${customer.value!.medicalRecord}.jpg?v=${DateTime.now().millisecondsSinceEpoch}";

        customer.value =
            customer.value?.copyWith(profilePicture: imageUrl);

        showNotif("Berhasil", "Foto berhasil diperbarui");
      }
    } catch (e) {
      showNotif("Error", "Gagal upload foto", isError: true);
    }
  }


  void showEditDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text("Edit Profil"),
        content: SingleChildScrollView(
          child: Column(
            children: [

              TextField(
                controller: nikController,
                decoration: const InputDecoration(
                  labelText: "NIK",
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: birthDateController,
                decoration: const InputDecoration(
                  labelText: "Tanggal Lahir (YYYY-MM-DD)",
                ),
              ),

              const SizedBox(height: 12),

              Obx(() => DropdownButtonFormField<String>(
                value: gender.value,
                decoration: const InputDecoration(
                  labelText: "Jenis Kelamin",
                ),
                items: const [
                  DropdownMenuItem(
                    value: "L",
                    child: Text("Laki-laki"),
                  ),
                  DropdownMenuItem(
                    value: "P",
                    child: Text("Perempuan"),
                  ),
                ],
                onChanged: (val) {
                  gender.value = val ?? 'L';
                },
              )),

              const SizedBox(height: 12),

              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: "No HP / WA",
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: "Alamat",
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: updateProfile,
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }
  Future<void> updateProfile() async {
    try {
      await _dioService.dio.post(
        ApiConstants.baseUrl,
        queryParameters: {
          "action": "update_profil",
          "no_rkm_medis": customer.value!.medicalRecord,
          "no_ktp": nikController.text,
          "tgl_lahir": birthDateController.text,
          "jk": gender.value,
          "email": emailController.text,
          "no_tlp": phoneController.text,
          "alamat": addressController.text,
        },
      );

      await loadCustomerData();
      Get.back(); // tutup dialog edit

      showNotif("Berhasil", "Profil berhasil diperbarui");

    } catch (e) {
      showNotif("Error", "Gagal update profil", isError: true);
    }
  }

  void showNotif(String title, String message, {bool isError = false}) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

}
