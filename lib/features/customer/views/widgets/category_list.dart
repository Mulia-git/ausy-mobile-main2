import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {
        'label': 'Jadwal Dokter',
        'icon': 'assets/images/doctor.svg',
      },
      {
        'label': 'Antrean Poli',
        'icon': 'assets/images/antrean_poli.svg',
      },
      {
        'label': 'Antrean Apotek',
        'icon': 'assets/images/antrean_apotek.svg',
      },
      // {
      //   'label': 'Rawat Jalan',
      //   'icon': 'assets/images/outpatient.svg',
      // },
      // {
      //   'label': 'Rawat Inap',
      //   'icon': 'assets/images/patient.svg',
      // },
      {
        'label': 'Kamar Tersedia',
        'icon': 'assets/images/search.svg',
      },
    ];

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final category = categories[index];
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  switch (index) {
                    case 0:
                      // Aksi untuk Jadwal Dokter
                      Get.toNamed('/doctor');
                      break;
                    case 1:
                      // Aksi untuk Rawat Jalan
                      // Get.toNamed('/polyclinic');
                      Get.toNamed('/antreanPoli');
                      break;
                    case 2:
                      // Aksi untuk Rawat Inap
                      // Get.toNamed('/room');
                      Get.toNamed('/antreanApotek');
                      break;
                    case 3:
                      // Aksi untuk Kamar Tersedia
                      Get.toNamed('/available');
                      break;
                  }
                },
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF63B790), // Hijau Muda
                        Color(0xFF70BD97), // Hijau Tua
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(category['icon'],
                        width: 36,
                        height: 36,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        )),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                child: Text(
                  category['label'],
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
