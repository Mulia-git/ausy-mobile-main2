import 'package:ausy/core/constants/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioService {
  final GetStorage storage = GetStorage();
  late Dio dio;
  DioService._internal() {
    dio = Dio();
  }

  static final DioService _instance = DioService._internal();

  factory DioService() => _instance;

  Future<void> initialize() async {
    dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Ambil token dari GetStorage
          String token = ApiConstants.token;
          options.queryParameters['token'] = token;
          return handler.next(options);
        },
      ),
      // PrettyDioLogger(
      //   // For logging
      //   requestHeader: true,
      //   requestBody: true,
      //   responseBody: true,
      //   responseHeader: false,
      //   compact: true,
      //   maxWidth: 90,
      // ),
    ]);
  }
}
