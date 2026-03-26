import 'package:ausy/core/models/lab_detail.dart';
import 'package:ausy/features/history/views/surat_preview_page.dart';
import 'package:ausy/features/history/views/surat_sakit_preview_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ausy/core/models/outpatient.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/models/surat_model.dart';
import '../../../core/services/SuratService.dart';
import '../controllers/history_controller.dart';
import 'package:flutter/services.dart';

class RalanDetailPage extends StatefulWidget {
  const RalanDetailPage({super.key});

  @override
  State<RalanDetailPage> createState() => _RalanDetailPageState();
}

class _RalanDetailPageState extends State<RalanDetailPage> {
  late Outpatient data;

  final SuratService suratService = SuratService();
  final ScrollController _tabScrollController = ScrollController();
  final HistoryController historyController = Get.find(); // FIX

  @override
  void initState() {
    super.initState();

    data = Get.arguments as Outpatient;

    historyController.loadSoap(data.code);
    historyController.loadDiagnosaProsedur(data.code);
    historyController.loadTindakan(data.code);
    historyController.loadObat(data.code);
    historyController.loadLab(data.code);
    historyController.loadRadiologi(data.code);
    historyController.loadSurat(data.code);
    historyController.loadSuratSakit(data.code);
    historyController.loadSep(data.code);
    historyController.loadResume(data.code);
  }

  Widget build(BuildContext context) {
    return Obx(() {
      final tabs = <Tab>[];
      final views = <Widget>[];

      /// ================= ISI TAB DULU =================

      tabs.add(const Tab(text: "Info"));
      views.add(_buildInfoTab());

      if (historyController.resumeData.value != null) {
        tabs.add(const Tab(text: "Resume"));
        views.add(_buildResumeTab());
      }

      if (historyController.soapList.isNotEmpty) {
        tabs.add(const Tab(text: "SOAP"));
        views.add(_buildSoapTab());
      }

      if (data.payment.toLowerCase().contains("bpjs") &&
          historyController.sepData.value != null) {
        tabs.add(const Tab(text: "SEP"));
        views.add(_buildSepTab());
      }

      if (historyController.diagnosaList.isNotEmpty) {
        tabs.add(const Tab(text: "Diagnosa"));
        views.add(_buildDiagnosaTab());
      }

      if (historyController.tindakanList.isNotEmpty) {
        tabs.add(const Tab(text: "Tindakan"));
        views.add(_buildTindakanTab());
      }

      if (historyController.obatList.isNotEmpty) {
        tabs.add(const Tab(text: "Obat"));
        views.add(_buildObatTab());
      }

      if (historyController.labList.isNotEmpty) {
        tabs.add(const Tab(text: "Lab"));
        views.add(_buildLabTab());
      }

      final r = historyController.radiologiData.value;
      if (r != null &&
          (r.pemeriksaan.isNotEmpty ||
              r.hasil.isNotEmpty ||
              r.gambar.isNotEmpty)) {
        tabs.add(const Tab(text: "Radiologi"));
        views.add(_buildRadiologiTab());
      }

      final o = historyController.operasiData.value;
      if (o != null &&
          (o.operasi.isNotEmpty || o.laporan.isNotEmpty)) {
        tabs.add(const Tab(text: "Operasi"));
        views.add(_buildOperasiTab());
      }

      /// ================= BARU RETURN UI =================
      return DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Detail Kunjungan"),
            backgroundColor: Colors.white,
            elevation: 0,
          ),

          body: tabs.isEmpty
              ? const Center(child: Text("Tidak ada data"))
              : Column(
            children: [


              /// ================= TAB =================
              SizedBox(
                height: 48,
                child: Stack(
                  children: [

                    /// TAB BAR
                    SingleChildScrollView(
                      controller: _tabScrollController,
                      scrollDirection: Axis.horizontal,
                      child: TabBar(
                        isScrollable: true,
                        labelColor: Colors.green,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.green,
                        labelStyle: const TextStyle(
                          fontSize: 13, // kecilkan dikit
                          fontWeight: FontWeight.w600,
                        ),
                        tabs: tabs.map((t) {
                          return Tab(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                (t.text ?? ""),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    /// INDICATOR KIRI
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          _tabScrollController.animateTo(
                            _tabScrollController.offset - 100,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        },
                        child: Container(
                          width: 40,
                          color: Colors.white.withOpacity(0.7),
                          child: const Icon(Icons.chevron_left),
                        ),
                      ),
                    ),

                    /// INDICATOR KANAN
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          _tabScrollController.animateTo(
                            _tabScrollController.offset + 100,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        },
                        child: Container(
                          width: 40,
                          color: Colors.white.withOpacity(0.7),
                          child: const Icon(Icons.chevron_right),
                        ),
                      ),
                    ),
                  ],
                ),
              ),


              /// ================= CONTENT =================
              Expanded(
                child: TabBarView(children: views),
              ),
            ],
          ),
        ),
      );
    });
  }

  /// ================= WIDGET BANTU =================
  Widget _suratButton(String title, String url, {required bool isSakit}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0,
          shadowColor: Colors.transparent,
          side: const BorderSide(color: Colors.red, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          if (isSakit) {
            Get.to(() => SuratSakitPreviewPage(pdfUrl: url));
          } else {
            Get.to(() => SuratPreviewPage(pdfUrl: url));
          }
        },
        icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
        label: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  Widget _infoTile(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.green),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.black54)),
                const SizedBox(height: 4),
                Text(value,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _cardItem(String title) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        title.isEmpty ? "-" : title,
        style: const TextStyle(
          fontSize: 14,
          height: 1.5,
        ),
        softWrap: true,
      ),
    );
  }

  Widget _soapRow(String label, String value) {
    if (value
        .trim()
        .isEmpty || value == "-") return const SizedBox();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔹 LABEL
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),

          const SizedBox(height: 4),

          /// 🔹 ISI
          Text(
            value.replaceAll("\n", "\n\n"),
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sepRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(title,
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildSection({
    required bool isLoading,
    required bool isEmpty,
    required String title,
    required Widget content,
  }) {
    if (isLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(title),
          const Center(child: CircularProgressIndicator()),
          const SizedBox(height: 16),
        ],
      );
    }

    if (isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(title),
        content,
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSoapTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: historyController.soapList.map((s) {
        return Card(
          child: ExpansionTile(
            title: Text("${s.tanggal} ${s.jam}"),
            subtitle: Text(s.petugas),
            children: [
              _soapRow("Subjektif", s.subjektif),
              _soapRow("Objektif", s.objektif),
              _soapRow("Asesmen", s.asesmen),
              _soapRow("Plan", s.plan),
              _soapRow("Instruksi", s.instruksi),
              _soapRow("Evaluasi", s.evaluasi),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSepTab() {
    final sep = historyController.sepData.value;

    if (sep == null) return const Center(child: Text("Data SEP tidak ada"));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sepRow("No SEP", sep.noSep),
          _sepRow("Tanggal SEP", sep.tglSep),
          _sepRow("No Kartu", sep.noKartu),
          _sepRow("Peserta", sep.peserta),

          const SizedBox(height: 10),
          _sectionTitle("Pelayanan"),
          _sepRow("Jenis", sep.jenisPelayanan),
          _sepRow("Kelas", sep.kelasRawat),

          const SizedBox(height: 10),
          _sectionTitle("Diagnosa"),
          _sepRow("Diagnosa", sep.diagnosa),
          _sepRow("DPJP", sep.dpjp),

          if (sep.rujukan != null) ...[
            const SizedBox(height: 10),
            _sectionTitle("Rujukan"),
            _sepRow("Asal", sep.rujukan!.asal),
            _sepRow("Tanggal", sep.rujukan!.tanggal),
            _sepRow("No Rujukan", sep.rujukan!.noRujukan),
            _sepRow("PPK", sep.rujukan!.ppk),
          ],
        ],
      ),
    );
  }

  Widget _buildDiagnosaTab() {
    final diagnosa = historyController.diagnosaList;
    final prosedur = historyController.prosedurList;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// ================= DIAGNOSA =================
          _sectionTitle("Diagnosa ICD-10"),
          const SizedBox(height: 8),

          if (diagnosa.isEmpty)
            const Text(
              "Tidak ada data diagnosa",
              style: TextStyle(color: Colors.grey),
            )
          else
            ...diagnosa.map((d) =>
                _cardItem(
                  "${d.kode} - ${d.nama} (${d.status})",
                )),

          const SizedBox(height: 20),

          /// ================= PROSEDUR =================
          _sectionTitle("Prosedur ICD-9"),
          const SizedBox(height: 8),

          if (prosedur.isEmpty)
            const Text(
              "Tidak ada data prosedur",
              style: TextStyle(color: Colors.grey),
            )
          else
            ...prosedur.map((p) =>
                _cardItem(
                  "${p.kode} - ${p.nama} (${p.status})",
                )),
        ],
      ),
    );
  }

  Widget _buildTindakanTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: historyController.tindakanList.map((t) =>
          _cardItem("${t.tanggal} ${t.jam}\n${t.nama}")).toList(),
    );
  }

  Widget _buildObatTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: historyController.obatList.map((o) =>
          _cardItem("${o.tanggal} ${o.jam}\n${o.nama}")).toList(),
    );
  }

  Widget _buildLabTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: historyController.labList.map((item) {
        return Card(
          child: ExpansionTile(
            title: Text(item.nama),
            subtitle: Text("${item.tanggal} ${item.jam}"),
            children: [_labTable(item.details)],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRadiologiTab() {
    final r = historyController.radiologiData.value;

    if (r == null) {
      return const Center(child: Text("Tidak ada data radiologi"));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 📌 PEMERIKSAAN
          if (r.pemeriksaan.isNotEmpty) ...[
            _sectionTitle("Pemeriksaan Radiologi"),
            const SizedBox(height: 8),

            ...r.pemeriksaan.map((e) =>
                _cardItem(
                  "${e.tanggal} ${e.jam}\n"
                      "${e.nama}\n"
                      "Dokter: ${e.dokter}\n"
                      "Petugas: ${e.petugas}\n"
                      "${e.proyeksi}\n"
                      "Biaya: Rp ${e.biaya}",
                )),
            const SizedBox(height: 12),
          ],

          /// 📌 HASIL
          if (r.hasil.isNotEmpty) ...[
            _sectionTitle("Hasil Radiologi"),
            const SizedBox(height: 8),

            ...r.hasil.map((h) =>
                _cardItem(
                  "${h.tanggal} ${h.jam}\n${h.hasil}",
                )),
            const SizedBox(height: 12),
          ],

          /// 📌 GAMBAR
          if (r.gambar.isNotEmpty) ...[
            _sectionTitle("Gambar Radiologi"),
            const SizedBox(height: 8),

            ...r.gambar.map((g) =>
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: g.url.isNotEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: GestureDetector(
                      onTap: () {
                        _showImagePreview(g.url);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          g.url,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                      : const SizedBox(),
                )),
          ],
        ],
      ),
    );
  }

  void _showImagePreview(String url) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      builder: (_) {
        return GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: InteractiveViewer(
                child: Image.network(url),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOperasiTab() {
    final o = historyController.operasiData.value;

    if (o == null) {
      return const Center(child: Text("Tidak ada data operasi"));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 📌 DATA OPERASI
          if (o.operasi.isNotEmpty) ...[
            _sectionTitle("Operasi / VK"),
            const SizedBox(height: 8),

            ...o.operasi.map((op) =>
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${op.tanggal} - ${op.nama}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text("Kode: ${op.kode}"),
                      Text("Anestesi: ${op.anastesi}"),

                      const Divider(),

                      /// 👨‍⚕️ TIM OPERASI
                      ...op.tim.map((t) => Text("${t.peran}: ${t.nama}")),
                    ],
                  ),
                )),
            const SizedBox(height: 12),
          ],

          /// 📌 LAPORAN OPERASI
          if (o.laporan.isNotEmpty) ...[
            _sectionTitle("Laporan Operasi"),
            const SizedBox(height: 8),

            ...o.laporan.map((l) =>
                _cardItem(
                  "Tanggal: ${l.tanggal}\n"
                      "Pre Op: ${l.preOp}\n"
                      "Post Op: ${l.postOp}\n"
                      "Jaringan: ${l.jaringan}\n"
                      "Selesai: ${l.selesai}\n"
                      "PA: ${l.pa}\n\n"
                      "${l.laporan}",
                )),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildGroupedLab(List<LabDetail> details) {
    List<Widget> widgets = [];
    String currentGroup = "";

    for (var d in details) {
      final upper = d.nama.toUpperCase();

      // 📌 Deteksi judul group
      if (upper.contains("MAKROSKOPIS") ||
          upper.contains("MIKROSKOPIS") ||
          upper.contains("SEDIMEN")) {
        currentGroup = upper;
        widgets.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              currentGroup,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.green),
            ),
          ),
        );
        continue;
      }

      widgets.add(_labRow(d));
    }

    return widgets;
  }

  Widget _labRow(LabDetail d) {
    Color valueColor = Colors.black;
    FontWeight weight = FontWeight.normal;

    if (d.flag == "H") {
      valueColor = Colors.red;
      weight = FontWeight.bold;
    } else if (d.flag == "L") {
      valueColor = Colors.blue;
      weight = FontWeight.bold;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(d.nama),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "${d.nilai} ${d.satuan}",
              style: TextStyle(color: valueColor, fontWeight: weight),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              d.rujukan,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [

          _infoTile("Nomor Rawat", data.code, Icons.numbers),
          _infoTile("Tanggal Kunjungan", data.date, Icons.calendar_today),
          _infoTile("Poliklinik", data.polyclinic, Icons.medical_services),
          _infoTile("Dokter", data.doctor, Icons.person),
          _infoTile("Cara Bayar", data.payment, Icons.payment),

          /// surat sehat
          Obx(() {
            final surat = historyController.suratData.value;
            if (surat == null) return const SizedBox();

            final url =
                "https://apam.rsaurasyifa.com/api/apam/"
                "?action=surat_keterangan_sehat_pdf"
                "&no_rawat=${Uri.encodeComponent(data.code)}"
                "&token=${Uri.encodeComponent(ApiConstants.token)}";

            return _suratButton(
              "Lihat Surat Keterangan Sehat",
              url,
              isSakit: false,
            );
          }),

          /// surat sakit
          Obx(() {
            final surat = historyController.suratSakit.value;
            if (surat == null) return const SizedBox();

            final url =
                "https://apam.rsaurasyifa.com/api/apam/"
                "?action=surat_keterangan_sakit_pdf"
                "&no_rawat=${Uri.encodeComponent(data.code)}"
                "&token=${Uri.encodeComponent(ApiConstants.token)}";

            return _suratButton(
              "Lihat Surat Keterangan Sakit",
              url,
              isSakit: true,
            );
          }),
        ],
      ),
    );
  }
  List<String> _parseObat(String obat) {
    if (obat.isEmpty || obat == "-") return [];

    return obat
        .split(",")
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }
  Widget _obatItem(String text) {
    final parts = text.split(" ");

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.circle, size: 8, color: Colors.green),
          const SizedBox(width: 10),

          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 14),
                children: [
                  TextSpan(text: parts.first + " "),
                  TextSpan(
                    text: parts.sublist(1).join(" "),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildResumeTab() {
    return Obx(() {
      if (historyController.isLoadingResume.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final data = historyController.resumeData.value;
      if (data == null) {
        return const Center(child: Text("Data resume tidak ada"));
      }
      final obatList = _parseObat(data.obatPulang);
      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _sectionTitle("Keluhan Utama"),
            _cardItem(data.keluhanUtama),

            _sectionTitle("Riwayat Penyakit"),
            _cardItem(data.riwayatPenyakit),

            _sectionTitle("Pemeriksaan Penunjang"),
            _cardItem(data.pemeriksaanPenunjang),

            _sectionTitle("Hasil Laborat"),
            _cardItem(data.hasilLaborat),

            _sectionTitle("Diagnosa Utama"),
            _cardItem("${data.diagnosaUtama} (${data.kodeDiagnosaUtama})"),

            if (data.diagnosaSekunder.isNotEmpty) ...[
              _sectionTitle("Diagnosa Sekunder"),
              ...data.diagnosaSekunder.map((e) => _cardItem(e)),
            ],

            _sectionTitle("Prosedur Utama"),
            _cardItem("${data.prosedurUtama} (${data.kodeProsedurUtama})"),

            if (data.prosedurSekunder.isNotEmpty) ...[
              _sectionTitle("Prosedur Sekunder"),
              ...data.prosedurSekunder.map((e) => _cardItem(e)),
            ],

            _sectionTitle("Kondisi Pulang"),
            _cardItem(data.kondisiPulang),



      _sectionTitle("Obat Pulang"),

      if (obatList.isEmpty)
      _cardItem("-")
      else
      ...obatList.map((e) => _obatItem(e)),
          ],
        ),
      );
    });
  }
}
Widget _labTable(List<LabDetail> details) {
  return Table(
    border: TableBorder.all(color: Colors.grey.shade300),
    columnWidths: const {
      0: FlexColumnWidth(3),
      1: FlexColumnWidth(2),
      2: FlexColumnWidth(2),
    },
    children: [
      /// HEADER
      TableRow(
        decoration: BoxDecoration(color: Colors.grey.shade200),
        children: const [
          _TableCell("Detail Pemeriksaan", bold: true),
          _TableCell("Hasil", bold: true),
          _TableCell("Nilai Rujukan", bold: true),
        ],
      ),

      /// DATA
      ...details.map((d) {
        final isGroup = d.nilai.isEmpty && d.rujukan.isEmpty;

        if (isGroup) {
          return TableRow(
            decoration: BoxDecoration(color: Colors.green.shade50),
            children: [
              _TableCell(d.nama, bold: true, color: Colors.green),
              const _TableCell(""),
              const _TableCell(""),
            ],
          );
        }

        Color valueColor = Colors.black;
        FontWeight weight = FontWeight.normal;

        if (d.flag == "H") {
          valueColor = Colors.red;
          weight = FontWeight.bold;
        } else if (d.flag == "L") {
          valueColor = Colors.blue;
          weight = FontWeight.bold;
        }

        return TableRow(
          children: [
            _TableCell(d.nama),
            _TableCell(
              "${d.nilai} ${d.satuan}",
              color: valueColor,
              bold: weight == FontWeight.bold,
            ),
            _TableCell(d.rujukan),
          ],
        );
      }).toList(),
    ],
  );
}

class _TableCell extends StatelessWidget {
  final String text;
  final bool bold;
  final Color? color;

  const _TableCell(this.text, {this.bold = false, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text.isEmpty ? "-" : text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          color: color ?? Colors.black,
        ),
      ),
    );
  }
}

