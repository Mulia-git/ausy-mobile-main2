import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class AntreanPoliPage extends StatefulWidget {
  const AntreanPoliPage({super.key});

  @override
  State<AntreanPoliPage> createState() => _AntreanPoliPageState();
}

class _AntreanPoliPageState extends State<AntreanPoliPage> {
  late final WebViewController controller;
  bool isOffline = false;

  @override
  void initState() {
    super.initState();
    _checkConnection();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (error) {
            setState(() {
              isOffline = true;
            });
          },
        ),
      )
      ..loadRequest(
        Uri.parse("https://sim.rsaurasyifa.com/anjungan/poli?kode=JAN,RAD,KLT,SAR,OBG,INT,JIW,MAT,ORT,BDM,BDA,BDP,BED,URO,THT,PAR,JAN,JIW,MAT,GIGI,ORT,BDM,BDA,BDP,BED,URO,THT,PAR,ANA"),
      );
  }

  Future<void> _checkConnection() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      setState(() {
        isOffline = true;
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
        title: const Text("Antrean Poli"),
      ),
      body: isOffline
          ? _offlineWidget()
          : RefreshIndicator(
        onRefresh: _refresh,
        child: WebViewWidget(controller: controller),
      ),
    );
  }

  Widget _offlineWidget() {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        children: const [
          SizedBox(height: 150),
          Icon(Icons.wifi_off, size: 80, color: Colors.grey),
          SizedBox(height: 20),
          Center(
            child: Text(
              "Tidak ada koneksi internet.\nSilakan periksa jaringan Anda.",
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
