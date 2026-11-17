import 'package:flutter/material.dart';

/// Jenis tampilan ikon notifikasi.
enum NotificationIconKind { standard, chat, completed }

/// Data yang ditampilkan dalam sebuah kartu notifikasi.
class NotificationData {
  const NotificationData({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.iconColor,
    this.kind = NotificationIconKind.standard,
  });

  final String title;
  final String message;
  final String time;
  final IconData icon;
  final Color iconColor;
  final NotificationIconKind kind;
}
