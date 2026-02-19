import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/models/notification.dart';
import '../../../core/services/notification_service.dart';

class NotificationController extends GetxController {
  final NotificationService _service = NotificationService();
  final GetStorage storage = GetStorage();

  /// list notifikasi
  final RxList<Notification> notifications = <Notification>[].obs;

  /// ID notifikasi yang sudah dibaca
  final RxSet<String> readIds = <String>{}.obs;

  /// loading
  final RxBool isLoading = false.obs;





  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;

      final noRkmMedis = storage.read('medicalRecord') ?? '';
      if (noRkmMedis.isEmpty) {
        notifications.clear();
        return;
      }

      final raw = await _service.fetchNotificationList(noRkmMedis);
      notifications.assignAll(raw);
    } catch (e) {
      notifications.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// cek read / unread
  bool isRead(String id) => readIds.contains(id);

  /// tandai notifikasi sudah dibaca
  Future<void> markAsRead(String id) async {
    if (readIds.contains(id)) return;

    // 1️⃣ update UI dulu (instant feedback)
    readIds.add(id);
    _saveReadIds();

    // 2️⃣ sync ke backend (tidak blok UI)
    try {
      final success = await _service.markNotificationAsRead(id);

      // optional: rollback kalau gagal
      if (!success) {
        // bisa diabaikan atau rollback
        // readIds.remove(id);
      }
    } catch (_) {
      // sengaja dikosongkan supaya UI tetap jalan
    }
  }


  /// jumlah UNREAD (badge)
  int get unreadCount =>
      notifications.where((n) => !readIds.contains(n.id)).length;

  /// simpan status read ke local storage
  void _saveReadIds() {
    storage.write('read_notification_ids', readIds.toList());
  }

  /// load status read dari local storage
  void _loadReadIds() {
    final saved = storage.read<List>('read_notification_ids');
    if (saved != null) {
      readIds.addAll(saved.cast<String>());
    }
  }
  /// badge = jumlah UNREAD
  int get notificationCount =>
      notifications.where((n) => !readIds.contains(n.id)).length;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }
}
