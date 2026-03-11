import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class PremiumPanicButton extends StatefulWidget {
  final VoidCallback onTap;

  const PremiumPanicButton({super.key, required this.onTap});

  @override
  State<PremiumPanicButton> createState() => _PremiumPanicButtonState();
}

class _PremiumPanicButtonState extends State<PremiumPanicButton>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(_) {
    setState(() => _isPressed = true);
  }

  void _onTapUp(_) {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () => setState(() => _isPressed = false),
      child: ScaleTransition(
        scale: _pulseAnimation,
        child: AnimatedScale(
          scale: _isPressed ? 0.92 : 1.0,
          duration: const Duration(milliseconds: 120),
          child: Container(
            height: 78,
            width: 78,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFF4D4F),
                  Color(0xFFD9363E),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.6),
                  blurRadius: 25,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: SvgPicture.asset(
                "assets/icons/ambulance.svg",
                width: 36,
                height: 36,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}