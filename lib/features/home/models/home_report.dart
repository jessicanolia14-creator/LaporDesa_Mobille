import 'package:flutter/material.dart';

/// Data laporan ringkas untuk kartu beranda (data simulasi).
class HomeReport {
  const HomeReport({
    required this.title,
    required this.description,
    required this.status,
    required this.image,
    required this.fallbackIcon,
  });

  final String title;
  final String description;
  final String status;
  final String image;
  final IconData fallbackIcon;
}
