import 'package:ausy/core/models/lab_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ausy/core/models/outpatient.dart';
import '../controllers/history_controller.dart';
import 'package:flutter/services.dart';

class RalanDetailPage extends StatefulWidget {
  const RalanDetailPage({super.key});

  @override
  State<RalanDetailPage> createState() => _RalanDetailPageState();
}

class _RalanDetailPageState extends State<RalanDetailPage> {
  late Outpatient data;

  final HistoryController historyController =
  Get.put(HistoryController(), permanent: true);

  @override
  void initState() {
    super.initState();


    data = Get.arguments as Outpatient;


    historyController.loadSoap(data.code);
    if(data.payment == "BPJS KESEHATAN"){
      historyController.loadSep(data.code);

    }
    historyController.loadDiagnosaProsedur(data.code);
    historyController.loadTindakan(data.code);
    historyController.loadObat(data.code);
    historyController.loadLab(data.code);
    historyController.loadRadiologi(data.code);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Kunjungan"),
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          MediaQuery.of(context).padding.bottom + 32,
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _infoTile("Nomor Rawat", data.code, Icons.numbers),
            _infoTile("Tanggal Kunjungan", data.date, Icons.calendar_today),
            _infoTile("Poliklinik", data.polyclinic, Icons.medical_services),
            _infoTile("Dokter", data.doctor, Icons.person),
            _infoTile("Cara Bayar", data.payment, Icons.payment),

            const SizedBox(height: 20),

            /// ================= SOAP =================
            Obx(() => _buildSection(
              title: "S.O.A.P.I.E",
              isLoading: historyController.isLoadingSoap.value,
              isEmpty: historyController.soapList.isEmpty,
              content: Column(
                children: historyController.soapList.map((s) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${s.tanggal} ${s.jam}",
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(s.petugas,
                                style: const TextStyle(color: Colors.black54)),
                          ],
                        ),
                        const Divider(),
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
              ),
            )),
            Obx(() {
              final sep = historyController.sepData.value;

              return _buildSection(
                title: "SEP BPJS",
                isLoading: historyController.isLoading.value,
                isEmpty: sep == null,
                content: sep == null
                    ? const SizedBox()
                    : Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.blue.shade200),
                    color: Colors.blue.shade50,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      _sepRow("No SEP", sep.noSep),
                      _sepRow("Tanggal SEP", sep.tglSep),
                      _sepRow("No Kartu", sep.noKartu),
                      _sepRow("Peserta", sep.peserta),
                      _sepRow("Jenis Pelayanan", sep.jenisPelayanan),
                      _sepRow("Kelas Rawat", sep.kelasRawat),
                      _sepRow("Poli Tujuan", sep.poli),
                      _sepRow("Diagnosa", sep.diagnosa),
                      _sepRow("DPJP", sep.dpjp),
                      if (historyController.sepData.value?.rujukan != null) ...[

                        _sectionTitle("Data Rujukan"),
                        _sepRow("Asal Rujukan", historyController.sepData.value!.rujukan!.asal),
                        _sepRow("Tanggal Rujukan", historyController.sepData.value!.rujukan!.tanggal),
                        _sepRow("No. Rujukan", historyController.sepData.value!.rujukan!.noRujukan),
                        _sepRow("PPK Rujukan", historyController.sepData.value!.rujukan!.ppk),
                      ],


                    ],
                  ),
                ),
              );
            }),


            Obx(() => _buildSection(
              title: "Diagnosa ICD-10",
              isLoading: historyController.isLoadingDiagnosa.value,
              isEmpty: historyController.diagnosaList.isEmpty,
              content: Column(
                children: historyController.diagnosaList
                    .map((d) => _cardItem("${d.kode} - ${d.nama} (${d.status})"))
                    .toList(),
              ),
            )),
            Obx(() => _buildSection(
              title: "Prosedur ICD-9",
              isLoading: false,
              isEmpty: historyController.prosedurList.isEmpty,
              content: Column(
                children: historyController.prosedurList
                    .map((p) => _cardItem("${p.kode} - ${p.nama} (${p.status})"))
                    .toList(),
              ),
            )),


            // /// Placeholder bagian lain
            // _sectionTitle("Pengkajian Risiko Jatuh (Skala Morse)"),
            // const SizedBox(height: 10),

            Obx(() => _buildSection(
              title: "Tindakan",
              isLoading: false,
              isEmpty: historyController.tindakanList.isEmpty,
              content: Column(
                children: historyController.tindakanList.map((t) => _cardItem(
                    "${t.tanggal} ${t.jam}\n${t.nama}\n${t.pelaksana} (${t.tipe})"))
                    .toList(),
              ),
            )),
            // Obx(() => _buildSection(
            //   title: "Obat / BHP / Alkes",
            //   isLoading: false,
            //   isEmpty: historyController.obatList.isEmpty,
            //   content: Column(
            //     children: historyController.obatList
            //         .map((o) => _cardItem("${o.tanggal} ${o.jam}\n${o.nama}"))
            //         .toList(),
            //   ),
            // )),

            Obx(() {
            if (historyController.tindakanRanapDokterList.isEmpty) return const SizedBox();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle("Tindakan Rawat Inap Dokter"),
                ...historyController.tindakanRanapDokterList.map((t) => _cardItem(
                    "${t.tanggal} ${t.jam}\n${t.nama}\nDokter: ${t.dokter}"
                ))
              ],
            );
          }),


            _sectionTitle("Obat / BHP / Alkes"),
            Obx(()=>Column(
              children: historyController.obatList.map((o)=>_cardItem(
                  "${o.tanggal} ${o.jam}"
                      "\n${o.nama}"
                      // "\n${o.jumlah} ${o.satuan}"
                      // "\nAturan: ${o.aturan}"
              )).toList(),
            )),

            Obx(() => _buildSection(
              title: "Pemeriksaan Laboratorium",
              isLoading: false,
              isEmpty: historyController.labList.isEmpty,
              content: Column(
                children: historyController.labList.map((item) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),


                        title: Text(
                          item.nama,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),

                        subtitle: Text("${item.tanggal} ${item.jam}"),

                        iconColor: Colors.green,
                        collapsedIconColor: Colors.grey,


                        children: [
                          const SizedBox(height: 8),
                          _labTable(item.details),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            )),



            Obx(() {
          final r = historyController.radiologiData.value;
          if (r == null ||
              (r.pemeriksaan.isEmpty && r.hasil.isEmpty && r.gambar.isEmpty)) {
            return const SizedBox();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle("Pemeriksaan Radiologi"),

              // 📌 Tindakan Radiologi
              ...r.pemeriksaan.map((e) => _cardItem(
                  "${e.tanggal} ${e.jam}\n${e.nama}\nDokter: ${e.dokter}\nPetugas: ${e.petugas}\n${e.proyeksi}\nBiaya: Rp ${e.biaya}"
              )),

              // 📌 Hasil Bacaan
              if (r.hasil.isNotEmpty) _sectionTitle("Hasil Radiologi"),
              ...r.hasil.map((h) => _cardItem(
                  "${h.tanggal} ${h.jam}\n${h.hasil}"
              )),

              // 📌 Gambar
              if (r.gambar.isNotEmpty) _sectionTitle("Gambar Radiologi"),
              ...r.gambar.map((g) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: g.url.isNotEmpty
                    ? Image.network(
                  g.url,
                  errorBuilder: (c, e, s) => const SizedBox(),
                )
                    : const SizedBox(),

              )),
            ],
          );
        }),
        Obx(() {
          final o = historyController.operasiData.value;
          if (o == null || (o.operasi.isEmpty && o.laporan.isEmpty)) {
            return const SizedBox();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              if (o.operasi.isNotEmpty) _sectionTitle("Operasi / VK"),
              ...o.operasi.map((op) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${op.tanggal} - ${op.nama}",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text("Kode: ${op.kode}"),
                    Text("Anastesi: ${op.anastesi}"),
                    const Divider(),


                    ...op.tim.map((t) => Text("${t.peran}: ${t.nama}")),

                    const Divider(),

                  ],
                ),
              )),


              if (o.laporan.isNotEmpty) _sectionTitle("Laporan Operasi"),
              ...o.laporan.map((l) => _cardItem(
                  "Tanggal: ${l.tanggal}\n"
                      "Pre Op: ${l.preOp}\n"
                      "Post Op: ${l.postOp}\n"
                      "Jaringan: ${l.jaringan}\n"
                      "Selesai: ${l.selesai}\n"
                      "PA: ${l.pa}\n\n"
                      "${l.laporan}"
              )),
            ],
          );
        }),

        ],
        ),
      ),
    );
  }

  /// ================= WIDGET BANTU =================

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
                    style: const TextStyle(fontSize: 12, color: Colors.black54)),
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
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _soapRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600, color: Colors.green)),
          const SizedBox(height: 2),
          Text(value.isEmpty ? "-" : value,
              style: const TextStyle(fontSize: 14)),
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

