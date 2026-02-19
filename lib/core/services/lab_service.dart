import 'dart:convert';

import '../constants/api_constants.dart';

import '../models/lab_detail.dart';
import '../models/lab_item.dart';
import 'dio_service.dart';

class LabService {
  final DioService _dioService = DioService();
  Future<List<LabItem>> fetchLab(String noRawat) async {
    try {
      print("🧪 LOAD LAB for: $noRawat");

      final res = await _dioService.dio.get(
        ApiConstants.baseUrl,
        queryParameters: {
          "action": "lab",
          "no_rawat": noRawat,
        },
      );

      print("📦 STATUS CODE: ${res.statusCode}");
      print("📦 RAW RESPONSE TYPE: ${res.data.runtimeType}");
      print("📦 RAW RESPONSE:");
      print(res.data);

      final data = res.data is String ? jsonDecode(res.data) : res.data;

      print("🔍 KEYS AVAILABLE: ${data.keys}");

      final List pemeriksaan = data['pemeriksaan'] ?? [];
      final List detail = data['detail'] ?? [];

      print("🧾 JUMLAH PEMERIKSAAN: ${pemeriksaan.length}");
      print("🧾 JUMLAH DETAIL: ${detail.length}");

      List<LabItem> result = [];

      for (var p in pemeriksaan) {
        final kode = p['kd_jenis_prw'];

        print("➡️ PROSES PEMERIKSAAN: ${p['nm_perawatan']} ($kode)");

        final relatedDetails = detail
            .where((d) => d['kd_jenis_prw'] == kode)
            .map((d) {
          print("   🔬 DETAIL: ${d['Pemeriksaan']} = ${d['nilai']}");
          return LabDetail.fromJson(d);
        })
            .toList();

        print("   ✅ DETAIL COCOK: ${relatedDetails.length}");

        result.add(
          LabItem(
            kode: kode,
            nama: p['nm_perawatan'],
            tanggal: p['tgl_periksa'],
            jam: p['jam'],
            details: relatedDetails,
          ),
        );
      }

      print("🎯 TOTAL LAB ITEM JADI: ${result.length}");
      return result;

    } catch (e, s) {
      print("❌ ERROR LAB SERVICE: $e");
      print(s);
      return [];
    }
  }

}
