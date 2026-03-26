import 'dart:convert';
import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../models/resume_model.dart';
import '../models/resume_ranap_model.dart';

class ResumeService {
  final Dio dio = Dio();

  Future<ResumeModel?> getResume(String noRawat) async {
    try {
      final response = await dio.get(
        ApiConstants.baseUrl,
        queryParameters: {
          "action": "resume",
          "no_rawat": noRawat,
          "token": ApiConstants.token,
        },
      );

      print("RAW RESPONSE: ${response.data}");

      /// 🔥 HANDLE STRING RESPONSE
      final data = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      if (data['resume'] == null) return null;

      return ResumeModel.fromJson(data['resume']);
    } catch (e) {
      print("ERROR RESUME: $e");
      return null;
    }
  }
  Future<ResumeRanapModel?> getResumeRanap(String noRawat) async {
    try {
      final response = await dio.get(
        ApiConstants.baseUrl,
        queryParameters: {
          "action": "resume_ranap",
          "no_rawat": noRawat,
          "token": ApiConstants.token, // 🔥 WAJIB
        },
      );
      print("RAW RESPONSE: ${response.data}");
      final data = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      if (data['resume'] == null) return null;

      return ResumeRanapModel.fromJson(data['resume']);
    } catch (e) {
      print("ERROR RESUME RANAP: $e");
      return null;
    }
  }
}