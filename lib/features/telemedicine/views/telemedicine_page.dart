import 'package:ausy/core/helpers/date_helper.dart';
import 'package:ausy/core/models/category.dart';
import 'package:ausy/core/themes/app_colors.dart';
import 'package:ausy/core/widgets/custom_textbox.dart';
import 'package:ausy/core/widgets/custom_appbar.dart';
import 'package:ausy/features/doctor/controllers/doctor_controller.dart';
import 'package:ausy/features/doctor/views/widgets/category_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:lottie/lottie.dart';

class TelemedicinePage extends StatefulWidget {
  const TelemedicinePage({super.key});

  @override
  State<TelemedicinePage> createState() => _TelemedicinePageState();
}

class _TelemedicinePageState extends State<TelemedicinePage> {
  final DoctorController doctorController =
      Get.put(DoctorController(), permanent: true);
  final TextEditingController dateController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      doctorController.doctors.clear();
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
        title: "Telemedicine",
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

    if (dateController.text.isNotEmpty) {
      try {
        initialDate = DateFormat('yyyy-MM-dd').parse(dateController.text);
      } catch (e) {
        initialDate =
            DateTime.now(); // Jika parsing gagal, gunakan tanggal sekarang
      }
    }
    showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(DateTime.now().year + 1),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              dialogTheme: DialogThemeData(
                backgroundColor: Colors.white,
              ),
            ),
            child: child!,
          );
        }).then((value) {
      if (value == null) {
        return;
      }
      final String formatted = DateFormat('yyyy-MM-dd').format(value);
      dateController.text = DateFormat('yyyy-MM-dd').format(value);
      doctorController.setSelectedDate(formatted);
    });
  }

  Widget _buildBody(BuildContext context) {
    final shifts = ['Semua', 'Pagi', 'Sore', 'Malam'];

    return Obx(() {
      return SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Search Box
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextBox(
                        hint: "Cari dokter atau poli",
                        prefix: const Icon(
                          Icons.search,
                          color: Colors.grey,
                          size: 16,
                        ),
                        controller: searchController,
                        textInputAction: TextInputAction.search,
                        keyboardType: TextInputType.text,
                        onSubmitted: (value) {
                          doctorController.changeQuery(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Shift Filter
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(bottom: 5, top: 5, left: 15),
                  child: Row(
                    children: List.generate(
                      shifts.length,
                      (index) => CategoryItem(
                        data: Category(id: index, name: shifts[index]),
                        isSelected: shifts[index] ==
                            doctorController.selectedShift.value,
                        onTap: () {
                          setState(() {
                            doctorController.changeShift(shifts[index]);
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),

              // Tampilkan Tanggal Terpilih
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 15, bottom: 0),
                child: Row(
                  children: [
                    const Text(
                      "Tanggal : ",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      formatTanggalIndo(
                          DateTime.parse(doctorController.date.value)),
                      style: const TextStyle(
                          fontSize: 14,
                          color: AppColor.primary,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              // List of Doctors
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: doctorController.isLoading.value
                    ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return Shimmer.fromColors(
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
                          );
                        },
                      )
                    : doctorController.filteredDoctors.isNotEmpty
                        ? ListView.builder(
                            itemCount: doctorController.filteredDoctors.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final doctor =
                                  doctorController.filteredDoctors[index];
                              final imageAsset = doctor.gender == 'L'
                                  ? 'assets/images/male.png'
                                  : 'assets/images/female.png';

                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.white,
                                  border:
                                      Border.all(color: Colors.grey.shade200),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        imageAsset,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            doctor.name,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            doctor.polyclinic,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            "Jam: ${doctor.start} - ${doctor.end}",
                                            style:
                                                const TextStyle(fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : _buildEmptyState(context),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.15,
        right: 20.5,
        left: 20.5,
      ),
      child: Column(
        children: [
          Lottie.asset(
            'assets/lottie/no-data.json', // Ganti path sesuai file kamu
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 10),
          const Text(
            'Ooops , tidak ada data.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Maaf data yang anda cari tidak ditemukan.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
