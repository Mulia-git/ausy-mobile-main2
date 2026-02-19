import 'package:auto_size_text/auto_size_text.dart';
import 'package:ausy/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    required this.title,
    this.actions,
    this.backgroundColor = AppColor.appBarColor,
    this.textColor = AppColor.textColor,
    super.key,
  });
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final List<Widget>? actions;

  @override
  build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: textColor),
      backgroundColor: backgroundColor,
      elevation: 0,
      title: AutoSizeText(
        title,
        maxLines: 1,
        style: TextStyle(color: textColor),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}

class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Start from top-left corner
    path.moveTo(0, size.height * 0.2);

    // First wave curve
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.1,
        size.width * 0.5, size.height * 0.2);

    // Second wave curve
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.3, size.width, size.height * 0.2);

    // Line to top-right corner
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
