import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'dio_service.dart';
import '../constants/api_constants.dart';
import '../models/notification.dart';

class NotificationService {
  final DioService _dioService = DioService();

  /// 🔔 Ambil LIST NOTIFIKASI (FIX STRING JSON)
  Future<List<Notification>> fetchNotificationList(String noRkmMedis) async {
    try {
      final res = await _dioService.dio.get(
        ApiConstants.baseUrl,
        queryParameters: {
          "action": "notifikasilist",
          "no_rkm_medis": noRkmMedis,
        },
      );

      if (res.data == null) return [];

      final dynamic decoded =
      res.data is String ? jsonDecode(res.data) : res.data;

      if (decoded is! List) return [];

      return decoded.map<Notification>((e) {
        return Notification.fromJson({
          "id": e["id"]?.toString() ?? "",
          "judul": e["judul"] ?? "",
          "pesan": e["pesan"] ?? "",
          "tipe": e["tipe"] ?? "",
          "url": e["url"] ?? "",
        });
      }).toList();
    } catch (e, s) {
      debugPrint('🔥 ERROR FETCH NOTIFICATION');
      debugPrint(e.toString());
      debugPrint(s.toString());
      return [];
    }
  }

  /// ✅ Tandai sudah dibaca
  Future<bool> markNotificationAsRead(String id) async {
    try {
      final res = await _dioService.dio.get(
        ApiConstants.baseUrl,
        queryParameters: {
          "action": "tandaisudahdibaca",
          "id": id,
        },
      );

      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

}
