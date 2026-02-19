import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class AntreanApotekPage extends StatefulWidget {
  const AntreanApotekPage({super.key});

  @override
  State<AntreanApotekPage> createState() => _AntreanApotekPageState();
}

class _AntreanApotekPageState extends State<AntreanApotekPage> {
  late final WebViewController controller;
  bool isOffline = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkConnection();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (_) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (error) {
            setState(() {
              isOffline = true;
              isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(
        Uri.parse("https://sim.rsaurasyifa.com/anjungan/apotek"),
      );
  }

  Future<void> _checkConnection() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      setState(() {
        isOffline = true;
        isLoading = false;
      });
    }
  }

  Future<void> _refresh() async {
    await _checkConnection();
    if (!isOffline) {
      controller.reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Antrean Apotek"),
      ),
      body: Stack(
        children: [
          isOffline
              ? _offlineWidget()
              : RefreshIndicator(
            onRefresh: _refresh,
            child: WebViewWidget(controller: controller),
          ),

          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _offlineWidget() {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        children: const [
          SizedBox(height: 150),
          Icon(Icons.local_pharmacy, size: 80, color: Colors.grey),
          SizedBox(height: 20),
          Center(
            child: Text(
              "Layanan apotek tidak dapat dimuat.\nPeriksa koneksi internet Anda.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(height: 400),
        ],
      ),
    );
  }
}
