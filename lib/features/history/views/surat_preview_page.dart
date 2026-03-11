import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class SuratPreviewPage extends StatelessWidget {
  final String pdfUrl;

  const SuratPreviewPage({super.key, required this.pdfUrl});

  /// download pdf
  Future<File?> downloadPdf() async {
    try {
      final dir = await getTemporaryDirectory();
      final filePath = "${dir.path}/surat_keterangan_sehat.pdf";

      await Dio().download(pdfUrl, filePath);

      return File(filePath);
    } catch (e) {
      debugPrint("Download error: $e");
      return null;
    }
  }

  /// tombol download
  Future<void> handleDownload(BuildContext context) async {
    final file = await downloadPdf();

    if (file != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("PDF berhasil disimpan di ${file.path}")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Download gagal")),
      );
    }
  }

  /// share whatsapp
  Future<void> handleShare() async {
    final file = await downloadPdf();

    if (file != null) {
      await Share.shareXFiles(
        [XFile(file.path)],
        text: "Surat Keterangan Sehat",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Surat Keterangan"),
        actions: [

          /// tombol download
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => handleDownload(context),
          ),

          /// tombol share
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: handleShare,
          ),
        ],
      ),

      /// preview pdf
      body: SfPdfViewer.network(pdfUrl),
    );
  }
}