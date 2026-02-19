import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';

import 'features/auth/controllers/auth_controller.dart';
import 'features/customer/views/antrean_apotek_page.dart';
import 'features/customer/views/antrean_poli_page.dart';
import 'features/customer/views/widgets/notification_box.dart';
import 'features/notification/views/notification_page.dart';
import 'firebase_options.dart';
import 'core/middlewares/auth_middleware.dart';
import 'core/services/dio_service.dart';
import 'core/themes/app_colors.dart';

import 'features/auth/views/login_page.dart';
import 'features/auth/views/register_page.dart';
import 'features/auth/views/forgot_page.dart';
import 'features/home/views/home_page.dart';
import 'features/profile/screens/profile_page.dart';
import 'features/splash/screens/splash_screen.dart';
import 'features/doctor/views/doctor_page.dart';
import 'features/polyclinic/views/polyclinic.dart';
import 'features/room/views/room.dart';
import 'features/available/views/avaliable.dart';
import 'features/book/book_page.dart';
import 'features/book/book_detail_page.dart';
import 'features/payment/views/payment_page.dart';
import 'features/schedule/views/schedule_page.dart';
import 'features/telemedicine/views/telemedicine_page.dart';
import 'features/history/views/ralan_detail_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final dioService = DioService();
  await dioService.initialize();

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: SystemUiOverlay.values,
  );

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  Get.put(AuthController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  StreamSubscription? _sub;
  late final AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  void _initDeepLinks() async {
    _appLinks = AppLinks();

    _appLinks.uriLinkStream.listen(_handleUri, onError: (err) {
    });

    try {
      final initialUri = await _appLinks.getInitialLink();
      _handleUri(initialUri);
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print('⚠️ Gagal menangkap initial URI: $e');
    }
  }

  void _handleUri(Uri? uri) {
    if (uri == null) return;

    final path = uri.pathSegments;
    if (path.contains("account") && path.contains("verify")) {
      Get.toNamed('/verify', arguments: {'token': path.last});
    } else if (path.contains("reset-password")) {
      Get.toNamed('/reset', arguments: {'token': path.last});
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.withClampedTextScaling(
      minScaleFactor: 1.0,
      maxScaleFactor: 1.0,
      child: GetMaterialApp(
        theme: ThemeData(
          primaryColor: AppColor.primary,
          scaffoldBackgroundColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: Colors.black),
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
          dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColor.appBarColor,
            foregroundColor: Colors.black,
            elevation: 0,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            iconTheme: IconThemeData(color: Colors.black),
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/splash',
        getPages: [
          GetPage(name: '/login', page: () => LoginPage()),
          GetPage(name: '/register', page: () => RegisterPage()),
          GetPage(
            name: '/forgot',
            page: () => ForgotPage(),
          ),
          GetPage(name: '/splash', page: () => SplashScreen()),
          GetPage(
              name: '/doctor',
              page: () => const DoctorPage(),
              middlewares: [AuthMiddleware()]),
          GetPage(
              name: '/polyclinic',
              page: () => const PolyclinicPage(),
              middlewares: [AuthMiddleware()]),
          GetPage(
              name: '/room',
              page: () => const RoomPage(),
              middlewares: [AuthMiddleware()]),
          GetPage(
              name: '/available',
              page: () => const AvailablePage(),
              middlewares: [AuthMiddleware()]),
          GetPage(
              name: '/home',
              page: () => HomePage(),
              middlewares: [AuthMiddleware()]),
          GetPage(
              name: '/profile',
              page: () => ProfilePage(),
              middlewares: [AuthMiddleware()]),
          GetPage(
              name: '/app',
              page: () => const BookPage(),
              middlewares: [AuthMiddleware()]),
          GetPage(
              name: '/payment',
              page: () => const PaymentPage(),
              middlewares: [AuthMiddleware()]),
          GetPage(
              name: '/schedule',
              page: () => const SchedulePage(),
              middlewares: [AuthMiddleware()]),
          GetPage(
              name: '/bookdetail',
              page: () => const BookDetailPage(),
              middlewares: [AuthMiddleware()]),
          GetPage(
              name: '/telemedicine',
              page: () => const TelemedicinePage(),
              middlewares: [AuthMiddleware()]),
          GetPage(name: '/ralan-detail', page: () => RalanDetailPage(),
              middlewares: [AuthMiddleware()]),
          GetPage(
            name: '/antreanPoli',
            page: () => const AntreanPoliPage(),
          ),

          GetPage(
            name: '/antreanApotek',
            page: () => const AntreanApotekPage(),
          ),


          GetPage(
            name: '/notification',
            page: () => const NotificationPage(),
          ),
        ],
      ),
    );
  }
}
