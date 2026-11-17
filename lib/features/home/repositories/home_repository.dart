import 'package:flutter/material.dart';

import '../models/home_report.dart';

/// Sumber data kartu laporan beranda. Saat ini masih data contoh lokal.
class HomeRepository {
  static const List<HomeReport> reports = [
    HomeReport(
      title: 'Jalan berlubang di depan RT01',
      description:
          'Jalan Berlubang dan Membahayakan pengendara, '
          'terutama saat hujan.',
      status: 'Diproses',
      image: 'assets/images/jalan_berlubang.png',
      fallbackIcon: Icons.add_road,
    ),
    HomeReport(
      title: 'Lampu Jalan Mati',
      description:
          'Lampu jalan tidak menyala pada malam hari '
          'sehingga area menjadi gelap.',
      status: 'Ditangani',
      image: 'assets/images/lampu_jalan_mati.png',
      fallbackIcon: Icons.lightbulb_outline,
    ),
    HomeReport(
      title: 'Saluran Air Tersumbat',
      description:
          'Air tidak mengalir dan mulai menggenang '
          'di sekitar selokan.',
      status: 'Selesai',
      image: 'assets/images/saluran_air_.png',
      fallbackIcon: Icons.water_drop_outlined,
    ),
    HomeReport(
      title: 'Bantuan untuk warga terdampak banjir',
      description:
          'Memerlukan bantuan logistik seperti '
          'makanan, air bersih, dan selimut.',
      status: 'Diproses',
      image: 'assets/images/bantuan_banjir.png',
      fallbackIcon: Icons.flood_outlined,
    ),
  ];

  List<HomeReport> getReports() => List<HomeReport>.unmodifiable(reports);
}
