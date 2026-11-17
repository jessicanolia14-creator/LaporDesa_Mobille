import '../models/notification_data.dart';
import '../repositories/notifikasi_repository.dart';

/// Menghubungkan halaman notifikasi dengan sumber data.
class NotifikasiViewModel {
  NotifikasiViewModel({NotifikasiRepository? repository})
    : _repository = repository ?? const NotifikasiRepository();

  final NotifikasiRepository _repository;

  List<NotificationData> get today => _repository.getToday();
  List<NotificationData> get yesterday => _repository.getYesterday();
}
