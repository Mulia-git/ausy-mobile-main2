import 'dart:convert';

import 'package:ausy/core/models/billing.dart';
import 'package:ausy/core/models/booking.dart';
import 'package:ausy/core/models/inpatient.dart';
import 'package:ausy/core/models/outpatient.dart';
import 'package:ausy/core/services/billing_service.dart';
import 'package:ausy/core/services/booking_service.dart';
import 'package:ausy/core/services/inpatient_service.dart';
import 'package:ausy/core/services/outpatient_service.dart';
import 'package:get/get.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/models/diagnosa_model.dart';
import '../../../core/models/lab_item.dart';

import '../../../core/models/obat_model.dart';
import '../../../core/models/operasi_model.dart';
import '../../../core/models/prosedure_model.dart';
import '../../../core/models/radiologi_model.dart';
import '../../../core/models/sep_bpjs.dart';
import '../../../core/models/soap_model.dart';
import '../../../core/models/tindakan_model.dart';
import '../../../core/models/tindakan_ranap_dokter.dart';
import '../../../core/services/diagnosa_service.dart';
import '../../../core/services/dio_service.dart';
import '../../../core/services/lab_service.dart';
import '../../../core/services/obat_service.dart';
import '../../../core/services/operasi_service.dart';
import '../../../core/services/radiologi_service.dart';
import '../../../core/services/ranap_dokter_service.dart';
import '../../../core/services/sep_service.dart';
import '../../../core/services/soap_service.dart';
import '../../../core/services/tindakan_service.dart';

class HistoryController extends GetxController {
  // List dokter dari API
  var billings = <Billing>[].obs;
  var bookings = <Booking>[].obs;
  var outpatients = <Outpatient>[].obs;
  var inpatients = <Inpatient>[].obs;
  var diagnosaList = <Diagnosa>[].obs;
  var prosedurList = <Prosedur>[].obs;
  var isLoadingDiagnosa = false.obs;
  // Loading indicator
  RxBool isLoading = false.obs;
  Rx<SepBpjs?> sepData = Rx<SepBpjs?>(null);
  RxBool isLoadingSep = false.obs;
  // Tanggal terpilih
  RxString date = ''.obs;
  var tindakanList = <Tindakan>[].obs;
  var obatList = <Obat>[].obs;
  // Filter pencarian lokal (nama / poli)
  RxString searchQuery = ''.obs;
  final DioService _dioService = DioService();
  // Filter shift waktu (Semua, Pagi, Sore, Malam)
  RxString selectedCategory = 'Booking'.obs;
  var soapList = <Soap>[].obs;
  var isLoadingSoap = false.obs;
  final BillingService _billingService = BillingService();
  final BookingService _bookingService = BookingService();
  final OutpatientService _outpatientService = OutpatientService();
  final InpatientService _inpatientService = InpatientService();
  final TindakanService _tindakanService = TindakanService();
  final ObatService _obatService = ObatService();
  var tindakanRanapDokterList = <TindakanRanapDokter>[].obs;
  final _tindakanRanapDokterService = TindakanRanapDokterService();

  final _labService = LabService();
  var radiologiData = Rx<RadiologiModel?>(null);
  final _radiologiService = RadiologiService();

  // Ambil data dokter berdasarkan tanggal
  Future<void> loadBilling() async {
    isLoading.value = true;
    billings.value = await _billingService.fetchBlling();
    isLoading.value = false;
  }

  // Ambil data dokter berdasarkan tanggal
  Future<void> loadBooking() async {
    isLoading.value = true;
    bookings.value = await _bookingService.fetchBooking();
    isLoading.value = false;
  }

  // Ambil data dokter berdasarkan tanggal
  Future<void> loadOutpatient() async {
    isLoading.value = true;
    outpatients.value = await _outpatientService.fetchOutPatients();
    isLoading.value = false;
  }

  // Ambil data dokter berdasarkan tanggal
  Future<void> loadInpatient() async {
    isLoading.value = true;
    inpatients.value = await _inpatientService.fetchInPatients();
    isLoading.value = false;
  }

  // Ganti teks pencarian
  void changeQuery(String query) {
    searchQuery.value = query;
  }

  // Ganti shift (Pagi/Sore/Malam)
  void changeCategory(String category) {
    selectedCategory.value = category;
    if (category == 'Billing') {
      loadBilling();
    }
    if (category == 'Booking') {
      loadBooking();
    }
    if (category == 'Ralan') {
      loadOutpatient();
    }
    if (category == 'Ranap') {
      loadInpatient();
    }
  }

  // Daftar dokter hasil filter
  List<Billing> get filteredBillings {
    List<Billing> list = billings;
    // Filter teks
    if (searchQuery.value.isNotEmpty) {
      list = list.where((billing) {
        final query = searchQuery.value.toLowerCase();
        return billing.code.toLowerCase().contains(query);
      }).toList();
    }

    return list;
  }

  // Daftar dokter hasil filter
  List<Booking> get filteredBookings {
    List<Booking> list = bookings;
    // Filter teks
    if (searchQuery.value.isNotEmpty) {
      list = list.where((booking) {
        final query = searchQuery.value.toLowerCase();
        return booking.doctor.toLowerCase().contains(query) ||
            booking.polyclinic.toLowerCase().contains(query) ||
            booking.insurance.toLowerCase().contains(query) ||
            booking.registerDate.toLowerCase().contains(query) ||
            booking.status.toLowerCase().contains(query);
      }).toList();
    }

    return list;
  }

  // Daftar dokter hasil filter
  List<Outpatient> get filteredOutpatients {
    List<Outpatient> list = outpatients;
    // Filter teks
    if (searchQuery.value.isNotEmpty) {
      list = list.where((outpatient) {
        final query = searchQuery.value.toLowerCase();
        return outpatient.code.toLowerCase().contains(query) ||
            outpatient.polyclinic.toLowerCase().contains(query) ||
            outpatient.code.toLowerCase().contains(query);
      }).toList();
    }

    return list;
  }

  // Daftar dokter hasil filter
  List<Inpatient> get filteredInpatients {
    List<Inpatient> list = inpatients;
    // Filter teks
    if (searchQuery.value.isNotEmpty) {
      list = list.where((outpatient) {
        final query = searchQuery.value.toLowerCase();
        return outpatient.doctor.toLowerCase().contains(query) ||
            outpatient.polyclinic.toLowerCase().contains(query) ||
            outpatient.insurance.toLowerCase().contains(query) ||
            outpatient.registerDate.toLowerCase().contains(query);
      }).toList();
    }

    return list;
  }
  Future<void> loadSoap(String noRawat) async {
    isLoadingSoap.value = true;
    soapList.value = await SoapService().fetchSoap(noRawat);
    isLoadingSoap.value = false;
  }
  Future<void> loadSep(String noRawat) async {
    try {
      isLoadingSep.value = true;
      sepData.value = null;

      final result = await SepService().fetchSep(noRawat);

      if (result != null) {
        sepData.value = result;
      }

    } catch (e) {

    } finally {
      isLoadingSep.value = false;
    }
  }
  Future<void> loadDiagnosaProsedur(String noRawat) async {
    isLoadingDiagnosa.value = true;

    final data = await DiagnosaService().fetchData(noRawat);

    diagnosaList.value = (data['diagnosa'] as List)
        .map((e) => Diagnosa.fromJson(e))
        .toList();

    prosedurList.value = (data['prosedur'] as List)
        .map((e) => Prosedur.fromJson(e))
        .toList();

    isLoadingDiagnosa.value = false;
  }
  Future<void> loadTindakan(String noRawat) async {
    try {
      final data = await _tindakanService.fetchTindakan(noRawat);

      if (data['tindakan'] == null || data['tindakan'] is! List) {
        tindakanList.clear();
        return;
      }

      tindakanList.value =
          (data['tindakan'] as List).map((e) => Tindakan.fromJson(e)).toList();

    } catch (e) {
      print("ERROR TINDAKAN: $e");
      tindakanList.clear();
    }
  }

  Future<void> loadObat(String noRawat) async {
    try {
      final data = await _obatService.fetchObat(noRawat);

      if (data['obat'] == null || data['obat'] is! List) {
        obatList.clear();
        return;
      }

      obatList.value =
          (data['obat'] as List).map((e) => Obat.fromJson(e)).toList();

    } catch (e) {
      print("ERROR OBAT: $e");
      obatList.clear();
    }
  }

  Future<void> loadTindakanRanapDokter(String noRawat) async {
    final data = await _tindakanRanapDokterService.fetch(noRawat);

    if (data['tindakan_ranap_dokter'] is List) {
      tindakanRanapDokterList.value =
          (data['tindakan_ranap_dokter'] as List)
              .map((e) => TindakanRanapDokter.fromJson(e))
              .toList();
    } else {
      tindakanRanapDokterList.clear();
    }
  }

  var labList = <LabItem>[].obs;

  Future<void> loadLab(String noRawat) async {
    labList.value = await _labService.fetchLab(noRawat);
  }

  Future<void> loadRadiologi(String noRawat) async {
    radiologiData.value = await _radiologiService.fetchRadiologi(noRawat);
  }
  var operasiData = Rx<OperasiModel?>(null);
  final _operasiService = OperasiService();

  Future<void> loadOperasi(String noRawat) async {
    operasiData.value = await _operasiService.fetchOperasi(noRawat);
  }

}
