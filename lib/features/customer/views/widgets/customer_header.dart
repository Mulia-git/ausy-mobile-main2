import 'package:ausy/core/models/customer.dart';
import 'package:ausy/core/themes/app_colors.dart';
import 'package:ausy/core/widgets/custom_image.dart';
import 'package:ausy/features/customer/views/widgets/notification_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerHeader extends StatelessWidget {
  const CustomerHeader(
      {super.key, required this.customer, this.fit = BoxFit.cover});

  final Customer? customer;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomImage(
                customer!.profilePicture,
                width: 42,
                height: 42,
                radius: 26,
                fit: fit,
                isShadow: true,
                isNetwork: false,
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer!.name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      customer!.medicalRecord,
                      style: const TextStyle(
                        color: AppColor.labelColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        NotificationBox(
          notifiedNumber: 0,
          onTap: () {
            Get.toNamed('/notification');
          },
        )
      ],
    );
  }
}
