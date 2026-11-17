import 'package:flutter/material.dart';

import '../models/notification_data.dart';

/// Sumber data notifikasi demo (belum terhubung ke server).
class NotifikasiRepository {
  const NotifikasiRepository();

  static const Color _green = Color(0xFF08935B);
  static const Color _neutral = Color(0xFF506788);

  static const List<NotificationData> today = [
    NotificationData(
      title: 'Laporan berhasil dikirim',
      message:
          'Laporan “Jalan Rusak” telah berhasil dikirim dan '
          'sedang menunggu proses verifikasi oleh RT.',
      time: '2 menit yang lalu',
      icon: Icons.description_outlined,
      iconColor: _green,
    ),
    NotificationData(
      title: 'Laporan dalam proses',
      message:
          'Laporan “Lampu Jalan Mati” sedang '
          'ditindaklanjuti oleh RT.',
      time: '1 jam yang lalu',
      icon: Icons.hourglass_empty_rounded,
      iconColor: Color(0xFFFFA000),
    ),
    NotificationData(
      title: 'Ada pembaruan dari RT',
      message:
          'RT 02 telah menambahkan catatan pada '
          'laporan “Sampah Menumpuk”.',
      time: '3 jam yang lalu',
      icon: Icons.chat_bubble_rounded,
      iconColor: Color(0xFF087BFF),
      kind: NotificationIconKind.chat,
    ),
    NotificationData(
      title: 'Laporan selesai',
      message:
          'Laporan “Saluran Air Tersumbat” telah '
          'diselesaikan.',
      time: '5 jam yang lalu',
      icon: Icons.check_rounded,
      iconColor: _green,
      kind: NotificationIconKind.completed,
    ),
  ];

  static const List<NotificationData> yesterday = [
    NotificationData(
      title: 'Selamat datang di LaporDesa!',
      message:
          'Yuk, mulai buat laporan untuk lingkungan '
          'yang lebih baik.',
      time: '1 hari yang lalu',
      icon: Icons.notifications_none_rounded,
      iconColor: _neutral,
    ),
  ];

  List<NotificationData> getToday() => today;
  List<NotificationData> getYesterday() => yesterday;
}
