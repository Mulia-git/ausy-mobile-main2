import 'package:ausy/core/models/doctor.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorItem extends StatelessWidget {
  const DoctorItem({
    super.key,
    required this.data,
  });

  final Doctor data;

  @override
  Widget build(BuildContext context) {
    final imageAsset = data.gender == 'L'
        ? 'assets/images/male.png'
        : 'assets/images/female.png';

    return SizedBox(
      height: 130,
      child: GestureDetector(
        onTap: () {
          Get.toNamed(
            '/app',
            arguments: {

              'doctorId': data.code,
              'doctorName': data.name,


              'polyCode': data.polyCode,
              'polyName': data.polyclinic,
              'polyStart': data.start,
              'polyFinish': data.end,
            },
          );
        },
        child: Container(
          width: 220,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 50,
                  height: 70, // lebih tinggi biar proporsional
                  child: Align(
                    alignment: Alignment.topCenter, // fokus wajah–dada
                    heightFactor: 0.6, // 🔥 crop setengah badan
                    child: data.photo.trim().isNotEmpty
                        ? Image.network(
                      data.photo,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        imageAsset,
                        fit: BoxFit.cover,
                      ),
                    )
                        : Image.asset(
                      imageAsset,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      data.name,
                      maxLines: 2,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    AutoSizeText(
                      data.polyclinic,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 16, color: Colors.green),
                        const SizedBox(width: 4),
                        Text(
                          "${data.start} - ${data.end}",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
