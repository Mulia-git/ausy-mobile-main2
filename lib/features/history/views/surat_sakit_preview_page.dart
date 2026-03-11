import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class SuratSakitPreviewPage extends StatelessWidget {

  final String pdfUrl;

  const SuratSakitPreviewPage({
    super.key,
    required this.pdfUrl
  });

  Future<File?> downloadPdf() async {

    try {

      final dir = await getTemporaryDirectory();

      final path = "${dir.path}/surat_sakit.pdf";

      await Dio().download(pdfUrl, path);

      return File(path);

    } catch (e) {

      return null;

    }

  }

  Future<void> sharePdf() async {

    final file = await downloadPdf();

    if(file != null){

      await Share.shareXFiles(
          [XFile(file.path)],
          text: "Surat Keterangan Sakit"
      );

    }

  }

  Future<void> savePdf(BuildContext context) async {

    final file = await downloadPdf();

    if(file != null){

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("PDF tersimpan di ${file.path}")
          )
      );

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Surat Keterangan Sakit"),
        actions: [

          IconButton(
            icon: const Icon(Icons.download),
            onPressed: (){
              savePdf(context);
            },
          ),

          IconButton(
            icon: const Icon(Icons.share),
            onPressed: (){
              sharePdf();
            },
          ),

        ],
      ),

      body: SfPdfViewer.network(pdfUrl),

    );

  }

}