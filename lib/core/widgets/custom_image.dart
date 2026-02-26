import 'package:cached_network_image/cached_network_image.dart';
import 'package:ausy/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  const CustomImage(this.image, {
    super.key,
    this.width = 100,
    this.height = 100,
    this.bgColor,
    this.borderWidth = 0,
    this.borderColor,
    this.trBackground = false,
    this.fit = BoxFit.cover,
    this.radius = 50,
    this.borderRadius,
    this.isShadow = true,
  });

  final String image;
  final double width;
  final double height;
  final double borderWidth;
  final bool isShadow;
  final Color? borderColor;
  final Color? bgColor;
  final bool trBackground;
  final double radius;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit fit;

  bool get _isNetwork =>
      image.startsWith('http');

  @override
  @override
  Widget build(BuildContext context) {
    final bool isUrl = image.startsWith('http');

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(radius),
      ),
      child: isUrl
          ? CachedNetworkImage(
        imageUrl: image,
        fit: fit,
        placeholder: (_, __) => const SizedBox(),
        errorWidget: (_, __, ___) =>
        const Icon(Icons.broken_image),
      )
          : Image.asset(
        image,
        fit: fit,
      ),
    );
  }
}
