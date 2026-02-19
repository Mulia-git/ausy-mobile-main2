import 'package:ausy/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class BlogAppBar extends StatelessWidget {
  const BlogAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Artikel",
                style: TextStyle(
                  color: AppColor.textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
