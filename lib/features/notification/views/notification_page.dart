import 'package:flutter/material.dart' hide Notification;
import 'package:get/get.dart';
import '../controllers/notification_controller.dart';
import '../../../core/models/notification.dart';
import 'NotificationDetailPage.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  String shortText(String text, {int max = 60}) {
    if (text.length <= max) return text;
    return '${text.substring(0, max)}...';
  }

  @override
  Widget build(BuildContext context) {
    final NotificationController controller =
    Get.find<NotificationController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF63B790),
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return const Center(
            child: Text(
              'Tidak ada notifikasi',
              style: TextStyle(fontSize: 14),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchNotifications,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final Notification notif = controller.notifications[index];
              final bool isRead = controller.isRead(notif.id);

              return InkWell(
                onTap: () async {
                  await controller.markAsRead(notif.id);

                  Get.to(() => NotificationDetailPage(notif: notif));
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isRead
                        ? Colors.white
                        : const Color(0xFFf3f9f6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isRead
                          ? Colors.grey.shade300
                          : const Color(0xFF63B790),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Icon(
                            Icons.notifications,
                            color: isRead
                                ? Colors.grey
                                : const Color(0xFF63B790),
                          ),
                          if (!isRead)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notif.judul,
                              style: TextStyle(
                                fontWeight: isRead
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              shortText(notif.pesan),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
