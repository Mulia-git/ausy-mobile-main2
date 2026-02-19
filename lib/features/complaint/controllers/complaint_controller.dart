import 'dart:convert';
import 'package:ausy/core/constants/api_constants.dart';
import 'package:ausy/core/models/complaint.dart';
import 'package:ausy/core/services/complaint_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ComplaintController extends GetxController {
  var complaints = <Complaint>[].obs;
  RxBool isLoading = false.obs;
  RxString searchQuery = ''.obs;

  final ComplaintService _complaintService = ComplaintService();
  final GetStorage storage = GetStorage(); // ✅ FIX

  Future<void> loadComplaint() async {
    isLoading.value = true;
    complaints.value = await _complaintService.fetchComplaint();
    isLoading.value = false;
  }

  void changeQuery(String query) {
    searchQuery.value = query;
  }

  List<Complaint> get filteredComplaints {
    List<Complaint> list = complaints;
    if (searchQuery.value.isNotEmpty) {
      list = list.where((c) =>
          c.message.toLowerCase().contains(searchQuery.value.toLowerCase())).toList();
    }
    return list;
  }

  /// 🔥 KIRIM PENGADUAN
  Future<void> sendComplaint(String message) async {
    try {
      isLoading.value = true;

      final response = await _complaintService.sendComplaint(
        storage.read('medicalRecord') ?? '',
        message,
      );

      if (response == true) {
        await loadComplaint();
        _showSuccess("Pengaduan berhasil dikirim");
      } else {
        _showError("Gagal mengirim pengaduan");
      }
    } catch (e) {
      _showError("Terjadi kesalahan sistem");
    } finally {
      isLoading.value = false;
    }
  }

  void _showSuccess(String msg) {
    Get.dialog(AlertDialog(
      title: const Text("Berhasil"),
      content: Text(msg),
      actions: [TextButton(onPressed: () => Get.back(), child: const Text("OK"))],
    ));
  }

  void _showError(String msg) {
    Get.dialog(AlertDialog(
      title: const Text("Error"),
      content: Text(msg),
      actions: [TextButton(onPressed: () => Get.back(), child: const Text("OK"))],
    ));
  }
}
