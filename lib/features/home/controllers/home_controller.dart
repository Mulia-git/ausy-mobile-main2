import 'dart:io';

import 'package:ausy/features/blog/views/blog_page.dart';
import 'package:ausy/features/complaint/views/complaint_page.dart';
import 'package:ausy/features/customer/views/customer_page.dart';
import 'package:ausy/features/account/views/account_page.dart';
import 'package:ausy/features/history/views/history_page.dart';
import 'package:ausy/features/auth/controllers/auth_controller.dart';
import 'package:ausy/core/constants/api_constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/dio_service.dart';
import '../../../core/services/fcm_service.dart';


class HomeController extends GetxController {
  final Dio _dio = DioService().dio;
  final FcmService _fcmService = FcmService();

  // Bottom navigation
  var selectedIndex = 0.obs;

  final List<Widget> pages = [
    const CustomerPage(),
    BlogPage(),
    const HistoryPage(),
    const ComplaintPage(),
    const SettingsPage(),
  ];

  @override
  void onInit() {
    super.onInit();
    _sendToken();
  }

  void onNavItemTapped(int index) {
    selectedIndex.value = index;
  }

  Future<void> _sendToken() async {
    final auth = Get.find<AuthController>();
    final noRkmMedis = auth.noRkmMedis;

    if (noRkmMedis.isEmpty) return;

    final success =
    await _fcmService.saveDeviceToken(noRkmMedis: noRkmMedis);

    if (success) {
      print('✅ Device token BENAR-BENAR tersimpan di DB');
    } else {
      print('❌ Gagal simpan device token ke server');
    }
  }
}
