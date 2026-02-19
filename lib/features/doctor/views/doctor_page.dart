import 'package:ausy/core/helpers/date_helper.dart';
import 'package:ausy/core/models/category.dart';
import 'package:ausy/core/themes/app_colors.dart';
import 'package:ausy/core/widgets/custom_textbox.dart';
import 'package:ausy/core/widgets/custom_appbar.dart';
import 'package:ausy/features/book/controllers/book_controller.dart';
import 'package:ausy/features/doctor/controllers/doctor_controller.dart';
import 'package:ausy/features/doctor/views/widgets/category_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:lottie/lottie.dart';

class DoctorPage extends StatefulWidget {
  const DoctorPage({super.key});

  @override
  State<DoctorPage> createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  final DoctorController doctorController =
  Get.put(DoctorController(), permanent: true);

  final BookController bookController =
  Get.put(BookController(), permanent: true);

  final TextEditingController dateController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      doctorController.changeQuery('');
      doctorController.changeShift("Semua");
      doctorController
          .setSelectedDate(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: "Jadwal Dokter",
        backgroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.primary,
        onPressed: () => _selectDate(context),
        child: const Icon(Icons.date_range, color: Colors.white),
      ),
      body: _buildBody(context),
    );
  }

  void _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();

    showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(DateTime.now().year + 1),
    ).then((value) {
      if (value == null) return;
      final formatted = DateFormat('yyyy-MM-dd').format(value);
      dateController.text = formatted;
      doctorController.setSelectedDate(formatted);
      searchController.clear();
    });
  }

  Widget _buildBody(BuildContext context) {
    final shifts = ['Semua', 'Pagi', 'Sore', 'Malam'];

    return Obx(() {
      final hasBooking = bookController.activeBooking.value != null;

      return SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔍 SEARCH
              Padding(
                padding: const EdgeInsets.all(15),
                child: CustomTextBox(
                  hint: "Cari dokter atau poli",
                  prefix: const Icon(Icons.search, size: 16),
                  controller: searchController,
                  onSubmitted: doctorController.changeQuery,
                ),
              ),

              /// 🕒 SHIFT FILTER
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      shifts.length,
                          (i) => CategoryItem(
                        data: Category(id: i, name: shifts[i]),
                        isSelected:
                        shifts[i] == doctorController.selectedShift.value,
                        onTap: () => doctorController.changeShift(shifts[i]),
                      ),
                    ),
                  ),
                ),
              ),

              /// 📅 TANGGAL
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  "Tanggal: ${formatTanggalIndo(DateTime.parse(doctorController.date.value))}",
                  style: const TextStyle(
                      color: AppColor.primary, fontWeight: FontWeight.bold),
                ),
              ),

              /// 👨‍⚕️ LIST DOKTER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: doctorController.isLoading.value
                    ? _buildLoading()
                    : doctorController.filteredDoctors.isEmpty
                    ? _buildEmptyState(context)
                    : ListView.builder(
                  itemCount: doctorController.filteredDoctors.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final doctor =
                    doctorController.filteredDoctors[index];

                    final imageAsset = doctor.gender == 'L'
                        ? 'assets/images/male.png'
                        : 'assets/images/female.png';

                    return Opacity(
                      opacity: hasBooking ? 0.5 : 1,
                      child: InkWell(
                        onTap: hasBooking
                            ? null
                            : () {
                          bookController.setFromSchedule(
                            doctor: doctor,
                            date: doctorController.date.value,
                          );
                          Get.toNamed('/app');

                        },
                        child: Container(
                          margin:
                          const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.grey.shade200),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: SizedBox(
                                  width: 70,
                                  height: 90, // tinggi card foto
                                  child: Align(
                                    alignment: Alignment.topCenter, // fokus ke bagian atas (wajah-dada)
                                    heightFactor: 0.6, // ⬅️ ini yang memotong bawah
                                    child: Image.network(
                                      doctor.photo,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Image.asset(
                                        imageAsset,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),


                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(doctor.name,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight:
                                            FontWeight.bold)),
                                    Text(doctor.polyclinic),
                                    Text(
                                        "Jam: ${doctor.start} - ${doctor.end}"),
                                  ],
                                ),
                              ),

                              if (hasBooking)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius:
                                    BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    "Booking Aktif",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildLoading() {
    return ListView.builder(
      itemCount: 5,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(top: 80),
      child: Column(
        children: [
          Lottie.asset('assets/lottie/no-data.json', width: 180),
          const SizedBox(height: 10),
          const Text('Tidak ada jadwal dokter.'),
        ],
      ),
    );
  }
}
