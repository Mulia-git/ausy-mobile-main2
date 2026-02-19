import 'package:ausy/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class AccountAppBar extends StatelessWidget {
  const AccountAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Akun Saya",
          style: TextStyle(
            color: AppColor.textColor,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
