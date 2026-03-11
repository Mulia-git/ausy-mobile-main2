import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../core/services/panic_service.dart';

class PanicPage extends StatefulWidget {
  const PanicPage({super.key});

  @override
  State<PanicPage> createState() => _PanicPageState();
}

class _PanicPageState extends State<PanicPage>
    with SingleTickerProviderStateMixin {

  final PanicService panicService = PanicService();
  final AudioPlayer player = AudioPlayer();

  bool isLoading = false;
  bool isActive = false;
  bool cooldown = false;

  Timer? pollingTimer;
  Timer? cooldownTimer;

  String currentStatus = "";

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController =
    AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..repeat(reverse: true);

    _checkActiveOnOpen();
  }

  /// 🔎 Cek jika ada panic aktif saat buka page
  Future<void> _checkActiveOnOpen() async {
    final active = await panicService.checkActivePanic();
    if (active != null) {
      setState(() {
        isActive = true;
        currentStatus = active['status'];
      });
      _startPolling();
    }
  }

  /// 🚑 Kirim Panic
  Future<void> sendPanic() async {

    if (cooldown) {
      Get.snackbar("Tunggu", "Harap tunggu 3 menit sebelum kirim lagi");
      return;
    }

    final active = await panicService.checkActivePanic();
    if (active != null) {
      Get.snackbar("Masih Aktif", "Sudah ada panic aktif");
      return;
    }

    setState(() => isLoading = true);

    final result = await panicService.sendPanic(
      lat: -7.12,
      lng: 112.45,
      alamat: "Auto GPS",
    );

    if (result != null && result['state'] == 'success') {

      setState(() {
        isActive = true;
        currentStatus = "WAITING";
      });

      _startPolling();
      _startCooldown();
    }

    setState(() => isLoading = false);
  }

  /// ⏱ Auto polling tiap 5 detik
  void _startPolling() {
    pollingTimer?.cancel();

    pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      final active = await panicService.checkActivePanic();

      if (active == null) {
        setState(() => isActive = false);
        pollingTimer?.cancel();
        return;
      }

      if (active['status'] != currentStatus) {
        currentStatus = active['status'];
        _playSound();
      }
    });
  }

  /// 🔊 Notifikasi suara
  void _playSound() async {
    await player.play(AssetSource('sounds/alert.mp3'));
  }

  /// 🕒 Cooldown 3 menit
  void _startCooldown() {
    cooldown = true;

    cooldownTimer?.cancel();
    cooldownTimer = Timer(const Duration(minutes: 3), () {
      cooldown = false;
    });
  }

  /// ❌ Batalkan Panic
  Future<void> cancelPanic() async {
    final success = await panicService.cancelPanic();
    if (success) {
      setState(() => isActive = false);
      pollingTimer?.cancel();
      Get.snackbar("Dibatalkan", "Panic berhasil dibatalkan");
    }
  }

  @override
  void dispose() {
    pollingTimer?.cancel();
    cooldownTimer?.cancel();
    _animationController.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      body: Center(
        child: isActive
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Status: $currentStatus",
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: cancelPanic,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey),
              child: const Text("BATALKAN PANIC"),
            )
          ],
        )
            : isLoading
            ? const CircularProgressIndicator()
            : ScaleTransition(
          scale: Tween(begin: 1.0, end: 1.2)
              .animate(_animationController),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(
                  horizontal: 60, vertical: 25),
              shape: const CircleBorder(),
            ),
            onPressed: sendPanic,
            child: SvgPicture.asset(
              "assets/icons/ambulance.svg",
              width: 44,
              height: 44,
              color: Colors.white,
            ),
        ),
      ),
      ),
    );
  }
}