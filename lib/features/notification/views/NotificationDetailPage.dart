import 'package:flutter/material.dart' hide Notification;
import 'package:get/get.dart';
import '../../../core/models/notification.dart';
import '../controllers/notification_controller.dart';

class NotificationDetailPage extends StatelessWidget {
  final Notification notif;

  const NotificationDetailPage({super.key, required this.notif});

  @override
  Widget build(BuildContext context) {
    final NotificationController controller =
    Get.find<NotificationController>();
    if (!controller.isRead(notif.id)) {
      controller.markAsRead(notif.id);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Notifikasi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notif.judul,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              notif.pesan,
              style: const TextStyle(fontSize: 14),
            ),
            if (notif.url.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                'Tautan:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                notif.url,
                style: const TextStyle(color: Colors.blue),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
