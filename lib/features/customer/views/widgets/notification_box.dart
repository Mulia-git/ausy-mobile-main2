import 'package:flutter/material.dart';

class NotificationBox extends StatelessWidget {
  const NotificationBox({
    super.key,
    this.onTap,
    this.size = 5,
    this.notifiedNumber = 0,
  });

  final GestureTapCallback? onTap;
  final int notifiedNumber;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(size),
        child: notifiedNumber > 0 ? _buildIconNotified() : _buildIcon(),
      ),
    );
  }

  Widget _buildIconNotified() {
    return Badge(
      child: _buildIcon(),
    );
  }

  Widget _buildIcon() {
    return const Icon(
     Icons.notifications,
      size: 25,

    );
  }
}
